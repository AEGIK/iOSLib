//
//  UILabel+Extras.m
//  FCJ
//
//  Created by Christoffer Lernö on 2010-22-04.
//  Copyright 2010 Aegik AB. All rights reserved.
//

#import "UILabel+Extras.h"
#import "UIView+Extras.h"
#import "AGKActivitySpinnerView.h"

@implementation UILabel(Extras)

- (BOOL)textFitsInLabel
{
	// Test if the text fits
	CGSize originalBox = [self frame].size;
	CGSize biggerBox = originalBox;
	biggerBox.height += 400;
	CGSize preferredBox = [[self text] sizeWithFont:[self font] constrainedToSize:biggerBox];
	return preferredBox.height <= originalBox.height;
}

- (void)setTextAlignedTop:(NSString *)theText
{
	CGSize normalSize = [self frame].size;
	CGSize textSize = [theText sizeWithFont:[self font]];
	normalSize.height = textSize.height * [self numberOfLines];
	CGSize preferredBox = [theText sizeWithFont:[self font] constrainedToSize:normalSize lineBreakMode:[self lineBreakMode]];
	CGRect newFrame = [self frame];
	newFrame.size.height = preferredBox.height;
	[self setFrame:newFrame];
	[self setText:theText];
}

- (void)setTextAlignedBottom:(NSString *)theText
{
	CGSize normalSize = [self frame].size;
	CGSize textSize = [theText sizeWithFont:[self font]];
	normalSize.height = textSize.height * [self numberOfLines];
	CGSize preferredBox = [theText sizeWithFont:[self font] constrainedToSize:normalSize lineBreakMode:[self lineBreakMode]];
	CGRect newFrame = [self frame];
	newFrame.origin.y = newFrame.size.height - preferredBox.height;
	newFrame.size.height = preferredBox.height;
	[self setFrame:newFrame];
	[self setText:theText];
}

- (UILabel *)labelWithVerticalOffset:(CGFloat)offset
{
	CGRect newRect = [self frame];
	newRect.origin.y += offset;
	UILabel *newLabel = [[UILabel alloc] initWithFrame:newRect];
	[newLabel setTextColor:[self textColor]];
	[newLabel setFont:[self font]];
	UIColor *backgroundColor = [self backgroundColor];
	[newLabel setBackgroundColor:backgroundColor ? backgroundColor : [UIColor clearColor]];
	[newLabel setBaselineAdjustment:[self baselineAdjustment]];
	[newLabel setAlpha:[self alpha]];
	[newLabel setEnabled:[self isEnabled]];
	[newLabel setHidden:[self isHidden]];
	[newLabel setLineBreakMode:[self lineBreakMode]];
	[newLabel setMinimumFontSize:[self minimumFontSize]];
	[newLabel setNumberOfLines:[self numberOfLines]];
	[newLabel setShadowColor:[self shadowColor]];
	[newLabel setShadowOffset:[self shadowOffset]];
	[newLabel setTextAlignment:[self textAlignment]];
	[newLabel setAdjustsFontSizeToFitWidth:[self adjustsFontSizeToFitWidth]];
    return newLabel;
}

- (void)resizeVerticallyToFitContent {
	CGSize preferredSize = [[self text] sizeWithFont:[self font] constrainedToSize:CGSizeMake([self frame].size.width, CGFLOAT_MAX) lineBreakMode:[self lineBreakMode]];
	[self setHeight:preferredSize.height];
}

- (void)resizeHorizontallyToFitContent
{
	CGSize preferredSize = [[self text] sizeWithFont:[self font] constrainedToSize:CGSizeMake(99999, [self frame].size.height) lineBreakMode:[self lineBreakMode]];
	[self setWidth:preferredSize.width + 1];
}

+ (UIView *)labelAndSpinner:(NSString *)text font:(UIFont *)font textColor:(UIColor *)color spinner:(UIActivityIndicatorViewStyle)spinnerStyle spacing:(CGFloat)spacing
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setText:text];
    [label setTextAlignment:UITextAlignmentCenter];
    [label setFont:font];
    [label setTextColor:color];
    [label resizeHorizontallyToFitContent];
    [label resizeVerticallyToFitContent];
    AGKActivitySpinnerView *spinner = [[AGKActivitySpinnerView alloc] initWithActivityIndicatorStyle:spinnerStyle];
    [spinner setAnimating:YES];
    UIView *view = [UIView viewWithSize:CGSizeMake([label width] + [spinner width] + spacing, [label height])];
    [view addSubview:label];
    [spinner setX:[label rightBound] + spacing];
    [spinner centerVertically:[view size]];
    [view addSubview:spinner];
    [view setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin];
    return view;
}

+ (UIView *)labelAndButton:(NSString *)text font:(UIFont *)font textColor:(UIColor *)color button:(UIButton *)button spacing:(CGFloat)spacing
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setText:text];
    [label setTextAlignment:UITextAlignmentCenter];
    [label setFont:font];
    [label setTextColor:color];
    [label resizeHorizontallyToFitContent];
    [label resizeVerticallyToFitContent];
    UIView *view = [UIView viewWithSize:CGSizeMake([label width] + [button width] + spacing, [label height])];
    [view addSubview:label];
    [button setX:[label rightBound] + spacing];
    [button centerVertically:[view size]];
    [view addSubview:button];
    [view setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin];
    return view;
}


@end
