//
//  UIAlertView+Extras.m
//  iOSLib
//
//  Created by Christoffer Lernö on 2010-06-11.
//  Copyright 2010 Aegik AB. All rights reserved.
//

#import "UIAlertView+Extras.h"

@interface UIAlertViewExtrasDelegate : NSObject<UIAlertViewDelegate>
@property (nonatomic, retain) NSDictionary *actions;
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
	[self release];
}

- (void)dealloc {
	[self setActions:nil];
	[super dealloc];
}

- (id)autorelease {
	return self;
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
			AlertAction buttonAction = va_arg(argList, AlertAction);
			NSInteger index = [alertView addButtonWithTitle:lastOtherButton];
			if (buttonAction) {
				AlertAction actionCopy = [buttonAction copy];
				[dict setObject:actionCopy forKey:[NSNumber numberWithInteger:index]];
				[actionCopy release];
			}
			lastOtherButton = va_arg(argList, id);
		}
		va_end(argList);
	}
	if (cancelButtonTitle && cancelAction) {
		AlertAction copy = [cancelAction copy];
		[dict setObject:copy forKey:[NSNumber numberWithInteger:[alertView cancelButtonIndex]]];
		[copy release];
	}
	[theDelegate setActions:dict];
	[dict release];
	[alertView show];
	return [alertView autorelease];
}
@end
