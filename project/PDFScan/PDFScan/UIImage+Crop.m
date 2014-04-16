//
//  UIImage+Crop.m
//  cdsPayment
//
//  Created by Ajit Randhawa on 7/24/12.
//  Copyright (c) 2012 Ajit Randhawa. All rights reserved.
//

#import "UIImage+Crop.h"

@implementation UIImage (Crop)

- (UIImage *)crop:(CGRect)rect {
    if (self.scale > 1.0f) {
        rect = CGRectMake(rect.origin.x * self.scale,
                          rect.origin.y * self.scale,
                          rect.size.width * self.scale,
                          rect.size.height * self.scale);
    }
    
    CGImageRef imageRef = CGImageCreateWithImageInRect(self.CGImage, rect);
    UIImage *result = [UIImage imageWithCGImage:imageRef scale:self.scale orientation:self.imageOrientation];
    CGImageRelease(imageRef);
    return result;
}

- (UIImage *)cropNoScale:(CGRect)rect
{
    //rect = CGRectMake(0, 0, 720, 100);
    CGImageRef imageRef = self.CGImage;
    imageRef = CGImageCreateWithImageInRect(imageRef, rect);
    UIImage *result = [UIImage imageWithCGImage:imageRef scale:self.scale orientation:self.imageOrientation];
    CGImageRelease(imageRef);
    return result;
}

@end
