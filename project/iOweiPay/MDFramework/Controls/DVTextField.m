//
//  DVTextField.m
//  iOweiPay
//
//  Created by Ajit Randhawa on 8/14/12.
//  Copyright (c) 2012 Ajit Randhawa. All rights reserved.
//

#import "DVTextField.h"

@interface DVTextField ()
{
    UIColor *_placeholderTextColor;
}

@end

@implementation DVTextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawPlaceholderInRect:(CGRect)rect {
	if (!_placeholderTextColor) {
		[super drawPlaceholderInRect:rect];
		return;
	}
    
    [_placeholderTextColor setFill];
    [self.placeholder drawInRect:rect withFont:self.font lineBreakMode:UILineBreakModeTailTruncation alignment:self.textAlignment];
}

-(UIColor *)placeholderTextColor
{
    return _placeholderTextColor;
}

-(void)setPlaceholderTextColor:(UIColor *)placeholderTextColor
{
    _placeholderTextColor = placeholderTextColor;
    if (!self.text && self.placeholder) {
		[self setNeedsDisplay];
	}
}

@end
