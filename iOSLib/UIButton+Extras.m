//
//  UIButton+Extras.m
//  FCJ
//
//  Created by Christoffer Lernö on 2010-10-05.
//  Copyright 2010 Aegik AB. All rights reserved.
//

#import "UIButton+Extras.h"
#import "AGK.h"

@implementation UIButton(Extras)

- (void)stretchBackgroundWithLeftCapWidth:(NSInteger)leftCapWidth topCapHeight:(NSInteger)topCapHeight state:(UIControlState)state {
	UIImage *image = [self backgroundImageForState:state];
	UIImage *stretchedImage = [image stretchableImageWithLeftCapWidth:leftCapWidth topCapHeight:topCapHeight];
	[self setBackgroundImage:stretchedImage forState:state];
}

- (void)stretchBackgroundWithLeftCapWidth:(NSInteger)leftCapWidth topCapHeight:(NSInteger)topCapHeight {
	NSMutableDictionary *convertedImages = [[NSMutableDictionary alloc] initWithCapacity:4];
	NSArray *array = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:UIControlStateNormal], 
					  [NSNumber numberWithInt:UIControlStateHighlighted], 
					  [NSNumber numberWithInt:UIControlStateSelected],
					  [NSNumber numberWithInt:UIControlStateDisabled],
					  nil];
	for (NSNumber *number in array) {
		UIControlState state = [number unsignedIntValue];
		UIImage *image = [self backgroundImageForState:state];
		if (image) {
			NSValue *key = [NSValue valueWithPointer:(__bridge void *)image];
			UIImage *stretchedImage = [convertedImages objectForKey:key];
			if (stretchedImage == nil) {
				stretchedImage = [image stretchableImageWithLeftCapWidth:leftCapWidth topCapHeight:topCapHeight];
				[convertedImages setObject:stretchedImage forKey:key];
			} else {
				AGKTrace(@"Reused image");
			}
			[self setBackgroundImage:stretchedImage forState:state];
		}
	}
}

- (void)copyStateProperties:(UIButton *)otherButton state:(UIControlState)state
{
	NSString *title = [otherButton titleForState:state];
	if (state == UIControlStateNormal || [self titleForState:UIControlStateNormal] != title)
	{
		[self setTitle:title forState:state];
	}
	UIImage *image = [otherButton imageForState:state];
	if (state == UIControlStateNormal || [self imageForState:UIControlStateNormal] != image)
	{
		[self setImage:image forState:state];
	}
	UIImage *background = [otherButton backgroundImageForState:state];
	if (state == UIControlStateNormal || [self backgroundImageForState:UIControlStateNormal] != background)
	{
		[self setBackgroundImage:background forState:state];
	}
	UIColor *color = [otherButton titleColorForState:state];
	if (state == UIControlStateNormal || [self titleColorForState:state] != color)
	{
		[self setTitleColor:color ? color : [UIColor clearColor] forState:state];
	}
	UIColor *shadow = [otherButton titleShadowColorForState:state];
	if (state == UIControlStateNormal || [self titleShadowColorForState:state] != shadow)
	{
		[self setTitleShadowColor:shadow ? shadow : [UIColor clearColor] forState:state];
	}
	
}
- (UIButton *)buttonWithVerticalOffset:(CGFloat)offset
{
	UIButton *button = [UIButton buttonWithType:[self buttonType]];
	CGRect newRect = [self frame];
	newRect.origin.y += offset;
	[button setFrame:newRect];
	[[button titleLabel] setFont:[[self titleLabel] font]];
	[button copyStateProperties:self state:UIControlStateNormal];
	[button copyStateProperties:self state:UIControlStateHighlighted];
	[button copyStateProperties:self state:UIControlStateSelected];
	[button copyStateProperties:self state:UIControlStateDisabled];
	return button;
}

- (void)deselect
{
	[self setSelected:NO];
	[self setUserInteractionEnabled:YES];
}

- (void)select
{
	[self setSelected:YES];
	[self setUserInteractionEnabled:NO];
}

@end
