//
//  forgotPasswordTableViewController.h
//  loginMain2
//
//  Created by Ajit Randhawa on 7/30/12.
//  Copyright (c) 2012 Ajit Randhawa. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const URL_PASSRESET;

@interface forgotPasswordTableViewController : UITableViewController<UITextFieldDelegate>{
    
    NSString *BUTTON_CANCEL;
    NSString *BUTTON_RESET;
    
    NSString *F_ANSWER1;
    NSString *F_ANSWER2;
    NSString *F_ANSWER3;
    
    UITextField *TF_ANSWER1;
    UITextField *TF_ANSWER2;
    UITextField *TF_ANSWER3;
    
    NSArray *questionArray;
    NSArray *groups;
    NSArray *buttons;
    
}

- (id)initWithQuestionArray:(NSArray *)questions;

@end
