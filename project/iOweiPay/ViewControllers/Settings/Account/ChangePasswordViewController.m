//
//  ChangePasswordViewController.m
//  iOweiPay
//
//  Created by Ajit Randhawa on 8/22/12.
//  Copyright (c) 2012 Ajit Randhawa. All rights reserved.
//

#import "ChangePasswordViewController.h"
#import "../../../Appearance.h"
#import "../../../Encrypter.h"

@interface ChangePasswordViewController ()
{
    DVTextFieldCell *oldPasswordField,
                    *newPasswordField,
                    *confirmNewPasswordField;
    
    DVButtonCell *changePasswordButton;
}
@end

@implementation ChangePasswordViewController

-(MDTableViewStyle *)style
{
    return [Appearance styleForSettings];
}

- (DVTextFieldCell *)makePasswordField
{
    DVTextFieldCell *cell = [[DVTextFieldCell alloc] initWithLabel:@""];
    [cell positionTextFieldWithLeftPadding:0 rightPadding:0];
    cell.isPassword = YES;
    cell.field.textAlignment = NSTextAlignmentLeft;
    return cell;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSMutableArray *sections = [[NSMutableArray alloc] init];
    
    oldPasswordField = [self makePasswordField];
    oldPasswordField.propertyName = @"oldpassword";
//    oldPasswordField.placeholder = @"";
    oldPasswordField.placeholder = @"Old password";
    
    newPasswordField = [self makePasswordField];
    newPasswordField.propertyName = @"newpassword";
    newPasswordField.placeholder = @"Must be at least 8 characters";
    
    confirmNewPasswordField = [self makePasswordField];
    confirmNewPasswordField.placeholder = @"Confirm password";
    
    changePasswordButton = [[DVButtonCell alloc] initWithLabel:@"Save"];
    
    [sections addObject:[[DVTableViewSection alloc] initWithHeader:nil cells:@[oldPasswordField]]];
    [sections addObject:[[DVTableViewSection alloc] initWithHeader:@"New Password" cells:@[newPasswordField, confirmNewPasswordField]]];
    [sections addObject:[[DVTableViewSection alloc] initWithCells:@[changePasswordButton]]];
    
    self.sections = sections;
    self.cellsEditable = YES;
}

-(DVValidation *)prevalidateCell:(DVTableViewCell *)cell
{
    return [DVValidation valid];
}

-(void)buttonWasSelected:(DVButtonCell *)button
{
    if (button == changePasswordButton)
    {
        if (!(oldPasswordField.value && [oldPasswordField.value length]))
        {
            [[[UIAlertView alloc] initWithTitle:nil message:@"Please enter your old password." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
            oldPasswordField.validation = [DVValidation bannerWithMessage:@"Enter your old password." backgroundColor:self.style.detailTextColor foregroundColor:self.style.cellBackgroundColor];
            return;
        } else if ((!newPasswordField.value) || ([newPasswordField.value length] < 8))
        {
            [[[UIAlertView alloc] initWithTitle:nil message:@"Please enter a password of at least 8 characters." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
            newPasswordField.validation = [DVValidation bannerWithMessage:@"Must be at least 8 characters." backgroundColor:self.style.detailTextColor foregroundColor:self.style.cellBackgroundColor];
        } else if (!([newPasswordField.value isEqualToString:confirmNewPasswordField.value]))
        {
            [[[UIAlertView alloc] initWithTitle:nil message:@"Please make sure you have entered the same password twice." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
            confirmNewPasswordField.validation = [DVValidation bannerWithMessage:@"Passwords must match." backgroundColor:self.style.detailTextColor foregroundColor:self.style.cellBackgroundColor];
        } else
        {
            [SVProgressHUD showWithStatus:@"Please wait..." maskType:SVProgressHUDMaskTypeGradient];
            
            NSString *oldpassword = [Encrypter sha2:oldPasswordField.value];
            NSString *newpassword = [Encrypter sha2:newPasswordField.value];
            
            if ([oldpassword isEqualToString:newpassword])
            {
                [SVProgressHUD dismiss];
                [self.navigationController popViewControllerAnimated:YES];
                [[[UIAlertView alloc] initWithTitle:@"Success" message:@"Your password has been changed." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
                return;
            }
            
            DatabaseRequest *r = [[DatabaseRequest alloc] initWithOperation:@"changePassword" dictionary:@{@"oldpassword":oldpassword, @"newpassword":newpassword}];
            
            [DatabaseService performRequest:r completion:^(DatabaseAccessResult *result) {
                [SVProgressHUD dismiss];
                if (result.success && (result.count == 1))
                {
                        [self.navigationController popViewControllerAnimated:YES];
                        [[[UIAlertView alloc] initWithTitle:@"Success" message:@"Your password has been changed." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
                } else
                {
                    id type = [result.data valueForKey:@"errortype"];
                    if ([type isEqual:@"wrongpassword"])
                    {
                        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"You have entered an incorrect password." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
                    }
                }
                
            }];
            
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
