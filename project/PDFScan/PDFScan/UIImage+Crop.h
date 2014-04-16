//
//  UIImage+Crop.h
//  cdsPayment
//
//  Created by Ajit Randhawa on 7/24/12.
//  Copyright (c) 2012 Ajit Randhawa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Crop)

- (UIImage *)crop:(CGRect)rect;
- (UIImage *)cropNoScale:(CGRect)rect;

@end
