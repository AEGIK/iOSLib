//
//  UITableView+Extras.m
//  iOSLib
//
//  Created by Christoffer Lernö on 2010-21-07.
//  Copyright 2010 Aegik AB. All rights reserved.
//

#import "UITableView+Extras.h"
#import "NSArray+Extras.h"
#import "NSIndexPath+Extras.h"
#import "AGK.h"

@implementation UITableView(Extras)

- (void)syncWithTable:(UITableView *)otherTable
{
    if (!otherTable) return;
    NSIndexPath *ownSelection = [self indexPathForSelectedRow];
    NSIndexPath *otherSelection = [otherTable indexPathForSelectedRow];
    if (!ownSelection) {
        if (otherSelection) [otherTable deselectRowAtIndexPath:otherSelection animated:NO];
    } else {
        [otherTable selectRowAtIndexPath:ownSelection animated:NO scrollPosition:UITableViewScrollPositionNone];
        if ([[otherTable delegate] respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
            [[otherTable delegate] tableView:otherTable didSelectRowAtIndexPath:ownSelection];
        }
    }
    [otherTable setContentOffset:[self contentOffset]];
}

- (id)dequeueReusableCellBasedOnNib:(NSString *)nibName;
{
	// Dequeue the cell.
	UITableViewCell *cell = [self dequeueReusableCellWithIdentifier:nibName];
	if (!cell) {
		
		// Load the cell from the bundle of the same name.
		cell = [[[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil] firstObject];
		
		// Make sure our identifier is correct, if not we can't reuse cells, so log this.
		if (![[cell reuseIdentifier] isEqualToString:nibName]) {
			NSLog(@"WARNING! Illegal identifier set on table cell in nib %@, preventing reuse.", nibName);
		}
	}
	return cell;
}

- (void)deselectRow:(NSUInteger)row {
	[self deselectRowAtIndexPath:[NSIndexPath indexPathForRow:row] animated:NO];
}

- (void)insertSection:(NSUInteger)section withRowAnimation:(UITableViewRowAnimation)animation {
	NSIndexSet *set = [[NSIndexSet alloc] initWithIndexesInRange:NSMakeRange(section, 1)];
	[self insertSections:set withRowAnimation:animation];
	[set release];
}

- (void)deleteSection:(NSUInteger)section withRowAnimation:(UITableViewRowAnimation)animation {
	NSIndexSet *set = [[NSIndexSet alloc] initWithIndexesInRange:NSMakeRange(section, 1)];
	[self deleteSections:set withRowAnimation:animation];
	[set release];	
}

- (void)insertRow:(NSUInteger)row withRowAnimation:(UITableViewRowAnimation)animation {
	NSUInteger path[2];
	path[0] = 0;
	path[1] = row;
	NSIndexPath *indexPath = [[NSIndexPath alloc] initWithIndexes:path length:2];
	NSArray *array = [[NSArray alloc] initWithObjects:indexPath, nil];
	[self insertRowsAtIndexPaths:array withRowAnimation:animation];
	[array release];
	[indexPath release];
}

- (void)deleteRow:(NSUInteger)row withRowAnimation:(UITableViewRowAnimation)animation {
	if ([self numberOfRowsInSection:0] <= (NSInteger)row) return;
	NSUInteger path[2];
	path[0] = 0;
	path[1] = row;
	NSIndexPath *indexPath = [[NSIndexPath alloc] initWithIndexes:path length:2];
	NSArray *array = [[NSArray alloc] initWithObjects:indexPath, nil];
	[self deleteRowsAtIndexPaths:array withRowAnimation:animation];
	[array release];
	[indexPath release];
}

- (void)reloadRow:(NSUInteger)row withRowAnimation:(UITableViewRowAnimation)animation {
	if ([self numberOfRowsInSection:0] <= (NSInteger)row) return;
	NSUInteger path[2];
	path[0] = 0;
	path[1] = row;
	NSIndexPath *indexPath = [[NSIndexPath alloc] initWithIndexes:path length:2];
	NSArray *array = [[NSArray alloc] initWithObjects:indexPath, nil];
	[self reloadRowsAtIndexPaths:array withRowAnimation:animation];
	[array release];
	[indexPath release];
}
@end
