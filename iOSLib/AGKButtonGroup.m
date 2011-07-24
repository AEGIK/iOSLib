//
//  AGKButtonGroup.m
//  iOSLib
//
//  Created by Christoffer Lernö on 2010-06-08.
//  Copyright 2010 Aegik AB. All rights reserved.
//

#import "AGKButtonGroup.h"
#import "UIButton+Extras.h"

@interface AGKButtonGroup()
{
}
@property (nonatomic, strong, readwrite) NSMutableArray *buttons;
@property (nonatomic, strong, readwrite) UIButton *selectedButton; 
@end

@implementation AGKButtonGroup
@synthesize buttons = _buttons, selectedButton = _selectedButton;

+ (AGKButtonGroup *)buttonGroupWithArray:(NSArray *)buttons 
{
    AGKButtonGroup *buttonGroup = [[AGKButtonGroup alloc] init];
    [[buttonGroup buttons] addObjectsFromArray:buttons];
    return buttonGroup;
}

- (void)retag 
{
    NSUInteger tag = 0;
    for (UIButton *button in [self buttons]) {
        [button setTag:(NSInteger)tag++];
    }
}

- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    for (UIButton *button in [self buttons]) {
        [button addTarget:target action:action forControlEvents:controlEvents];
    }
}

- (id)init 
{
	if ((self = [super init])) {
        _buttons = [[NSMutableArray alloc] initWithCapacity:5];
	}
	return self;
}

- (id)initWithButtons:(UIButton *)button1, ...
{
	if ((self = [super init])) {
		void *eachButton;
		va_list argumentList;
		_buttons = [[NSMutableArray alloc] initWithCapacity:5];
		if (button1) {
			[_buttons addObject:button1];
			va_start(argumentList, button1);
			while ((eachButton = va_arg(argumentList, void *)))
			{
				[_buttons addObject:(__bridge UIButton *)eachButton];
			}
			va_end(argumentList);
		}
	}
	return self;
}

- (UIButton *)selectByTag:(NSInteger)tag {
	UIButton *buttonFound = nil;
	for (UIButton *theButton in [self buttons]) {
		if ([theButton tag] == tag) {
			buttonFound = theButton;
		} else {
			[theButton deselect];
		}
	}
	[buttonFound select];
	[self setSelectedButton:buttonFound];
	return buttonFound;
}

- (NSInteger)tag {
	return [[self selectedButton] tag];
}

- (NSInteger)select:(UIButton *)button 
{
	if (button == nil || [[self buttons] indexOfObject:button] == NSNotFound) return NSNotFound;
	for (UIButton *theButton in [self buttons])
	{
		if (theButton != button) [theButton deselect];
	}
	[button select];
	[self setSelectedButton:button];
	return [button tag];
}

@end
