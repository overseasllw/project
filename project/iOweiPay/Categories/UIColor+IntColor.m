//
//  UIColor+IntColor.m
//  cdsPayment
//
//  Created by Ajit Randhawa on 8/8/12.
//  Copyright (c) 2012 Ajit Randhawa. All rights reserved.
//

#import "UIColor+IntColor.h"

@implementation UIColor (IntColor)

+ (UIColor *)colorWithIntRed:(int)red
                    intGreen:(int)green
                     intBlue:(int)blue
                    intAlpha:(int)alpha
{
    return [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:alpha/255.0];
}
+ (UIColor *)colorWithIntRed:(int)red
                    intGreen:(int)green
                     intBlue:(int)blue
{
    return [UIColor colorWithIntRed:red intGreen:green intBlue:blue intAlpha:255];
}

@end
