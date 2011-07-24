//
//  UIAlertView+Extras.m
//  iOSLib
//
//  Created by Christoffer Lernö on 2010-06-11.
//  Copyright 2010 Aegik AB. All rights reserved.
//

#import "UIAlertView+Extras.h"

@interface UIAlertViewExtrasDelegate : NSObject<UIAlertViewDelegate>
@property (nonatomic, strong) NSDictionary *actions;
@end

@implementation UIAlertViewExtrasDelegate

@synthesize actions;

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
	AlertAction action = [[self actions] objectForKey:[NSNumber numberWithInteger:buttonIndex]];
	if (action) {
		action(alertView);
	}
	[self setActions:nil];
    [alertView setDelegate:nil];
}

@end

@implementation UIAlertView(Extras)

+ (UIAlertView *)alertWithTitle:(NSString *)theTitle 
						message:(NSString *)theMessage
			  cancelButtonTitle:(NSString *)cancelButtonTitle
			 cancelButtonAction:(AlertAction)cancelAction
	otherButtonTitlesAndActions:(id)titlesAndActions, ...
{
	UIAlertViewExtrasDelegate *theDelegate = [[UIAlertViewExtrasDelegate alloc] init];
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:theTitle 
														message:theMessage
													   delegate:theDelegate
											  cancelButtonTitle:cancelButtonTitle
											  otherButtonTitles:nil];
	NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:5];
	id lastOtherButton;
	va_list argList;
	
	if (titlesAndActions) {
		va_start(argList, titlesAndActions);
		lastOtherButton = titlesAndActions;
		while (lastOtherButton) {
			void *buttonAction = va_arg(argList, void *);
			NSInteger index = [alertView addButtonWithTitle:lastOtherButton];
			if (buttonAction) {
				[dict setObject:(__bridge AlertAction)buttonAction forKey:[NSNumber numberWithInteger:index]];
			}
			lastOtherButton = (__bridge id)va_arg(argList, void *);
		}
		va_end(argList);
	}
	if (cancelButtonTitle && cancelAction) {
		[dict setObject:cancelAction forKey:[NSNumber numberWithInteger:[alertView cancelButtonIndex]]];
	}
	[theDelegate setActions:dict];
	[alertView show];
	return alertView;
}
@end
