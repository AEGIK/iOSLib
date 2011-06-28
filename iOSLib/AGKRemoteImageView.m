//
//  AGKRemoteImageView.m
//  iOSLib
//
//  Created by Christoffer Lernö on 2010-17-08.
//  Copyright 2010 Aegik AB. All rights reserved.
//

#import "AGKRemoteImageView.h"
#import "NSURLConnection+Extras.h"
#import "UIView+Extras.h"
#import "UIImage+Extras.h"
#import "AGKActivitySpinnerView.h"
#import <QuartzCore/QuartzCore.h>
#import "CGFunctions.h"
#import "AGKImageCache.h"
#import "AGKRemoteImageDiskCache.h"
@interface AGKRemoteImageView() {
} 
@property (nonatomic, retain) AGKImageRequestHandle *handle;
@property (nonatomic, retain) AGKActivitySpinnerView *activityIndicatorView;
@property (nonatomic, retain, readwrite) UIImage *loadedImage;
@property (nonatomic, copy) NSString *imageURL;
@property (nonatomic, retain) UIImageView *replacementImageView;
@end

@implementation AGKRemoteImageView
@synthesize imageURL, handle, activityIndicatorView;
@synthesize imageCache, replacementImage, borderColor, borderWidth, cornerRadius;
@synthesize URL, activityIndicatorViewStyle, loadStyle, loadedImage, replacementImageView;

- (void)awakeFromNib 
{
	[self setOpaque:NO];
	[self setBackgroundColor:[UIColor clearColor]];
	[self setImageCache:@""];
	[self setImageURL:nil];
    [self setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
}

- (void)createReplacementImageView 
{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[self replacementImage]];
    [imageView setFrame:CGRectWithSize([self size])];
    [imageView setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    [imageView setContentMode:UIViewContentModeScaleAspectFill];
    [self addSubview:imageView];
    [self setReplacementImageView:imageView];
    [imageView release];
}


- (void)loadBegins 
{
    [[self replacementImageView] removeFromSuperview];
    [self setReplacementImageView:nil];
    [[self activityIndicatorView] removeFromSuperview];
    [self setActivityIndicatorView:nil];
    [self setLoadedImage:nil];
    
    if ([self loadStyle] == AGKRemoteImageViewLoadStyleSpinner) {
        AGKActivitySpinnerView *spinner = [[AGKActivitySpinnerView alloc] initWithActivityIndicatorStyle:[self activityIndicatorViewStyle]];
        [self setActivityIndicatorView:spinner];
        [spinner release];
        [spinner setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin];
        [self addSubview:spinner];
        [[self activityIndicatorView] centerInView:self];
        [[self activityIndicatorView] setAnimating:YES];
    } else {
        [self createReplacementImageView];
    }
}

- (void)clear 
{
    [self removeAllSubviews];
    [[self handle] cancel];
    [self setHandle:nil];
    [self setLoadedImage:nil];
    [self setImageURL:nil];
}

- (void)loadDone:(UIImage *)newImage
{
    [self setHandle:nil];
    if ([self activityIndicatorView]) {
        [[self activityIndicatorView] removeFromSuperview];
        [self setActivityIndicatorView:nil];
    } 
    switch ([self loadStyle]) {
        case AGKRemoteImageViewLoadStyleFadeIn:
            if (newImage && [self handle]) {                
                UIImageView *fadeInView = [[UIImageView alloc] initWithImage:newImage];
                [fadeInView setFrame:CGRectWithSize([self size])];
                [fadeInView setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
                [fadeInView setContentMode:UIViewContentModeScaleAspectFill];
                [self addSubview:fadeInView];
                [fadeInView setAlpha:0.0];
                [UIView animateWithDuration:0.3
                                      delay:0
                                    options:UIViewAnimationOptionAllowUserInteraction
                                 animations:^{
                                     [fadeInView setAlpha:1.0];
                                 }
                                 completion:^(BOOL finished) {
                                     [self setLoadedImage:newImage];
                                     [fadeInView removeFromSuperview];
                                     [[self replacementImageView] removeFromSuperview];
                                     [self setReplacementImageView:nil];
                                 }];
                [fadeInView release];
                return;
            }
            break;
        default:
            break;
    }
    [[self replacementImageView] removeFromSuperview];
    [self setReplacementImageView:nil];
    [self setLoadedImage:newImage ? newImage : [self replacementImage]];
}

- (void)drawRect:(CGRect)rect {
    [[self loadedImage] drawInRect:CGRectWithSize([self size])];
}

- (void)setLoadedImage:(UIImage *)newLoadedImage 
{
    if (loadedImage == newLoadedImage) return;
    [loadedImage release];
    loadedImage = [newLoadedImage retain];
    [self setNeedsDisplay];
}

- (NSString *)URL 
{
	return [self imageURL];
}

- (AGKImage *)overlay
{
    return nil;
}

- (AGKImageModifier)modifier 
{
    CGSize size = [self size];
    AGKColor *border = [AGKColor colorWithColor:[self borderColor]];
    CGFloat width = [self borderWidth];
    CGFloat radius = [self cornerRadius];
    AGKImage *overlay = [self overlay];
    return [[^(AGKImage *image) {
        return [image imageWithSize:size border:width borderColor:border cornerRadius:radius overlay:overlay];
    } copy] autorelease];
}

- (NSString *)suffix
{
    CGSize innerSize = [self size];
    return [NSString stringWithFormat:@"@%dx%d-%@", (int)innerSize.width, (int)innerSize.height, [self class]];
}

- (void)updateURL:(NSString *)theURL {
    [replacementImage release];
    replacementImage = [loadedImage retain];
    [self setURL:theURL];
}

- (void)setURL:(NSString *)theURL
{
	if (theURL == nil || [theURL isEqualToString:@"(null)"]) theURL = @"";
	if ([theURL isEqualToString:[self imageURL]]) return;
    if ([self handle]) {
     	[[self handle] cancel];
		[self setHandle:nil];
	}
    [self setImageURL:theURL];
	if ([theURL length] == 0) {
        [self setLoadedImage:[self replacementImage]];
		return;
	}
    if ([self loadStyle] == AGKRemoteImageViewLoadStyleSpinner) {
        [self setLoadedImage:nil];
    }
    AGKImageRequestHandle *theHandle = [[AGKRemoteImageCache sharedCacheNamed:[self imageCache]] retrieveImage:[self imageURL] 
                                                                                                        suffix:[self suffix]
                                                                                                      modifier:[self modifier]
                                                                                                          load:^(AGKImage *image) {
                                                                                                              [self loadDone:[image UIImage]];
                                                                                                          }];
    if (theHandle) {
        [self loadBegins];
        [self setHandle:theHandle];    
    }
}


- (void)dealloc {
	[handle cancel];
    [imageURL release];
    [borderColor release];
    [replacementImage release];
    [handle release];
    [loadedImage release];
    [replacementImageView release];
    [activityIndicatorView release];
	[super dealloc];
}

@end
