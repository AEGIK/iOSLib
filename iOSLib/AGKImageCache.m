//
//  AGKImageCache.m
//  iOSLib
//
//  Created by Christoffer Lernö on 2011-19-05.
//  Copyright 2011 AEGIK AB. All rights reserved.
//

#import "AGKImageCache.h"


#import "AGKRemoteImageCache.h"
#import "NSURLConnection+Extras.h"
#import "AGK.h"
#import "NSArray+Extras.h"
#import "NSMutableArray+Extras.h"
#import "UIImage+Extras.h"
#import "NSFileManager+Extras.h"
#import "NSString+URLEncode.h"
#import "NSString+Hash.h"
#import "AGKRepeatingEventCentral.h"
#import "UIDevice+Extras.h"

static NSMutableDictionary *caches = nil;
static const NSUInteger MaxEntries = 200;

@interface AGKImageRequestHandle() {}
- (id)initWithCallback:(AGKImageCallback)theBlock;
- (void)receivedImage:(AGKImage *)image;
@property (nonatomic, copy) AGKImageCallback callback;
@end

@interface AGKImageCache() {}
- (id)initWithName:(NSString *)name;
@property (nonatomic, retain) NSCache *cache;
@property (nonatomic, retain) NSMutableDictionary *workingRequests;
@property (nonatomic, assign) NSUInteger hits;
@property (nonatomic, assign) NSUInteger coalesced;
@property (nonatomic, assign) NSUInteger misses;
@end

@implementation AGKImageCache

@dynamic name;
@synthesize cache, hits, misses, workingRequests, coalesced;

+ (AGKImageCache *)sharedCacheNamed:(NSString *)cacheName {
	if (!caches) {
		caches = [[NSMutableDictionary alloc] initWithCapacity:3];
	}
	AGKImageCache *theCache = [caches objectForKey:cacheName];
	if (!theCache) {
		theCache = [[AGKImageCache alloc] initWithName:cacheName];
		[caches setObject:theCache forKey:cacheName];
		[theCache release];
		AGKTrace(@"Created image cache '%@'.", cacheName); 
	}
	return theCache;
}

- (void)lowMemory:(NSNotification *)notification 
{
    AGKLog(@"Dumping cache %@ in response to low memory", [self name]);
    [[self cache] removeAllObjects];
    AGKLog(@"Memory is now: %lukb", [[UIDevice currentDevice] freeMemory] / 1024);
}

- (void)logStats 
{
    NSUInteger total = [self hits] + [self misses];
    if (!total) return;
    // Cache "Spotlight" - 200 request(s), 25% hit
    AGKLog(@"Cache \"%@\" - %d request(s), %.0f%% hit",
           [self name], total, [self hits] * 100 / (double)(total ? total : 1));
    [self setHits:0];
    [self setMisses:0];
}
- (id)initWithName:(NSString *)name {
	if ((self = [super init])) {
        cache = [[NSCache alloc] init];
		[cache setCountLimit:200];
		[cache setName:name];
        [cache setDelegate:self];
        workingRequests = [[NSMutableDictionary alloc] initWithCapacity:10];
        [[AGKRepeatingEventCentral sharedInstance] addObserver:self selector:@selector(logStats) forEvent:AGKRepeatingEvent1min];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(lowMemory:) name:UIApplicationDidReceiveMemoryWarningNotification object:[UIApplication sharedApplication]];
	}
	return self;
}

- (NSString *)name {
	return [[self cache] name];
}

#pragma mark -
#pragma mark Image loading

- (void)setMaxImages:(NSUInteger)maxImages;
{
    [[self cache] setCountLimit:maxImages];
}

- (void)cache:(NSCache *)cache willEvictObject:(id)obj
{
    AGKTrace(@"%@ cache ejected object", [self name]);
}

- (void)completedImage:(AGKImage *)image forKey:(NSString *)key 
{
    NSArray *waitingArray = [[[self workingRequests] objectForKey:key] retain];
    [[self workingRequests] removeObjectForKey:key];
    if (image) {
        [[self cache] setObject:image forKey:key];
    }
    for (AGKImageRequestHandle *handle in waitingArray) {
        [handle receivedImage:image];
    }
    [waitingArray release];
}

- (void)modifyImage:(AGKImage *)image forKey:(NSString *)key modifier:(AGKImageModifier)modifier 
{
    static NSOperationQueue *imageModQueue = nil;
    if (!imageModQueue) {
        imageModQueue = [[NSOperationQueue alloc] init];
        [imageModQueue setMaxConcurrentOperationCount:5];
        [imageModQueue setName:@"ImageModificationQueue"];
    }
    [imageModQueue addOperationWithBlock:^{
        AGKImage *newImage = modifier(image);
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self completedImage:newImage forKey:key];                    
        }];
    }];
}

- (AGKImage *)retrieveImage:(NSString *)imageName image:(AGKImage *)image modifier:(AGKImageModifier)modifier
{
	AGKImage *cached = [[self cache] objectForKey:imageName];
    if (cached) {
        hits++;
        return cached;
    }
    AGKImage *result = modifier(image);
    if (result) {
        [[self cache] setObject:result forKey:imageName];
    }
    return result;    
}

- (AGKImageRequestHandle *)retrieveImage:(NSString *)imageName image:(AGKImageLoader)imageLoader modifier:(AGKImageModifier)modifier load:(AGKImageCallback)block
{
	AGKImage *cached = [[self cache] objectForKey:imageName];
    if (cached) {
        hits++;
        block(cached);
        return nil;
    }
    NSMutableArray *working = [[self workingRequests] objectForKey:imageName];
    if (working) {
        coalesced++;
        if (!block) return nil;
        AGKImageRequestHandle *handle = [[AGKImageRequestHandle alloc] initWithCallback:block];
        [working addObject:handle];
        [handle release];
        return handle;
    }
    
    misses++;
    AGKImageRequestHandle *handle = nil;
    NSMutableArray *array;
    if (block) {
        handle = [[[AGKImageRequestHandle alloc] initWithCallback:block] autorelease];
        array = [[NSMutableArray alloc] initWithObjects:handle, nil];
    } else {
        array = [[NSMutableArray alloc] initWithCapacity:2];
    }
    [[self workingRequests] setObject:array forKey:imageName];
    [array release];
    imageLoader(^(AGKImage *image) {
        if (!modifier) {
            [self completedImage:image forKey:imageName];
        } else {
            [self modifyImage:image forKey:imageName modifier:modifier];
        }
    });
    return handle;
}

@end

@implementation AGKImageRequestHandle

@synthesize callback;

- (id)initWithCallback:(AGKImageCallback)theBlock 
{
    if ((self = [super init])) {
        callback = [theBlock copy];
    }
    return self;
}

- (void)receivedImage:(AGKImage *)image 
{
    if (callback) callback(image);
}

- (void)cancel 
{
    [self setCallback:nil];
}

- (void)dealloc 
{
    [callback release];
    [super dealloc];
}

@end