//
//  NSIndexPath+Extras.m
//  iOSLib
//
//  Created by Christoffer Lernö on 2010-04-08.
//  Copyright 2010 Aegik AB. All rights reserved.
//

#import "NSIndexPath+Extras.h"


@implementation NSIndexPath(Extras)

+ (NSIndexPath *)indexPathForRow:(NSUInteger)row {
	NSUInteger path[2];
	path[0] = 0;
	path[1] = row;
	return [NSIndexPath indexPathWithIndexes:path length:2];
}

@end
