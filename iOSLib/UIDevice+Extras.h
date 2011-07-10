//
//  UIDevice+Extras.h
//  Voddler
//
//  Created by Christoffer Lernö on 2011-29-03.
//  Copyright 2011 Aegik AB. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIDevice (Extras)

- (NSString *)platform;
- (size_t)freeMemory;
- (BOOL)isiPod2GOrEarlier;
- (BOOL)isiPhone3GOrEarlier;
@end

@interface NSBundle (DeviceExtras)
- (void)loadNibForCurrentInterfaceIdiomNamed:(NSString *)name owner:(id)owner options:(NSDictionary *)dictionary;

@end