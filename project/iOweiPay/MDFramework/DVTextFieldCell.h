//
//  DVTextFieldCell.h
//  cdsPayment
//
//  Created by Ajit Randhawa on 7/17/12.
//  Copyright (c) 2012 Ajit Randhawa. All rights reserved.
//

#import "DVTextCellBase.h"
#import <UIKit/UIKit.h>
#import "Controls/DVTextField.h"

#define DVTextFieldCellDefaultLeftPadding               85
#define DVTextFieldCellDefaultRightPadding              0
#define DVTextFieldCellRightPaddingWithDetailDisclosure 30

//typedef enum
//{
//    DVTextFieldCellAlignment
//} DVTextFieldCellAlignment;

@interface DVTextFieldCell : DVTextCellBase <UITextFieldDelegate>
{
    
    BOOL _isPassword;
}

@property (readonly) UITextField *field;
@property NSString *placeholder;

@property BOOL isPassword;
@property BOOL showsZeroValue;

-(void)positionTextFieldWithLeftPadding:(int)leftPadding
                         rightPadding:(int)rightPadding;
-(IBAction)textFieldWasChanged:(id)sender;

@end
