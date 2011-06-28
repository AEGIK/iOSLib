//
//  AGKImage.m
//  iOSLib
//
//  Created by Christoffer Lernö on 2011-19-05.
//  Copyright 2011 AEGIK AB. All rights reserved.
//

#import "AGKImage.h"
#import "CGFunctions.h"

@interface AGKImage () {}
- (void)drawInRect:(CGRect)targetRect context:(CGContextRef)context;
@end
@implementation AGKImage
@synthesize CGImage;

- (id)initWithImage:(UIImage *)image 
{
    return [self initWithCGImage:[image CGImage]];
}

- (id)initWithCGImage:(CGImageRef)imageRef 
{
    if ((self = [super init])) {
        if (!imageRef) {
            self = nil;
            return nil;
        }
        CGImage = CGImageRetain(imageRef);
    }
    return self;
}

+ (AGKImage *)imageWithBundledImageNamed:(NSString *)name
{
    return [self imageWithImage:[UIImage imageNamed:name]];
}

+ (AGKImage *)imageWithImage:(UIImage *)image 
{
    return [self imageWithCGImage:[image CGImage]];
}

+ (AGKImage *)imageWithCGImage:(CGImageRef)newCGImage 
{
    if (!newCGImage) return nil;
    return [[AGKImage alloc] initWithCGImage:newCGImage];
}

- (UIImage *)UIImage 
{
    return [UIImage imageWithCGImage:CGImage scale:ScaleFactor() orientation:UIImageOrientationUp];
}

- (void)drawAtPoint:(CGPoint)point {
    CGRect rect = CGRectMake(point.x, point.y, CGImageGetWidth(CGImage) / ScaleFactor(), CGImageGetHeight(CGImage) / ScaleFactor());
    [self drawInRect:rect context:UIGraphicsGetCurrentContext()];
}

- (void)drawInRect:(CGRect)targetRect context:(CGContextRef)context
{
    CGContextDrawImage(context, targetRect, CGImage);
}

- (CGSize)size 
{
    return CGSizeMake(CGImageGetWidth(CGImage), CGImageGetHeight(CGImage));
}

- (AGKImage *)imageWithSize:(CGSize)size
{
    return [self imageWithSize:size border:0 borderColor:NULL cornerRadius:0 overlay:nil];
}

- (AGKImage *)imageWithSize:(CGSize)size border:(CGFloat)borderWidth borderColor:(AGKColor *)borderColor cornerRadius:(CGFloat)radius overlay:(AGKImage *)overlay
{
    size = CGSizeRescaleToScreen(size);
    radius *= ScaleFactor();
    borderWidth *= ScaleFactor();
    CGSize ownSize = CGSizeMake(CGImageGetWidth(CGImage), CGImageGetHeight(CGImage));
    CGImageRef imageRef = CGImageResizeAndModifyWithBlock(CGImage, size, ^(CGContextRef context) {
        CGRect targetRect = CGSizeAspectFill(ownSize, size);
        CGRect rect = CGRectWithSize(size);
        
        // Set the quality level to use when rescaling
        if (radius > 0 || borderColor) {
            ClipToRoundedCorners(context, rect, radius);
            if (borderColor && borderWidth > 0) {
                CGContextSetFillColorWithColor(context, [borderColor CGColor]);
                CGContextFillRect(context, rect);
                rect = CGRectInset(rect, borderWidth, borderWidth);
                targetRect = CGRectInset(targetRect, borderWidth, borderWidth);
                ClipToRoundedCorners(context, rect, MAX(0, radius - borderWidth));
            }
        }
        [self drawInRect:targetRect context:context];
        [overlay drawInRect:rect context:context];
    });
    AGKImage *image = [AGKImage imageWithCGImage:imageRef];
    if (imageRef) CGImageRelease(imageRef);
    return image;
}

- (void)dealloc 
{
    if (CGImage) CGImageRelease(CGImage);
}

@end

@implementation AGKColor

@synthesize CGColor;

- (id)initWithCGColor:(CGColorRef)cgColor
{
    if ((self = [super init])) {
        if (!cgColor) {
            self = nil;
            return nil;
        }
        CGColor = CGColorRetain(cgColor);
    }
    return self;
}

+ (AGKColor *)colorWithColor:(UIColor *)color 
{
    return [[self alloc] initWithCGColor:[color CGColor]];
}

- (void)dealloc
{
    CGColorRelease(CGColor);
}

@end
