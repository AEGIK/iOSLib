//
//  AGKRemoteImageCache.h
//  iOSLib
//
//  Created by Christoffer Lernö on 2010-05-08.
//  Copyright 2010 Aegik AB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AGKImageCache.h"


@interface AGKRemoteImageCache : NSObject<NSCacheDelegate> 
{}
- (AGKImageRequestHandle *)retrieveImage:(NSString *)url suffix:(NSString *)string modifier:(AGKImageModifier)modifier load:(AGKImageCallback)block;
+ (AGKRemoteImageCache *)sharedCacheNamed:(NSString *)cacheName;
@property (nonatomic, retain) NSString *name;
@end
