//
//  DVButtonCell.m
//  cdsPayment
//
//  Created by Ajit Randhawa on 7/18/12.
//  Copyright (c) 2012 Ajit Randhawa. All rights reserved.
//

#import "DVButtonCell.h"
#import "DVTableViewController.h"

@implementation DVButtonCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DVButtonCell"];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleBlue;
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        
        self.representedInDatabase = NO;
    }
    return self;
}

-(id)initWithStyle:(DVButtonCellStyle)style
{
    if (style == DVButtonCellStyleDefault)
        self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DVButtonCell#DVButtonCellStyleDefault"];
    else if (style == DVButtonCellStyleSubtitle)
        self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"DVButtonCell#DVButtonCellStyleSubtitle"];
    
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleBlue;
        self.representedInDatabase = NO;
    }
    return self;
}

-(id)initWithLabel:(NSString *)label subtitle:(NSString *)subtitle
{
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"DVButtonCell#DVButtonCellStyleSubtitle"];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleBlue;
        self.representedInDatabase = NO;
        self.textLabel.text = label;
        self.detailTextLabel.text = subtitle;
        self.detailTextLabel.numberOfLines = 0;
    }
    return self;
}

-(void)cellWasSelected
{
    [self.controller buttonWasSelected:self];
}

-(DVValidation *)applyValidation
{
    return nil; // [DVValidation valid];
}

#pragma mark - Properties

-(NSString *)subtitle
{
    return self.detailTextLabel.text;
}

-(void)setSubtitle:(NSString *)subtitle
{
    self.detailTextLabel.text = subtitle;
}

@end
