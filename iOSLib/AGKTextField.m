//
//  AGKTextField.m
//  iOSLib
//
//  Created by Christoffer Lernö on 2010-08-09.
//  Copyright 2010 Aegik AB. All rights reserved.
//

#import "AGKTextField.h"

@interface AGKTextFieldDelegate : NSObject<UITextFieldDelegate> {}
@property (nonatomic, assign) id<UITextFieldDelegate> delegate;
@end

@implementation AGKTextFieldDelegate

@synthesize delegate;

#pragma mark UITextFieldDelegate methods

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
	if (![[self delegate] respondsToSelector:@selector(textFieldShouldBeginEditing:)]) return YES;
	return [[self delegate] textFieldShouldBeginEditing:textField];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
	if (![[self delegate] respondsToSelector:@selector(textFieldDidBeginEditing:)]) return;
	[[self delegate] textFieldDidBeginEditing:textField];
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
	if (![[self delegate] respondsToSelector:@selector(textFieldShouldEndEditing:)]) return YES;
	return [[self delegate] textFieldShouldEndEditing:textField];	
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
	if (![[self delegate] respondsToSelector:@selector(textFieldDidEndEditing:)]) return;
	[[self delegate] textFieldDidEndEditing:textField];	
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
	NSUInteger newLength = [[textField text] length] + [string length] - range.length;
	if ([(AGKTextField *)textField maxLength] > 0 && newLength > [(AGKTextField *)textField maxLength]) return NO;
	if (![[self delegate] respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:)]) return YES;
	return [[self delegate] textField:textField shouldChangeCharactersInRange:range replacementString:string];	
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
	if (![[self delegate] respondsToSelector:@selector(textFieldShouldClear:)]) return YES;
	return [[self delegate] textFieldShouldClear:textField];	
}	

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	if (![[self delegate] respondsToSelector:@selector(textFieldShouldReturn:)]) return YES;
	return [[self delegate] textFieldShouldReturn:textField];		
}

@end


@interface AGKTextField() {}
@property (nonatomic, retain) AGKTextFieldDelegate *innerDelegate;
@end

@implementation AGKTextField

@synthesize innerDelegate, maxLength;

- (id)initWithCoder:(NSCoder *)aDecoder {
	if ((self = [super initWithCoder:aDecoder])) {
        innerDelegate = [[AGKTextFieldDelegate alloc] init];
		[innerDelegate setDelegate:[super delegate]];
		[super setDelegate:innerDelegate];
	}
	return self;
}

- (id)initWithFrame:(CGRect)frame {
	if ((self = [super initWithFrame:frame])) {
		AGKTextFieldDelegate *theInnerDelegate = [[AGKTextFieldDelegate alloc] init];
		[super setDelegate:theInnerDelegate];
		[self setInnerDelegate:theInnerDelegate];
		[theInnerDelegate release];
	}
	return self;
}

- (id<UITextFieldDelegate>)delegate {
	return [[self innerDelegate] delegate];
}
- (void)setDelegate:(id<UITextFieldDelegate>)newDelegate {
	[[self innerDelegate] setDelegate:newDelegate];
}

- (void)dealloc {
    [innerDelegate release];
	[super dealloc];
}
@end
