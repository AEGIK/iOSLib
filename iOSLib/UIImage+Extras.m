//
//  UIImage+Extras.m
//  iOSLib
//
//  Created by Christoffer Lernö on 2010-06-07.
//  Copyright 2010 Aegik AB. All rights reserved.
//

#import "UIImage+Extras.h"
#import "NSDictionary+Extras.h"
#import "NSURLConnection+Extras.h"
#import "CGFunctions.h"


@implementation NSString (UIImageExtras)

- (AGKImageType)imageType 
{
    NSUInteger len = [self length];
    if (len < 4) return AGKImageTypeUnknown;
    NSString *end = [[self substringFromIndex:len - 4] lowercaseString];
    if ([end isEqualToString:@".png"]) return AGKImageTypePNG;
    if ([end isEqualToString:@".jpg"] || [end isEqualToString:@"jpeg"]) return AGKImageTypeJPG;
    return AGKImageTypeUnknown;
}

@end
@implementation UIImage (Extras)

#pragma mark -
#pragma mark ImageSplitting

- (UIImage *)imageFromRect:(CGRect)rect
{
	UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0);
	CGContextRef context = UIGraphicsGetCurrentContext();
	UIGraphicsPushContext(context);
	[self drawAtPoint:rect.origin];
	UIGraphicsPopContext();
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return image;
}


- (UIImage *)imageScaleToFill:(CGSize)size {
	
    
	UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
	CGContextRef bitmap = UIGraphicsGetCurrentContext();

    // Set the quality level to use when rescaling
    CGContextSetInterpolationQuality(bitmap, kCGInterpolationMedium);
    
	[self drawInRect:CGSizeAspectFill([self size], size)];
    
    // Get the resized image from the context and a UIImage
	UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
	
    return newImage;
	
}

#pragma mark -
#pragma mark Image merge

- (UIImage *)imageByMergeWithImage:(UIImage *)image
{
	CGRect targetRect = { { 0, 0 }, [self size] };
	return [self imageByMergeWithImage:image inRect:targetRect];
}

- (UIImage *)imageByMergeWithImage:(UIImage *)image inRect:(CGRect)mergeImageTarget
{
	UIGraphicsBeginImageContextWithOptions([self size], NO, 0.0);
	CGContextRef context = UIGraphicsGetCurrentContext();
	UIGraphicsPushContext(context);
    [self drawAtPoint:CGPointZero];
	[image drawInRect:mergeImageTarget];
	UIGraphicsPopContext();
	UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return newImage;	
}

+ (UIImage *)imageSize:(CGSize)size withBlock:(ContextAction)block 
{
	UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
	CGContextRef context = UIGraphicsGetCurrentContext();
    block(context);
	UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return newImage;	    
}

@end

