//
//  AGKOutlineLabel.m
//  iOSLib
//
//  Created by Christoffer Lernö on 2011-05-04.
//  Copyright 2011 Aegik AB. All rights reserved.
//

#import "AGKOutlineLabel.h"


@implementation AGKOutlineLabel

-(void)drawTextInRect:(CGRect)rect
{
	UIColor *shadowCol = [self shadowColor];
	UIColor *textCol = [self textColor];
	[self setTextColor:[UIColor clearColor]];
	[self setShadowColor:[UIColor clearColor]];
	CGContextRef c = UIGraphicsGetCurrentContext();
	CGContextSetLineWidth(c, 2);
	[self setTextColor:shadowCol];
	CGContextSetTextDrawingMode(c, kCGTextStroke);
	[super drawTextInRect:rect];
	[self setTextColor:textCol];
	CGRect newRect = rect;
	newRect.origin.x -= 0;
	newRect.origin.y -= 1;
	if (self.textAlignment == UITextAlignmentLeft) {
		newRect.origin.x += 0.5;
	}
	if (self.textAlignment == UITextAlignmentRight) {
		newRect.origin.x -= 0.5;
	}
	CGContextSetLineWidth(c, 0);
	CGContextSetTextDrawingMode(c, kCGTextFill);
	[super drawTextInRect:newRect];
	[self setShadowColor:shadowCol];
}
@end
