//
//  UITextView+Margin.m
//  FCJ
//
//  Created by Christoffer Lernö on 2010-04-04.
//  Copyright 2010 Aegik AB. All rights reserved.
//

#import "UITextField+Margin.h"


@implementation UITextField(Margin)

-(void)setLeftMargin:(CGFloat)margin
{
	CGFloat leftInset = margin;
	UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, leftInset, self.bounds.size.height)];
	[self setLeftView:leftView];
	[self setLeftViewMode:UITextFieldViewModeAlways];
}

@end
