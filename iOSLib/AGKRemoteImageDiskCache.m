//
//  AGKRemoteImageDiskCache.m
//  iOSLib
//
//  Created by Christoffer Lernö on 2011-19-05.
//  Copyright 2011 AEGIK AB. All rights reserved.
//

#import "AGKRemoteImageDiskCache.h"
#import "NSURLConnection+Extras.h"
#import "AGK.h"
#import "NSArray+Extras.h"
#import "UIImage+Extras.h"
#import "NSFileManager+Extras.h"
#import "NSString+URLEncode.h"
#import "NSString+Hash.h"
#import "AGKRepeatingEventCentral.h"

static NSOperationQueue *cacheQueue = nil;
static NSMutableDictionary *caches = nil;
static const NSUInteger MaxEntries = 200;
static const NSInteger MaxSimultaneousRequests = 5;

#ifndef NDEBUG
static BOOL failAll = NO;
#endif

@interface AGKRemoteImageDiskCacheRequestHandle() {}
- (id)initWithCache:(AGKRemoteImageDiskCache *)theCache filename:(NSString *)theFilename block:(AGKRemoteImageLoaded)theBlock;
@property (nonatomic, strong) AGKRemoteImageDiskCache *cache;
@property (nonatomic, weak) AGKRemoteImageLoaded block;
@property (nonatomic, strong) NSString *filename;
@end

@interface AGKRemoteImageDiskCache() {}
- (id)initWithName:(NSString *)name;
- (NSMutableArray *)loadDiskCache;
- (void)logStats;
- (AGKRemoteImageDiskCacheRequestHandle *)loadImage:(NSString *)filename imageType:(AGKImageType)imageType finished:(AGKRemoteImageLoaded)block;
- (AGKRemoteImageDiskCacheRequestHandle *)loadRemote:(NSString *)URL filename:(NSString *)filename imageType:(AGKImageType)imageType finished:(AGKRemoteImageLoaded)block;

@property (nonatomic, strong) NSMutableSet *pendingRequests;
@property (nonatomic, strong) NSMutableArray *diskCache;
@property (nonatomic, strong) NSString *cacheDir;
@property (nonatomic, assign) NSUInteger hits;
@property (nonatomic, assign) NSUInteger misses;
@property (nonatomic, strong) NSMutableDictionary *loading;
@property (nonatomic, assign) NSUInteger coalesced;
@end


@implementation AGKRemoteImageDiskCache

@synthesize pendingRequests, loadTimeout, diskCacheSize, diskCache, cacheDir, hits, misses, name, coalesced, loading;

+ (NSOperationQueue *)cacheQueue {
    if (!cacheQueue) {
        cacheQueue = [[NSOperationQueue alloc] init];
        [cacheQueue setMaxConcurrentOperationCount:MaxSimultaneousRequests];
    }
    return cacheQueue;
}

+ (AGKRemoteImageDiskCache *)sharedCacheNamed:(NSString *)cacheName {
	if (!caches) {
		caches = [[NSMutableDictionary alloc] initWithCapacity:3];
	}
	AGKRemoteImageDiskCache *theCache = [caches objectForKey:cacheName];
	if (!theCache) {
		theCache = [[AGKRemoteImageDiskCache alloc] initWithName:cacheName];
		[caches setObject:theCache forKey:cacheName];
		AGKTrace(@"Created image disk cache '%@'.", cacheName); 
	}
	return theCache;
}

- (id)initWithName:(NSString *)theName {
	if ((self = [super init])) {
		[self setPendingRequests:[NSMutableSet setWithCapacity:10]];
        [self setDiskCacheSize:200];
        [self setCacheDir:[[NSFileManager directory:@"AGKRemoteImage" inUserDirectory:NSCachesDirectory] stringByAppendingPathComponent:name]];
        [self setDiskCache:[self loadDiskCache]];
        [self setLoading:[NSMutableDictionary dictionaryWithCapacity:10]];
        [[AGKRepeatingEventCentral sharedInstance] addObserver:self selector:@selector(logStats) forEvent:AGKRepeatingEvent1min];
	}
	return self;
}

- (NSMutableArray *)loadDiskCache
{
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSError *error = [fileManager setupDirectory:[self cacheDir]];
    if (error) {
        AGKLog(@"Failed to setup remote image cache '%@' directory: %@", [self name], error);
        return nil;
    }
    NSArray *filesInPath = [fileManager contentsOfDirectoryAtPath:[self cacheDir] error:&error];
    if (error) {
        AGKLog(@"Failed to open remote image cache '%@' directory: %@", [self name], error);
        return nil;
    }
    NSMutableArray *cachedImages = [NSMutableArray arrayWithCapacity:200];
    for (NSString *path in filesInPath) {
        if ([path rangeOfString:@"i_"].location == 0) {
            [cachedImages addObject:path];
        } else {
            [fileManager removeItemAtPath:[[self cacheDir] stringByAppendingPathComponent:path] error:NULL];
        }
    }                 
    AGKTrace(@"Loaded %d images from disk cache for '%@'", [cachedImages count], [self name]);
    return cachedImages;
}

- (void)logStats 
{
    NSUInteger total = [self hits] + [self misses];
    if (!total) return;
    // Cache "Spotlight" 200 entry(s) - Requests: 200 (5 coalesced, 3 pending) / 100% hit
    AGKLog(@"Cache \"%@\" %d entry(s) - Requests: %d (%d coalesced, %d pending) / %.0f%% hit",
           [self name], [[self diskCache] count], total, [self coalesced], [[self loading] count], [self hits] * 100 / (double)(total ? total : 1));
    [self setHits:0];
    [self setMisses:0];
}

#pragma mark -
#pragma mark Image loading

- (NSString *)filenameFromURL:(NSString *)url 
{
    return [NSString stringWithFormat:@"i_%@.%@", [url md5], [url pathExtension]];
}

- (void)updateDiskCache:(NSString *)url data:(NSData *)data
{
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    
    NSUInteger ejectedImages = 0;
    if ([[self diskCache] count] >= [self diskCacheSize] && [self diskCacheSize]) {
        ejectedImages = [self diskCacheSize] / 4 + 1;
        for (NSUInteger i = 0; i < ejectedImages; i++) {
            NSString *file = [[self diskCache] firstObject];
            if ([[self loading] objectForKey:file]) {
                AGKTrace(@"Cache '%@' skipping eject of %@.", [self name], file);
                continue;
            }
            [fileManager removeItemAtPath:[[self cacheDir] stringByAppendingPathComponent:file] error:NULL];
            [[self diskCache] removeFirst];            
        }
    }
    if (ejectedImages > 0) {
        AGKTrace(@"Cache '%@' ejected %d disk image(s)", [self name], ejectedImages);
    }
    
    NSString *file = [self filenameFromURL:url];
    [fileManager createFileAtPath:[[self cacheDir] stringByAppendingPathComponent:file] contents:data attributes:nil];
    [[self diskCache] addObject:file];
}

- (AGKRemoteImageDiskCacheRequestHandle *)remoteImage:(NSString *)URL finished:(AGKRemoteImageLoaded)block 
{
    return [self remoteImage:URL imageType:AGKImageTypeUnknown finished:block];
}

- (AGKRemoteImageDiskCacheRequestHandle *)remoteImage:(NSString *)URL imageType:(AGKImageType)imageType finished:(AGKRemoteImageLoaded)block 
{
#ifndef NDEBUG
    if (failAll) {
        if (block) block(nil);
        return nil;
    }
#endif
    
    if (imageType == AGKImageTypeUnknown) imageType = [URL imageType];
    if (imageType == AGKImageTypeUnknown) {
        AGKLog(@"Unknown format for image %@ - skipping request", URL);
        if (block) block(nil);
        return nil;
    }
    
    NSString *filename = [self filenameFromURL:URL]; 
    NSMutableArray *waitingBlocks = [[self loading] objectForKey:filename];
    if (waitingBlocks) {
        coalesced++;
        [waitingBlocks addObject:block];
        return [[AGKRemoteImageDiskCacheRequestHandle alloc] initWithCache:self filename:filename block:block];
    }
    if ([[self diskCache] containsObject:filename]) {
        hits++;
        [[self diskCache] removeObject:filename];
        [[self diskCache] addObject:filename];  
        return [self loadImage:filename imageType:imageType finished:block];        
    } else {
        misses++;
        return [self loadRemote:URL filename:filename imageType:imageType finished:block];
    }
}

- (AGKRemoteImageDiskCacheRequestHandle *)addLoadingBlock:(AGKRemoteImageLoaded)block filename:(NSString *)filename
{
    NSMutableArray *array = block ? [NSMutableArray arrayWithObject:block] : [NSMutableArray array];
    [[self loading] setObject:array forKey:filename];
    if (!block) return nil;
    return [[AGKRemoteImageDiskCacheRequestHandle alloc] initWithCache:self filename:filename block:block];
}

- (void)sendImage:(AGKImage *)image forFile:(NSString *)filename 
{
    NSArray *theArray = [[self loading] objectForKey:filename];
    [[self loading] removeObjectForKey:filename];
    for (AGKRemoteImageLoaded aBlock in theArray) {
        aBlock(image);
    }
}

- (void)loadImage:(NSString *)filename imageType:(AGKImageType)imageType {
    NSOperationQueue *queue = [AGKRemoteImageDiskCache cacheQueue];
    NSString *fullPath = [[self cacheDir] stringByAppendingPathComponent:filename];
    [queue addOperationWithBlock:^{
        CGImageRef imageRef = CGImageCreateFromFile(fullPath, imageType);
        AGKImage *image = [AGKImage imageWithCGImage:imageRef];
        if (imageRef) CGImageRelease(imageRef);
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self sendImage:image forFile:filename];
        }];
    }];    
}

- (AGKRemoteImageDiskCacheRequestHandle *)loadImage:(NSString *)filename imageType:(AGKImageType)imageType finished:(AGKRemoteImageLoaded)block {
    AGKRemoteImageDiskCacheRequestHandle *handle = [self addLoadingBlock:block filename:filename];
    [self loadImage:filename imageType:imageType];
    return handle;
}

- (AGKRemoteImageDiskCacheRequestHandle *)loadRemote:(NSString *)URL filename:(NSString *)filename imageType:(AGKImageType)imageType finished:(AGKRemoteImageLoaded)block {
    AGKRemoteImageDiskCacheRequestHandle *requestHandle = [self addLoadingBlock:block filename:filename];
    NSURLConnectionHandle *handle = [NSURLConnection download:URL toFile:[[self cacheDir] stringByAppendingPathComponent:[NSString stringWithFormat:@"temp_%@", filename]] completion:^(NSString *path, NSError *error) {
        if (error) {
            AGKTrace(@"Failed to load image %@", URL);
            [self sendImage:NULL forFile:filename];
            return;
        }
        NSUInteger ejectedImages = 0;
        NSFileManager *fileManager = [[NSFileManager alloc] init];
        [fileManager moveItemAtPath:path toPath:[[self cacheDir] stringByAppendingPathComponent:filename] error:NULL];
        if ([[self diskCache] count] >= [self diskCacheSize] && [self diskCacheSize]) {
            ejectedImages = [self diskCacheSize] / 4 + 1;
            for (NSUInteger i = 0; i < ejectedImages; i++) {
                NSString *ejectedFile = [[self diskCache] firstObject];
                [fileManager removeItemAtPath:[[self cacheDir] stringByAppendingPathComponent:ejectedFile] error:NULL];
                [[self diskCache] removeFirst];            
            }
        }
        // Make room for image
        if (ejectedImages > 0) {
            AGKTrace(@"Cache '%@' ejected %d disk image(s)", [self name], ejectedImages);
        }       
        [[self diskCache] addObject:filename];
        [self loadImage:filename imageType:imageType];
    }];
    return handle ? requestHandle : nil;
}

@end


@implementation AGKRemoteImageDiskCacheRequestHandle
@synthesize cache = _cache, block = _block, filename = _filename;

- (id)initWithCache:(AGKRemoteImageDiskCache *)theCache filename:(NSString *)theFilename block:(AGKRemoteImageLoaded)theBlock 
{
    if ((self = [super init])) {
        _cache = theCache;
        _block = theBlock;
        _filename = theFilename;
    }
    return self;
}

- (void)cancel 
{
    if (![self block]) return;
    NSMutableArray *array = [[[self cache] loading] objectForKey:[self filename]];
    [array removeObject:[self block]];
    [self setCache:nil];
    [self setFilename:nil];
}

@end



#ifndef NDEBUG
@implementation AGKRemoteImageDiskCache (Debug)
+ (void)setFailLoad:(BOOL)failLoad 
{
    failAll = failLoad;
}
@end
#endif
