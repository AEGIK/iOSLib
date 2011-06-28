    //
//  UIViewController+Extras.m
//  iOSLib
//
//  Created by Christoffer Lernö on 2010-12-12.
//  Copyright 2010 Aegik AB. All rights reserved.
//

#import "UIViewController+Extras.h"


@implementation UIViewController(Extras)

+ (id)controllerWithDefaultNib {
	return [self controllerWithDefaultNibFromBundle:nil];
}

+ (id)controllerWithDefaultNibFromBundle:(NSBundle *)nibBundleOrNil {
	NSString *className = NSStringFromClass([self class]);
	NSRange range = [className rangeOfString:@"ViewController"];
	NSAssert(range.location != NSNotFound, @"Illegal name of controller subtype");
	return [[self alloc] initWithNibName:[className substringWithRange:NSMakeRange(0, range.location + 4)]
                                  bundle:nibBundleOrNil];
}

@end
