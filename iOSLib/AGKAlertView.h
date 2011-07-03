//
//  AGKAlertView.h
//  iOSLib
//
//  Created by Christoffer Lernö on 2011-30-06.
//  Copyright 2011 AEGIK AB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AGKAlertView : NSObject<UIAlertViewDelegate>
- (id)initWithDelegate:(id)delegate;
- (void)setTitle:(NSString *)title;
- (void)setMessage:(NSString *)message;
- (void)setCancelButton:(NSString *)cancelButton;
- (void)setButton:(NSString *)button;
- (void)setCancelButton:(NSString *)cancelButton action:(SEL)selector;
- (void)setButton:(NSString *)button action:(SEL)selector;
- (void)show;
@end
