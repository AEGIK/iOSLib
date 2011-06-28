//
//  AGKImage.h
//  iOSLib
//
//  Created by Christoffer Lernö on 2011-19-05.
//  Copyright 2011 AEGIK AB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AGKColor : NSObject {}
+ (AGKColor *)colorWithColor:(UIColor *)color;
@property (nonatomic, assign, readonly) CGColorRef CGColor;
@end

@interface AGKImage : NSObject {}
+ (AGKImage *)imageWithImage:(UIImage *)image;
+ (AGKImage *)imageWithCGImage:(CGImageRef)newCGImage;
- (id)initWithCGImage:(CGImageRef)imageRef;
- (id)initWithImage:(UIImage *)image;
- (void)drawAtPoint:(CGPoint)point;
- (UIImage *)UIImage;
+ (AGKImage *)imageWithBundledImageNamed:(NSString *)name;
- (AGKImage *)imageWithSize:(CGSize)size;
- (AGKImage *)imageWithSize:(CGSize)size border:(CGFloat)borderWidth borderColor:(AGKColor *)borderColor cornerRadius:(CGFloat)radius overlay:(AGKImage *)overlay;
@property (nonatomic, assign, readonly) CGImageRef CGImage;
@end
