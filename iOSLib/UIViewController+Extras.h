//
//  UIViewController+Extras.h
//  iOSLib
//
//  Created by Christoffer Lernö on 2010-12-12.
//  Copyright 2010 Aegik AB. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIViewController(Extras) 
+ (id)controllerWithDefaultNib;
+ (id)controllerWithDefaultNibFromBundle:(NSBundle *)nibBundleOrNil;

@end
