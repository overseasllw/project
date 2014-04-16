//
//  DVButtonCell.h
//  cdsPayment
//
//  Created by Ajit Randhawa on 7/18/12.
//  Copyright (c) 2012 Ajit Randhawa. All rights reserved.
//

#import "DVTableViewCell.h"

typedef enum
{
    DVButtonCellStyleDefault,
    DVButtonCellStyleSubtitle
} DVButtonCellStyle;

@interface DVButtonCell : DVTableViewCell

- (id)initWithStyle:(DVButtonCellStyle)style;
- (id)initWithLabel:(NSString *)label
           subtitle:(NSString *)subtitle;

@property NSString *subtitle;

@end
