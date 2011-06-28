//
//  AGKRemoteImageCache.m
//  iOSLib
//
//  Created by Christoffer Lernö on 2010-05-08.
//  Copyright 2010 Aegik AB. All rights reserved.
//

#import "AGKRemoteImageCache.h"
#import "AGKRemoteImageDiskCache.h"
#import "AGKImageCache.h"
#import "AGK.h"

static NSMutableDictionary *caches = nil;

@interface AGKRemoteImageCache() {}
- (id)initWithName:(NSString *)name;
@property (nonatomic, strong) AGKRemoteImageDiskCache *diskCache;
@property (nonatomic, strong) AGKImageCache *imageCache;
@end

@implementation AGKRemoteImageCache

@synthesize name, diskCache, imageCache;

+ (AGKRemoteImageCache *)sharedCacheNamed:(NSString *)cacheName {
	if (!caches) {
		caches = [[NSMutableDictionary alloc] initWithCapacity:3];
	}
	AGKRemoteImageCache *theCache = [caches objectForKey:cacheName];
	if (!theCache) {
		theCache = [[AGKRemoteImageCache alloc] initWithName:cacheName];
		[caches setObject:theCache forKey:cacheName];
		AGKTrace(@"Created remote/image cache '%@'.", cacheName); 
	}
	return theCache;
}
- (id)initWithName:(NSString *)theName {
	if ((self = [super init])) {
        diskCache = [AGKRemoteImageDiskCache sharedCacheNamed:theName];
        imageCache = [AGKImageCache sharedCacheNamed:theName];
	}
	return self;
}

- (AGKImageRequestHandle *)retrieveImage:(NSString *)url suffix:(NSString *)string modifier:(AGKImageModifier)modifier load:(AGKImageCallback)block 
{
    return [[self imageCache] retrieveImage:[url stringByAppendingString:string] 
                                      image:^(AGKImageCallback callback) {
                                          [[self diskCache] remoteImage:url finished:^(AGKImage *image) {
                                              callback(image);
                                          }];
                                      } 
                                   modifier:modifier
                                       load:block];

}

@end
