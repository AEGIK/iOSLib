//
//  UIView+Extras.h
//  iOSLib
//
//  Created by Christoffer Lernö on 2010-13-07.
//  Copyright 2010 Aegik AB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CGFunctions.h"

@interface UIView(Extras)

+ (UIView *)viewWithSize:(CGSize)size;
- (void)setOrigin:(CGPoint)origin;
- (void)setSize:(CGSize)size;
- (CGFloat)x;
- (CGFloat)y;
- (CGFloat)width;
- (CGFloat)height;
- (CGPoint)origin;
- (CGSize)size;
- (void)setX:(CGFloat)x;
- (void)setY:(CGFloat)y;
- (void)setHeight:(CGFloat)height;
- (void)setWidth:(CGFloat)width;
- (CGFloat)lowerBound;
- (CGFloat)rightBound;

- (void)centerInView:(UIView *)view;
- (void)centerRightInView:(UIView *)view;
- (void)centerLeftInView:(UIView *)view;
- (void)topCenterInView:(UIView *)view;
- (void)bottomCenterInView:(UIView *)view;
- (void)centerHorizontally:(CGSize)container;
- (void)centerVertically:(CGSize)container;
- (void)center:(CGSize)container;
- (void)alignRight:(CGSize)container;
- (void)alignBottom:(CGSize)container;
- (CGRect)sizeRect;
- (void)displaceBy:(CGSize)displacement;
- (void)displaceHorizontally:(CGFloat)xDisplacement;
- (void)displaceVertically:(CGFloat)yDisplacement;
- (void)removeAllSubviews;
+ (void)animate:(BOOL)animate withDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay options:(UIViewAnimationOptions)options animations:(void (^)())animations completion:(void (^)(BOOL))completion;
+ (void)animate:(BOOL)animate withDuration:(NSTimeInterval)duration animations:(void (^)())animations completion:(void (^)(BOOL))completion;
+ (void)animate:(BOOL)animate withDuration:(NSTimeInterval)duration animations:(void (^)())animations;
- (void)blockViewWithText:(NSString *)text font:(UIFont *)font;
- (void)dismissBlockView;
- (void)placeBelowView:(UIView *)otherView spacing:(CGFloat)spacing;
- (void)resizeSuperviewToFitWithPadding:(CGFloat)padding;

@end
