//
//  AGKActivitySpinnerView.m
//  iOSLib
//
//  Created by Christoffer Lernö on 2010-06-09.
//  Copyright 2010 Aegik AB. All rights reserved.
//

#import "AGKActivitySpinnerView.h"


@interface AGKActivitySpinnerView()
{}
- (void)restoreAnimationState:(NSNotification *)notification;
@end

@implementation AGKActivitySpinnerView

- (id)initWithCoder:(NSCoder *)aDecoder {
	if ((self = [super initWithCoder:aDecoder])) {
		[[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(restoreAnimationState:) 
													 name:UIApplicationWillEnterForegroundNotification 
												   object:nil];		
	}
	return self;
}
- (id)initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyle)style {
	if ((self = [super initWithActivityIndicatorStyle:style])) {
		[[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(restoreAnimationState:) 
													 name:UIApplicationWillEnterForegroundNotification 
												   object:nil];
	}
	return self;
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)restoreAnimationState:(NSNotification *)notification {
	if ([self isAnimating]) {
		[self stopAnimating];
		[self startAnimating];		
	}
}

- (void)setAnimating:(BOOL)animating {
	if (animating == [self isAnimating]) return;
	if (!animating) {
		[self stopAnimating];
	}
	else {
		[self startAnimating];
	}
}
@end
