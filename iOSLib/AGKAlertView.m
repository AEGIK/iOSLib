//
//  AGKAlertView.m
//  iOSLib
//
//  Created by Christoffer Lernö on 2011-30-06.
//  Copyright 2011 AEGIK AB. All rights reserved.
//

#import "AGKAlertView.h"

@interface AGKAlertView() {}
@property (nonatomic, strong) UIAlertView *alertView;
@property (nonatomic, strong) NSMutableDictionary *dictionary;
@property (nonatomic, weak) id delegate;
@end

static __strong AGKAlertView *_currentView = nil;

@implementation AGKAlertView

@synthesize alertView = _alertView, delegate = _delegate;
@synthesize dictionary = _dictionary;

- (id)initWithDelegate:(id)delegate
{
    if ((self = [super init])) {
        _delegate = delegate;
        _dictionary = [[NSMutableDictionary alloc] initWithCapacity:3];
        _alertView = [[UIAlertView alloc] initWithTitle:nil message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
    }
    return self;
}

- (void)setTitle:(NSString *)title
{
    [[self alertView] setTitle:title];
}

- (void)setMessage:(NSString *)message
{
    [[self alertView] setMessage:message];
}

- (void)setCancelButton:(NSString *)cancelButton
{
    [self setCancelButton:cancelButton action:NULL];
}

- (void)setButton:(NSString *)button
{
    [self setButton:button action:NULL];
}

- (void)setCancelButton:(NSString *)cancelButton action:(SEL)selector
{
    NSInteger index = [[self alertView] addButtonWithTitle:cancelButton];
    [[self alertView] setCancelButtonIndex:index];
    if (selector) {
        [[self dictionary] setObject:[NSNumber valueWithPointer:selector] forKey:[NSNumber numberWithInteger:index]];        
    }
}
     
- (void)setButton:(NSString *)button action:(SEL)selector
{
    NSInteger index = [[self alertView] addButtonWithTitle:button];
    if (selector) {
        [[self dictionary] setObject:[NSNumber valueWithPointer:selector] forKey:[NSNumber numberWithInteger:index]];        
    }    
}

- (void)cancel
{
    NSInteger cancelIndex = [[self alertView] cancelButtonIndex];
    if (cancelIndex < 0) cancelIndex = 0;
    [[self alertView] setDelegate:nil];
    [[self alertView] dismissWithClickedButtonIndex:cancelIndex animated:NO];
}

- (void)show
{
    NSLog(@"Cancel %@", _currentView);
    if (_currentView) {
        [_currentView cancel];
    }
    _currentView = self;
    [[self alertView] show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSValue *selector = [[self dictionary] objectForKey:[NSNumber numberWithInteger:buttonIndex]];
    id theDelegate = [self delegate];
    [[self alertView] setDelegate:nil];
    _currentView = nil;
    if (selector) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [theDelegate performSelector:(SEL)[selector pointerValue] withObject:nil];
#pragma clang diagnostic pop
    }
}

@end
