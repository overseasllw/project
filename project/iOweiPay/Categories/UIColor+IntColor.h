//
//  UIColor+IntColor.h
//  cdsPayment
//
//  Created by Ajit Randhawa on 8/8/12.
//  Copyright (c) 2012 Ajit Randhawa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (IntColor)

+ (UIColor *)colorWithIntRed:(int)red
                    intGreen:(int)green
                     intBlue:(int)blue
                    intAlpha:(int)alpha;
+ (UIColor *)colorWithIntRed:(int)red
                    intGreen:(int)green
                     intBlue:(int)blue;

@end
