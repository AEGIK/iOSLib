//
//  AGKActivitySpinnerView.h
//  iOSLib
//
//  Created by Christoffer Lernö on 2010-06-09.
//  Copyright 2010 Aegik AB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AGKActivitySpinnerView : UIActivityIndicatorView {

}
- (id)initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyle)style;
- (void)setAnimating:(BOOL)animating;

@end
