//
//  AGKTextField.h
//  iOSLib
//
//  Created by Christoffer Lernö on 2010-08-09.
//  Copyright 2010 Aegik AB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AGKTextField : UITextField<UITextFieldDelegate> {}
@property (nonatomic, assign) NSUInteger maxLength;
@end
