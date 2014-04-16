//
//  LoginViewController.m
//  iOweiPay
//
//  Created by Ajit Randhawa on 8/15/12.
//  Copyright (c) 2012 Ajit Randhawa. All rights reserved.
//

#import "LoginViewController.h"
#import "../../Appearance.h"
#import "../Segues.h"
#import "../../DataModel/DataModel.h"
#import "RecoveryQuestionsViewController.h"

@interface LoginViewController ()
{
    DVTableViewCell *headerCell;
    
    DVTextFieldCell *cUserId;
    DVTextFieldCell *cPassword;
    
    DVButtonCell *cLoginButton;
    
    DVButtonCell  *bRegister;
    DVButtonCell  *bRecoverPassword;
    
    BOOL isLoggingIn;
    
    RecoveryQuestions *recovery;
}
@end

@implementation LoginViewController

-(id)initWithCoder:(NSCoder *)aDecoder
{
    return [super initWithCoder:aDecoder];
}

-(MDTableViewStyle *)style
{
    return [Appearance styleForLoginScreen];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    cPassword.value = @""; // For the final version.
    cPassword.value = @"qqqqqqqq"; // Until then.
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (!isLoggingIn)
        [self.navigationController setNavigationBarHidden:NO animated:animated];
    isLoggingIn = NO;
}

- (void)viewDidLoad
{
    DVTableViewSection *section;

    headerCell = [[DVEmptyCell alloc] init];
    //headerCell.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 75)];
    label.font = [UIFont boldSystemFontOfSize:54];
    label.textColor = [UIColor whiteColor];
    label.shadowColor = [UIColor blackColor];
    label.text = @"iOweiPay";
    label.textAlignment = UITextAlignmentCenter;
    [headerCell addSubview:label];
    headerCell.cellHeight = 75;
    label.backgroundColor = [UIColor clearColor];
    
    [self.sections addObject:[[DVTableViewSection alloc] initWithCells:@[headerCell]]];
    
    
    cUserId = [[DVTextFieldCell alloc] initWithLabel:@"Email"];
    cUserId.value = @"Davidq2012@gmail.com";
    cUserId.field.keyboardType = UIKeyboardTypeEmailAddress;
    
    cPassword = [[DVTextFieldCell alloc] initWithLabel:@"Password"];
    cPassword.value = @"qqqqqqqq";
    cPassword.isPassword = YES;
    
    
    section = [[DVTableViewSection alloc] initWithHeader:@"Login Information" cells:@[cUserId,cPassword]];
    section.header = nil;
    
    [self.sections addObject:section];
    
    cLoginButton = [[DVButtonCell alloc] initWithLabel:@"Login"];
    cLoginButton.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    [self.sections addObject:[[DVTableViewSection alloc] initWithCells:@[cLoginButton]]];
    
    bRegister = [[DVButtonCell alloc] initWithLabel:@"Sign Up"];
    bRegister.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    bRecoverPassword = [[DVButtonCell alloc] initWithLabel:@"Forgot Password"];
    bRecoverPassword.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    
    section = [[DVTableViewSection alloc] initWithCells:@[bRegister, bRecoverPassword]];
    section.footer = @"Need an account? Click \"Sign Up\" to get started.";
    [self.sections addObject:section];
    
    [super viewDidLoad];
}

-(void)buttonWasSelected:(DVButtonCell *)button
{
    if (button == cLoginButton)
    {
        NSString *segue = LOGIN_SUCCESS_FROM_LOGIN_SCREEN_SEGUE;
        [self endEditing];
        cLoginButton.enabled = NO;
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
        
        [Account accountWithLoginCredentials:cUserId.value password:cPassword.value completion:^(LoginResult result) {
        //[Account testlogin:cUserId.value p:cPassword.value c:^(LoginResult result) {
            [SVProgressHUD dismiss];
            cLoginButton.enabled = YES;
            if (result == LoginResultSuccessful)
            {
                //if recovery questions are not set up, present a dialog asking what to do
                if ([Account main].status == AccountStatusQuestions) {
                    [[[UIAlertView alloc] initWithTitle:@"Account Recovery Setup"
                                               message:@"Security questions will help you to reset your password or recover a stolen account.  It is recommended you take a few minutes to set up some questions now"
                                              delegate:self
                                     cancelButtonTitle:nil
                                      otherButtonTitles:@"Do it", @"Later", @"I\'ll take my chances", nil] show];
                } else if ([Account main].status == AccountStatusNotActivated)
                {
                    [[[UIAlertView alloc] initWithTitle:@"Account Activation"
                                                message:@"Your account currently isn't activated. Please check your email for a message containing a link to activate your account."
                                               delegate:nil
                                      cancelButtonTitle:nil
                                      otherButtonTitles:@"OK", nil] show];
                } else if ([Account main].status == AccountStatusTemporaryPassword)
                {
                    [[[UIAlertView alloc] initWithTitle:@"Temporary Password"
                                                message:@"You have recently reset your password and are currently using a temporary password. You can change your password in \"Account Settings\"."
                                               delegate:self
                                      cancelButtonTitle:nil
                                      otherButtonTitles:@"OK", nil] show];
                }
                else if ([Account main].status == AccountStatusActive)
                {
//                    [self performSegueWithIdentifier:LOGIN_SUCCESS_FROM_LOGIN_SCREEN_SEGUE sender:self];
                    [self performSegueWithIdentifier:segue sender:self];

                }
            } else if (result == LoginResultInvalidCredentials)
            {
                [[[UIAlertView alloc] initWithTitle:@""
                                            message:@"Invalid username or password."
                                           delegate:self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil] show];
            }
        }];
    } else if (button == bRegister)
    {
        [self performSegueWithIdentifier:SIGN_UP_FROM_LOGIN_SCREEN_SEGUE sender:self];
    } else if (button == bRecoverPassword)
    {
        NSString *email = cUserId.value;
        
        if (email == nil || (email.length == 0))
        {
            UIAlertView *view = [[UIAlertView alloc] initWithTitle:nil message:@"Please enter your email address." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [view show];
            return;
        }
        
        DatabaseRequest *r = [[DatabaseRequest alloc] initWithOperation:@"getRecoveryQuestions" dictionary:@{@"email" : email}];
        
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
        [DatabaseService performRequest:r completion:^(DatabaseAccessResult *result) {
            [SVProgressHUD dismiss];
            if (result.success && result.returnedRows.count > 0)
            {
                recovery = [[RecoveryQuestions alloc] initWithDatabaseDictionary:[result.returnedRows objectAtIndex:0]];
                [self performSegueWithIdentifier:FORGOT_PASSWORD_FROM_LOGIN_SCREEN_SEGUE sender:self];
            } else if ([[result.data valueForKey:@"errorType"] isEqual:@"noRecoverySet"])
            {
                [[[UIAlertView alloc] initWithTitle:nil
                                            message:@"You currently have no recovery questions set for your account. Please contact customer support to recover your account."
                                           delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil, nil] show];
            }
            else
            {
                [[[UIAlertView alloc] initWithTitle:@"Error"
                                            message:@"Please make sure you are connected to the network and have entered a valid email address, and try again."
                                           delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil, nil] show];
            }
        }];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:LOGIN_SUCCESS_FROM_LOGIN_SCREEN_SEGUE])
    {
        isLoggingIn = YES;
    }
    else if ([segue.identifier isEqualToString:QUESTIONS_FROM_LOGIN_SCREEN_SEGUE])
    {
        [segue.destinationViewController setUserAccountNumber:[Account main].userAccountNumber];
        [segue.destinationViewController setMode:RecoveryQuestionsModePreLogin];
    } else if ([segue.identifier isEqualToString:FORGOT_PASSWORD_FROM_LOGIN_SCREEN_SEGUE])
    {
        [segue.destinationViewController setUserAccountNumber:recovery.objectId];
        [(RecoveryQuestionsViewController *)segue.destinationViewController setData:recovery];
        [segue.destinationViewController setMode:RecoveryQuestionsModeRecovery];
        [segue.destinationViewController setEmail:cUserId.value];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIAlertView delegate methods

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    
    //handling for the recovery setup options dialog
    if ([[alertView title] isEqualToString:@"Account Recovery Setup"]) {
        
        switch (buttonIndex) {
            case 0: {
                
                //setup now button
                NSLog(@"Setup Questions");
                
                [self performSegueWithIdentifier:QUESTIONS_FROM_LOGIN_SCREEN_SEGUE sender:self];
                
            }break;
                
            case 1: {
                
                //setup later button
                NSLog(@"Skip Setup");
                [self performSegueWithIdentifier:LOGIN_SUCCESS_FROM_LOGIN_SCREEN_SEGUE sender:self];
                
            }break;
                
            case 2: {
                
                //setup never button
                NSLog(@"Screw that");
                
                //show a message with a reminder that this can be done from account management
                [[[UIAlertView alloc] initWithTitle:@"Setup Later" message:@"Remember, you can update your recovery questions at any time from account management." delegate:nil cancelButtonTitle:@"Yeah, whatever" otherButtonTitles:nil] show];
                
                //make a database request in the background to artificially set the account status to fully activated
                DatabaseRequest * bypass = [[DatabaseRequest alloc] initWithOperation:@"artificialRecoveryBypass"];
                [DatabaseService performRequest:bypass completion:^(DatabaseAccessResult *result) {
                    
                    //continue if the request is successful (bogus test right now)
                    if (result.success || !result.success) {
                        
                        //continue as normal
                        [self performSegueWithIdentifier:LOGIN_SUCCESS_FROM_LOGIN_SCREEN_SEGUE sender:self];
                    
                    }
                }];
                
                
                
            }break;
                
            default:
                break;
        }
        
    }else if ([[alertView title] isEqualToString:@"Temporary Password"])
    {
        [self performSegueWithIdentifier:LOGIN_SUCCESS_FROM_LOGIN_SCREEN_SEGUE sender:self];
    }
    
}

@end
