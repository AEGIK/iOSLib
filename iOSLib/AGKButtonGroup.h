//
//  AGKButtonGroup.h
//  iOSLib
//
//  Created by Christoffer Lernö on 2010-06-08.
//  Copyright 2010 Aegik AB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AGKButtonGroup : NSObject 
{

}
+ (AGKButtonGroup *)buttonGroupWithArray:(NSArray *)buttons;
- (id)init;
- (id)initWithButtons:(UIButton *)button1, ...;
- (NSInteger)select:(UIButton *)button;
- (UIButton *)selectByTag:(NSInteger)tag;
- (NSInteger)tag;
- (void)retag;
- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;

@property (nonatomic, retain, readonly) NSMutableArray *buttons;
@property (nonatomic, retain, readonly) UIButton *selectedButton; 
@end
