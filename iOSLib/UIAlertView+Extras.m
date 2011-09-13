//
//  UIAlertView+Extras.m
//  iOSLib
//
//  Created by Christoffer Lernö on 2010-06-11.
//  Copyright 2010 Aegik AB. All rights reserved.
//

#import "UIAlertView+Extras.h"

@interface UIAlertViewExtrasDelegate : NSObject<UIAlertViewDelegate>
@property (nonatomic, retain) NSMutableArray *actions;
@property (nonatomic, retain) NSMutableArray *alertViews;
@end

@implementation UIAlertViewExtrasDelegate

@synthesize actions, alertViews;

- (id)init {
    if ((self = [super init])) {
        actions = [[NSMutableArray alloc] initWithCapacity:3];
        alertViews = [[NSMutableArray alloc] initWithCapacity:3];
    }
    return self;
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    AlertAction action = [[[self actions] objectAtIndex:0] objectForKey:[NSNumber numberWithInteger:buttonIndex]];
    [[self actions] removeObjectAtIndex:0];
    [[self alertViews] removeObjectAtIndex:0];
    if (action) {
		action(alertView);
	}
    if ([[self alertViews] count]) {
        [[[self alertViews] objectAtIndex:0] show];
    }
}

@end

static UIAlertViewExtrasDelegate *sharedDelegate = nil;

@implementation UIAlertView(Extras)

+ (UIAlertView *)alertWithTitle:(NSString *)theTitle 
						message:(NSString *)theMessage
			  cancelButtonTitle:(NSString *)cancelButtonTitle
			 cancelButtonAction:(AlertAction)cancelAction
	otherButtonTitlesAndActions:(id)titlesAndActions, ...
{
    if (!sharedDelegate) {
        sharedDelegate = [[UIAlertViewExtrasDelegate alloc] init];
    }
    
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:theTitle 
														message:theMessage
													   delegate:sharedDelegate
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
			}
			lastOtherButton = va_arg(argList, id);
		}
		va_end(argList);
	}
	if (cancelButtonTitle && cancelAction) {
		AlertAction copy = [cancelAction copy];
		[dict setObject:copy forKey:[NSNumber numberWithInteger:[alertView cancelButtonIndex]]];
	}
    [[sharedDelegate actions] addObject:dict];
    [[sharedDelegate alertViews] addObject:alertView];
    if ([[sharedDelegate actions] count] == 1) {
        [alertView show];                               
    }
	return alertView;
}
@end