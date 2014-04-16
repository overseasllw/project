//
//  UIView+FirstResponder.m
//  cdsPayment
//
//  Created by Ajit Randhawa on 7/10/12.
//  Copyright (c) 2012 Ajit Randhawa. All rights reserved.
//

#import "UIView+FirstResponder.h"

@implementation UIView (FirstResponder)

- (UIView *)findFirstResponder
{
    if ([self isFirstResponder])
        return self;
    
    for (UIView * subView in self.subviews)
    {
        UIView * fr = [subView findFirstResponder];
        if (fr != nil)
            return fr;
    }
    
    return nil;
}

@end