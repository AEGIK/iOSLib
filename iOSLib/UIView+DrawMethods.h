//
//  UIView+DrawMethods.h
//  FCJ
//
//  Created by Christoffer Lernö on 2010-19-04.
//  Copyright 2010 Aegik AB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView(DrawMethods) 
- (void)drawRoundedRect:(CGContextRef) context rect:(CGRect)rect radius:(CGFloat)cornerRadius;
- (void)drawRoundedRect:(CGContextRef) context x:(CGFloat)x y:(CGFloat)y width:(CGFloat)width height:(CGFloat)height radius:(CGFloat) cornerRadius;
- (void)bounceAppear:(NSTimeInterval)delay;
- (UIImage *)captureAsImage;
@end
