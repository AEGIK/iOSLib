//
//  UIView+Extras.m
//  iOSLib
//
//  Created by Christoffer Lernö on 2010-13-07.
//  Copyright 2010 Aegik AB. All rights reserved.
//

#import "UIView+Extras.h"

@implementation UIView(Extras)

+ (UIView *)viewWithSize:(CGSize)size 
{
    return [[self alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
}

- (CGFloat)x {
	return [self frame].origin.x;
}

- (CGFloat)y {
	return [self frame].origin.y;
}

- (CGFloat)width {
	return [self frame].size.width;
}

- (CGFloat)height {
	return [self frame].size.height;
}

- (CGPoint)origin {
	return [self frame].origin;
}

- (CGSize)size {
	return [self frame].size;
}

- (void)setOrigin:(CGPoint)origin {
	CGRect rect = [self frame];
	rect.origin = origin;
	[self setFrame:rect];
}

- (void)setSize:(CGSize)size {
	CGRect rect = [self frame];
	rect.size = size;
	[self setFrame:rect];	
}

- (void)setHeight:(CGFloat)height
{
	CGRect rect = [self frame];
	rect.size.height = height;
	[self setFrame:rect];
}

- (void)setWidth:(CGFloat)width
{
	CGRect rect = [self frame];
	rect.size.width = width;
	[self setFrame:rect];
}

- (void)setX:(CGFloat)x
{
	CGRect rect = [self frame];
	rect.origin.x = x;
	[self setFrame:rect];
}

- (void)setY:(CGFloat)y
{
	CGRect rect = [self frame];
	rect.origin.y = y;
	[self setFrame:rect];	
}

- (CGFloat)lowerBound
{
	CGRect rect = [self frame];
	return rect.origin.y + rect.size.height;
}

- (CGFloat)rightBound
{
	CGRect rect = [self frame];
	return rect.origin.x + rect.size.width;
}

- (void)displaceBy:(CGSize)displacement
{
	CGRect rect = [self frame];
	rect.origin.x += displacement.width;
	rect.origin.y += displacement.height;
	[self setFrame:rect];
}
- (void)displaceHorizontally:(CGFloat)xDisplacement
{
	[self displaceBy:CGSizeMake(xDisplacement, 0)];
}

- (void)displaceVertically:(CGFloat)yDisplacement
{
	[self displaceBy:CGSizeMake(0, yDisplacement)];
}

- (void)removeAllSubviews {
	for (UIView *view in [[NSArray alloc] initWithArray:[self subviews]]) {
		[view removeFromSuperview];
	}
}

+ (void)animate:(BOOL)animate withDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay options:(UIViewAnimationOptions)options animations:(void (^)())animations completion:(void (^)(BOOL))completion {
	if (animate) {
		[UIView animateWithDuration:duration delay:delay options:options animations:animations completion:completion];
	} else {
		animations();
		completion(YES);
	}		 
}

+ (void)animate:(BOOL)animate withDuration:(NSTimeInterval)duration animations:(void (^)())animations completion:(void (^)(BOOL))completion {
	if (animate) {
		[UIView animateWithDuration:duration animations:animations completion:completion];
	} else {
		animations();
		completion(YES);
	}
}

+ (void)animate:(BOOL)animate withDuration:(NSTimeInterval)duration animations:(void (^)())animations {
	if (animate) {
		[UIView animateWithDuration:duration animations:animations];
	} else {
		animations();
	}
}

- (void)centerLeftInView:(UIView *)view {
    CGSize theContainer = [view bounds].size;
    [self centerVertically:theContainer];
    [self setX:0];
}

- (void)centerRightInView:(UIView *)view {
    CGSize theContainer = [view bounds].size;
    [self centerVertically:theContainer];
    [self alignRight:theContainer];
}

- (void)topCenterInView:(UIView *)view {
    CGSize theContainer = [view bounds].size;
    [self centerHorizontally:theContainer];
    [self setY:0];
}

- (void)bottomCenterInView:(UIView *)view {
    CGSize theContainer = [view bounds].size;
    [self centerHorizontally:theContainer];
    [self alignBottom:theContainer];
}

- (void)centerHorizontally:(CGSize)container {
    [self setX:(CGFloat)round((container.width - [self width]) / 2)]; 
}

- (void)centerVertically:(CGSize)container {
    [self setY:(CGFloat)round((container.height - [self height]) / 2)]; 
}

- (void)center:(CGSize)container {
    [self setOrigin:CGPointMake((CGFloat)round((container.width - [self width]) / 2), (CGFloat)round((container.height - [self height]) / 2))];
}

- (void)alignRight:(CGSize)container {
    [self setX:container.width - [self width]];
}

- (void)alignBottom:(CGSize)container {
    [self setY:container.height - [self height]];
}

- (void)centerInView:(UIView *)view {
    [self center:[view bounds].size];
}

- (CGRect)sizeRect {
    CGRect sizeRect = [self frame];
    sizeRect.origin = CGPointZero;
    return sizeRect;
}

- (void)dismissBlockView {
    for (UIView *view in [self subviews]) {
        if ([view tag] == 0x239142) {
            [view removeFromSuperview];
            return;
        }
    }
}

- (void)blockViewWithText:(NSString *)text font:(UIFont *)font {
    CGRect frame = [self bounds];
    UIView *view = [[UIView alloc] initWithFrame:frame];
    [view setTag:0x239142];
    [view setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.4f]];
    CGSize labelSize = [text sizeWithFont:font];
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    NSUInteger spacing = 10;
    CGFloat totalSize = [activityIndicator width] + labelSize.width + spacing;
    CGFloat xOffset = (CGFloat)round((frame.size.width - totalSize) / 2);
    CGFloat yOffset = (CGFloat)round(frame.size.height * 0.4);
    CGRect labelRect = CGRectMake(xOffset + [activityIndicator width] + spacing, 
                                  yOffset - (CGFloat)round(labelSize.height / 2), 
                                  labelSize.width + 3, labelSize.height);
    [activityIndicator setOrigin:CGPointMake(xOffset, yOffset - (CGFloat)round([activityIndicator height] / 2))];
    UILabel *label = [[UILabel alloc] initWithFrame:labelRect];
    [label setFont:font];
    [label setText:text];
    [label setTextColor:[UIColor whiteColor]];
    [label setBackgroundColor:[UIColor clearColor]];
    [activityIndicator startAnimating];
    [view addSubview:activityIndicator];
    [view addSubview:label];
    [self addSubview:view];
}

- (id)initWithSize:(CGSize)size 
{
    return [self initWithFrame:CGRectMake(0, 0, size.width, size.height)];
}

- (void)placeBelowView:(UIView *)otherView spacing:(CGFloat)spacing {
    [self setY:[otherView lowerBound] + spacing];
}

- (void)resizeSuperviewToFitWithPadding:(CGFloat)padding {
    [[self superview] setHeight:[self lowerBound] + padding];
}
@end
