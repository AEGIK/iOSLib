//
//  AGKRemoteImageDiskCache.h
//  iOSLib
//
//  Created by Christoffer Lernö on 2011-19-05.
//  Copyright 2011 AEGIK AB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AGKImage.h"
#import "CGFunctions.h"

typedef void (^AGKRemoteImageLoaded)(AGKImage *image);

@interface AGKRemoteImageDiskCacheRequestHandle : NSObject {}
- (void)cancel;
@end

@interface AGKRemoteImageDiskCache : NSObject {}

+ (AGKRemoteImageDiskCache *)sharedCacheNamed:(NSString *)cacheName;
@property (nonatomic, retain, readonly) NSString *name;
@property (nonatomic, assign) NSTimeInterval loadTimeout;
@property (nonatomic, assign) NSUInteger diskCacheSize;
- (AGKRemoteImageDiskCacheRequestHandle *)remoteImage:(NSString *)URL imageType:(AGKImageType)imageType finished:(AGKRemoteImageLoaded)block;
- (AGKRemoteImageDiskCacheRequestHandle *)remoteImage:(NSString *)URL finished:(AGKRemoteImageLoaded)block;
@end

#ifndef NDEBUG
@interface AGKRemoteImageDiskCache (Debug)
+ (void)setFailLoad:(BOOL)failLoad;
@end
#endif
