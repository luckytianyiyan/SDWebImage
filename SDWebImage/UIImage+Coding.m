/**
 * @file UIImage+Coding.m
 *
 * @author luckytianyiyan@gmail.com
 * @date 15/9/19
 * @copyright   Copyright (c) 2015年 luckytianyiyan. All rights reserved.
 */

#import "UIImage+Coding.h"

static CGFloat const kMaxImageWidth = 1080;
static CGFloat const kMaxImageHeight = 1920;
/**
 *  @brief  Width / Height
 */
static CGFloat const kAspectRatio = 0.5625f;
@implementation UIImage (Coding)

- (UIImage *)imageCompressForPublish
{
    CGSize imageSize = self.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    if (width <= kMaxImageWidth && height <= kMaxImageHeight) {
        return self;
    }
    CGFloat aspectRatio = width / height;
    CGFloat targetWidth;
    CGFloat targetHeight;
    if (aspectRatio > kAspectRatio) {
        targetWidth = kMaxImageWidth;
        targetHeight = height / (width / targetWidth);
    } else {
        targetHeight = kMaxImageHeight;
        targetWidth = width / (height / targetHeight);
    }
    CGSize size = CGSizeMake(targetWidth, targetHeight);
    CGFloat scaleFactor = 0.0f;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0f, 0.0f);
    if (!CGSizeEqualToSize(imageSize, size)) {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        scaleFactor = fmaxf(widthFactor, heightFactor);
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        if (widthFactor > heightFactor) {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        } else if (widthFactor < heightFactor) {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    UIGraphicsBeginImageContext(size);
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [self drawInRect:thumbnailRect];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    if (newImage == nil) {
//        TyLogDebug(@"Scale Image Fail");
    }
    
    UIGraphicsEndImageContext();
    return newImage;
}

@end
