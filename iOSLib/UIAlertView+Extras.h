//
//  UIAlertView+Extras.h
//  iOSLib
//
//  Created by Christoffer Lernö on 2010-06-11.
//  Copyright 2010 Aegik AB. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^AlertAction)(UIAlertView *);

@interface UIAlertView(Extras)
+ (UIAlertView *)alertWithTitle:(NSString *)theTitle 
						message:(NSString *)theMessage 
			  cancelButtonTitle:(NSString *)cancelButtonTitle
			 cancelButtonAction:(AlertAction)cancelAction
	otherButtonTitlesAndActions:(id)titlesAndActions, ... NS_REQUIRES_NIL_TERMINATION;


@end

