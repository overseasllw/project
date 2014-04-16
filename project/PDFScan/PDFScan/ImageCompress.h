//
//  ImageCompress.h
//  TakeCaptureViewPic
//
//  Created by Liwei Lin on 10/11/12.
//  Copyright (c) 2012 Ajit Randhawa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIImage(rotate)

-(UIImage*)rotateImage:(UIImage *)image :(int)kMaxResolution;
-(UIImage*)imageWithImage:  (UIImage*)sourceImage scaledToSizeWithSameAspectRatio  :(CGSize)targetSize;
@end
