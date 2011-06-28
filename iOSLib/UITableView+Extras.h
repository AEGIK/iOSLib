//
//  UITableView+Extras.h
//  iOSLib
//
//  Created by Christoffer Lernö on 2010-21-07.
//  Copyright 2010 Aegik AB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView(Extras)
- (id)dequeueReusableCellBasedOnNib:(NSString *)nibName;
- (void)insertSection:(NSUInteger)section withRowAnimation:(UITableViewRowAnimation)animation;
- (void)deleteSection:(NSUInteger)section withRowAnimation:(UITableViewRowAnimation)animation;
- (void)insertRow:(NSUInteger)row withRowAnimation:(UITableViewRowAnimation)animation;
- (void)reloadRow:(NSUInteger)row withRowAnimation:(UITableViewRowAnimation)animation;
- (void)deleteRow:(NSUInteger)row withRowAnimation:(UITableViewRowAnimation)animation;
- (void)deselectRow:(NSUInteger)row;
- (void)syncWithTable:(UITableView *)otherTable;
@end
