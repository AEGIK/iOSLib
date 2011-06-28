//
//  UIButton+Extras.h
//  FCJ
//
//  Created by Christoffer Lernö on 2010-10-05.
//  Copyright 2010 Aegik AB. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIButton(Extras)
- (UIButton *)buttonWithVerticalOffset:(CGFloat)offset;
- (void)stretchBackgroundWithLeftCapWidth:(NSInteger)leftCapWidth topCapHeight:(NSInteger)topCapHeight state:(UIControlState)state;
- (void)stretchBackgroundWithLeftCapWidth:(NSInteger)leftCapWidth topCapHeight:(NSInteger)topCapHeight;
- (void)deselect;
- (void)select;
@end
