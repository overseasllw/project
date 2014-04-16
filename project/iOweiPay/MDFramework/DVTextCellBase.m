//
//  DVTextCellBase.m
//  cdsPayment
//
//  Created by Ajit Randhawa on 7/19/12.
//  Copyright (c) 2012 Ajit Randhawa. All rights reserved.
//

#import "DVTextCellBase.h"

@implementation DVTextCellBase

@synthesize maxLength;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

#pragma mark - Properties

- (NSInteger)minLength
{
    return _minLength;
}

- (void)setMinLength:(NSInteger)minLength
{
    _minLength = minLength;
}


@end
