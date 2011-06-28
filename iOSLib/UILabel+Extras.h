//
//  UILabel+Extras.h
//  FCJ
//
//  Created by Christoffer Lernö on 2010-22-04.
//  Copyright 2010 Aegik AB. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UILabel(Extras)
- (BOOL)textFitsInLabel;
- (void)setTextAlignedTop:(NSString *)text;
- (void)setTextAlignedBottom:(NSString *)theText;
- (UILabel *)labelWithVerticalOffset:(CGFloat)offset;
- (void)resizeVerticallyToFitContent;
- (void)resizeHorizontallyToFitContent;
+ (UIView *)labelAndSpinner:(NSString *)text font:(UIFont *)font textColor:(UIColor *)color spinner:(UIActivityIndicatorViewStyle)spinnerStyle spacing:(CGFloat)spacing;
+ (UIView *)labelAndButton:(NSString *)text font:(UIFont *)font textColor:(UIColor *)color button:(UIButton *)button spacing:(CGFloat)spacing;
@end
