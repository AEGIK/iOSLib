//
//  UIImageView+Extras.m
//  iOSLib
//
//  Created by Christoffer Lernö on 2010-12-07.
//  Copyright 2010 Aegik AB. All rights reserved.
//

#import "UIImageView+Extras.h"

@implementation UIImageView(Extras)
- (void)setImageNamed:(NSString *)imageName 
{
    [self setImage:[UIImage imageNamed:imageName]];
}
@end
