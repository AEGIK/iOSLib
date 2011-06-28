//
//  AGKRemoteImageView.h
//  iOSLib
//
//  Created by Christoffer Lernö on 2010-17-08.
//  Copyright 2010 Aegik AB. All rights reserved.
//

#import "AGKRemoteImageCache.h"

typedef enum AGKRemoteImageViewLoadStyle {
    AGKRemoteImageViewLoadStyleSpinner,
    AGKRemoteImageViewLoadStyleFadeIn,
} AGKRemoteImageViewLoadStyle;
@class AGKActivitySpinnerView;

@interface AGKRemoteImageView : UIView {
}

- (void)awakeFromNib;
- (NSString *)suffix;
- (void)updateURL:(NSString *)url;
- (AGKImageModifier)modifier;
- (AGKImage *)overlay;
- (void)clear;

@property (nonatomic, assign) AGKRemoteImageViewLoadStyle loadStyle;
@property (nonatomic, copy) NSString *imageCache;
@property (nonatomic, assign) UIActivityIndicatorViewStyle activityIndicatorViewStyle;
@property (nonatomic, retain) UIImage *replacementImage;
@property (nonatomic, retain, readonly) UIImage *loadedImage;
@property (nonatomic, copy) NSString *URL;
@property (nonatomic, retain) UIColor *borderColor;
@property (nonatomic, assign) CGFloat borderWidth;
@property (nonatomic, assign) CGFloat cornerRadius;
@end
