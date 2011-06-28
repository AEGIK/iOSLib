//
//  AGKImageCache.h
//  iOSLib
//
//  Created by Christoffer Lernö on 2011-19-05.
//  Copyright 2011 AEGIK AB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AGKImage.h"

typedef void (^AGKImageCallback)(AGKImage *image);
typedef void (^AGKImageLoader)(AGKImageCallback);
typedef AGKImage *(^AGKImageModifier)(AGKImage *image);

@interface AGKImageRequestHandle : NSObject
- (void)cancel;
@end

@interface AGKImageCache : NSObject<NSCacheDelegate> {}
+ (AGKImageCache *)sharedCacheNamed:(NSString *)cacheName;
- (void)setMaxImages:(NSUInteger)maxImages;
- (AGKImageRequestHandle *)retrieveImage:(NSString *)imageName image:(AGKImageLoader)imageLoader modifier:(AGKImageModifier)modifier load:(AGKImageCallback)block;
- (AGKImage *)retrieveImage:(NSString *)imageName image:(AGKImage *)image modifier:(AGKImageModifier)modifier;

@property (nonatomic, strong, readonly) NSString *name;
@end