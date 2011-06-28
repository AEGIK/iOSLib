//
//  UIImage+Extras.h
//  iOSLib
//
//  Created by Christoffer Lernö on 2010-06-07.
//  Copyright 2010 Aegik AB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CGFunctions.h"


@interface UIImage(Extras)
- (UIImage *)imageFromRect:(CGRect)rect;
- (UIImage *)imageByMergeWithImage:(UIImage *)image;
- (UIImage *)imageByMergeWithImage:(UIImage *)image inRect:(CGRect)mergeImageTarget;
- (UIImage *)imageScaleToFill:(CGSize)size;
+ (UIImage *)imageSize:(CGSize)size withBlock:(ContextAction)block;
@end

@interface NSString (UIImageExtras)
- (AGKImageType)imageType;
@end
