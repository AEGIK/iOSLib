//
//  UIView+DrawMethods.m
//  FCJ
//
//  Created by Christoffer Lernö on 2010-19-04.
//  Copyright 2010 Aegik AB. All rights reserved.
//

#import "UIView+DrawMethods.h"
#import <QuartzCore/QuartzCore.h>
#import "NSArray+Extras.h"

@implementation UIView(DrawMethods)
- (void)drawRoundedRect:(CGContextRef) context rect:(CGRect)rect radius:(CGFloat)cornerRadius
{
	[self drawRoundedRect:context x:rect.origin.x y:rect.origin.y width:rect.size.width height:rect.size.height radius:cornerRadius];
}

- (void)drawRoundedRect:(CGContextRef) context x:(CGFloat)x y:(CGFloat)y width:(CGFloat)width height:(CGFloat)height radius:(CGFloat) cornerRadius
{
	CGContextMoveToPoint(context, x + cornerRadius, y);
	CGContextAddLineToPoint(context, x + width - cornerRadius, y);
	CGContextAddArcToPoint(context, x + width, y, x + width, y + cornerRadius, cornerRadius);
	CGContextAddLineToPoint(context, x + width, y + height - cornerRadius);
	CGContextAddArcToPoint(context, x + width, y + height, x + width - cornerRadius, y + height, cornerRadius);
	CGContextAddLineToPoint(context, x + cornerRadius, y + height);
	CGContextAddArcToPoint(context, x, y + height, x, y + height - cornerRadius, cornerRadius);
	CGContextAddLineToPoint(context, x, y + cornerRadius);
	CGContextAddArcToPoint(context, x, y, x + cornerRadius, y, cornerRadius);	
}

- (void)bounceAppear:(NSTimeInterval)delay {
	// Bounce animation
	double totalDuration = 0.4f + delay;
	CALayer *viewLayer = [self layer];
	CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
	[animation setDuration:totalDuration];
	[animation setValues:[NSArray arrayElements:5 ofDoubles:0.6, 0.6, 1.1, 0.9, 1.0]];
	[animation setKeyTimes:[NSArray arrayElements:5 ofDoubles:
							0.0,
							delay / totalDuration, 
							(0.16 + delay) / totalDuration, 
							(0.28 + delay) / totalDuration, 1]];
	[viewLayer addAnimation:animation forKey:@"transform.scale"];
	CAKeyframeAnimation *fadeIn = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
	[fadeIn setDuration:totalDuration];
	[fadeIn setValues:[NSArray arrayElements:3 ofDoubles:0.0, 0.0, 1.0]];
	[fadeIn setKeyTimes:[NSArray arrayElements:3 ofDoubles:0.0, delay / totalDuration, 1.0]];
	[viewLayer addAnimation:fadeIn forKey:@"opacity"];
}

- (UIImage *)captureAsImage 
{
    UIGraphicsBeginImageContext([self frame].size);
	[[self layer] renderInContext:UIGraphicsGetCurrentContext()];
	UIImage *capturedImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
    return capturedImage;
}

@end
