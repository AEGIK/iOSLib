/*
 *  CGFunctions.h
 *  FCJ
 *
 *  Created by Christoffer Lernö on 2010-07-05.
 *  Copyright 2010 Aegik AB. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>
typedef enum AGKImageType {
    AGKImageTypeJPG,
    AGKImageTypePNG,
    AGKImageTypeUnknown,
} AGKImageType;

typedef void (^ContextAction)(CGContextRef context);

CGSize CGSizeRescaleToScreen(CGSize size);
CGFloat ScaleFactor(void);
CGPoint CGPointOffset(CGPoint point, CGFloat x, CGFloat y);
CGSize CGSizeMax(CGSize size1, CGSize size2);
CGPathRef CreateRoundedRect(CGRect rect, CGFloat cornerRadius);
CGRect CGRectWithSize(CGSize size);
void ClipToRoundedCorners(CGContextRef context, CGRect rect, CGFloat cornerRadius);
void DrawRoundedBorder(CGContextRef context, CGRect rect, CGFloat borderWidth, UIColor *color, CGFloat cornerRadius);
CGRect CGSizeAspectFill(CGSize sourceSize, CGSize destinationSize);
CGImageRef CGImageResizeAndModifyWithBlock(CGImageRef image, CGSize size, ContextAction block);
CGSize CGSizeRescale(CGSize size, CGFloat scaleFactor);
CGImageRef CGImageCreateFromFile(NSString *fullPath, AGKImageType imageType);

