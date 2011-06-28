/*
 *  CGFunctions.c
 *  FCJ
 *
 *  Created by Christoffer Lernö on 2010-07-05.
 *  Copyright 2010 Aegik AB. All rights reserved.
 *
 */

#include "CGFunctions.h"


CGFloat ScaleFactor(void)
{
    static CGFloat scale = 0;
    if (scale < 1) scale = [[UIScreen mainScreen] scale];
    return scale;
}

CGPoint CGPointOffset(CGPoint point, CGFloat x, CGFloat y)
{
	return CGPointMake(point.x + x, point.y + y);
}

CGRect CGRectWithSize(CGSize size) {
    return CGRectMake(0, 0, size.width, size.height);
}

CGSize CGSizeMax(CGSize size1, CGSize size2)
{
	return CGSizeMake(MAX(size1.width, size2.width), MAX(size1.height, size2.height));
}

CGPathRef CreateRoundedRect(CGRect rect, CGFloat radius) {
    
    CGMutablePathRef retPath = CGPathCreateMutable();

	CGRect innerRect = CGRectInset(rect, radius, radius);
    
	CGFloat inside_right = innerRect.origin.x + innerRect.size.width;
	CGFloat outside_right = rect.origin.x + rect.size.width;
	CGFloat inside_bottom = innerRect.origin.y + innerRect.size.height;
	CGFloat outside_bottom = rect.origin.y + rect.size.height;
    
	CGFloat inside_top = innerRect.origin.y;
	CGFloat outside_top = rect.origin.y;
	CGFloat outside_left = rect.origin.x;
    
	CGPathMoveToPoint(retPath, NULL, innerRect.origin.x, outside_top);
    
    if (radius > 3) {
        CGPathAddLineToPoint(retPath, NULL, inside_right, outside_top);
        CGPathAddArcToPoint(retPath, NULL, outside_right, outside_top, outside_right, inside_top, radius);
        CGPathAddLineToPoint(retPath, NULL, outside_right, inside_bottom);
        CGPathAddArcToPoint(retPath, NULL,  outside_right, outside_bottom, inside_right, outside_bottom, radius);
        
        CGPathAddLineToPoint(retPath, NULL, innerRect.origin.x, outside_bottom);
        CGPathAddArcToPoint(retPath, NULL,  outside_left, outside_bottom, outside_left, inside_bottom, radius);
        CGPathAddLineToPoint(retPath, NULL, outside_left, inside_top);
        CGPathAddArcToPoint(retPath, NULL,  outside_left, outside_top, innerRect.origin.x, outside_top, radius);        
    } else {
        CGPathAddLineToPoint(retPath, NULL, inside_right, outside_top);
        CGPathAddLineToPoint(retPath, NULL, outside_right, inside_top);
        CGPathAddLineToPoint(retPath, NULL, outside_right, inside_bottom);
        CGPathAddLineToPoint(retPath, NULL, inside_right, outside_bottom);
        CGPathAddLineToPoint(retPath, NULL, innerRect.origin.x, outside_bottom);
        CGPathAddLineToPoint(retPath, NULL, outside_left, inside_bottom);
        CGPathAddLineToPoint(retPath, NULL, outside_left, inside_top);
        CGPathAddLineToPoint(retPath, NULL, innerRect.origin.x, outside_top);
    }
    
	CGPathCloseSubpath(retPath);
    
	return retPath;}

void ClipToRoundedCorners(CGContextRef context, CGRect rect, CGFloat cornerRadius) 
{
    CGPathRef path = CreateRoundedRect(rect, cornerRadius);
    CGContextAddPath(context, path);
    CGContextClip(context);
    CFRelease(path);
}

void DrawRoundedBorder(CGContextRef context, CGRect rect, CGFloat borderWidth, UIColor *color, CGFloat cornerRadius) 
{
    CGPathRef path = CreateRoundedRect(CGRectInset(rect, 0.5, 0.5), cornerRadius);
    CGContextSetStrokeColorWithColor(context, [color CGColor]);
    CGContextAddPath(context, path);
    CGContextSetLineWidth(context, borderWidth);
    CGContextStrokePath(context);
    CFRelease(path);
}

CGRect CGSizeAspectFill(CGSize sourceSize, CGSize destinationSize)
{
    CGFloat xScale = destinationSize.width / sourceSize.width;
	CGFloat yScale = destinationSize.height / sourceSize.height;
	CGRect targetRect;
	// 
	if (xScale > yScale) {
		targetRect.origin = CGPointMake(0, -(xScale * sourceSize.height - destinationSize.height) / 2);
		targetRect.size = CGSizeMake(destinationSize.width, sourceSize.height * xScale);
	}
	else {
		targetRect.origin = CGPointMake(-(yScale * sourceSize.width - destinationSize.width) / 2, 0);
		targetRect.size = CGSizeMake(sourceSize.width * yScale, destinationSize.height);
	}
	
	return CGRectIntegral(targetRect);
}

CGImageRef CGImageResizeAndModifyWithBlock(CGImageRef image, CGSize size, ContextAction block)
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, size.width, size.height, 8, 0, colorSpace, kCGImageAlphaPremultipliedLast);
    CGContextSetInterpolationQuality(context, kCGInterpolationMedium);
    block(context);
    CGImageRef cgImage = CGBitmapContextCreateImage(context);
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    return cgImage;
}

CGImageRef CGImageCreateFromFile(NSString *fullPath, AGKImageType imageType) 
{
    if (imageType == AGKImageTypeUnknown) return NULL;
    CGDataProviderRef dataProvider = CGDataProviderCreateWithFilename([fullPath UTF8String]);    
    if (!dataProvider) return NULL;
    CGImageRef image = NULL;
    switch (imageType) {
        case AGKImageTypeJPG:
            image = CGImageCreateWithJPEGDataProvider(dataProvider, NULL, NO, kCGRenderingIntentDefault);
            break;
        case AGKImageTypePNG:
            image = CGImageCreateWithPNGDataProvider(dataProvider, NULL, NO, kCGRenderingIntentDefault);
            break;
        default:
            break;
    }
    CFRelease(dataProvider);
    return image;
}

CGSize CGSizeRescaleToScreen(CGSize size) 
{
    return CGSizeRescale(size, ScaleFactor());
}

CGSize CGSizeRescale(CGSize size, CGFloat scaleFactor) 
{
    return CGSizeMake(round(scaleFactor * size.width), round(scaleFactor * size.height));
}