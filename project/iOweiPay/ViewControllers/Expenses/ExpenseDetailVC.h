//
//  ExpenseDetailVC.h
//  iOweiPay
//
//  Created by Ajit Randhawa on 8/29/12.
//  Copyright (c) 2012 Ajit Randhawa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExpenseInfoVC : UITableViewController
{
    IBOutlet UITableViewCell *expenseTitleCell;
    IBOutlet UITableViewCell *expenseForCell;
}

@property (strong, nonatomic) IBOutlet UITextView *expenseTitle;
@property (strong, nonatomic) IBOutlet UITextField *expenseFor;

@property (nonatomic) NSInteger *responder;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *person;

- (IBAction)cancel:(id)sender;

@end







@interface ExpenseItemVC : UITableViewController
{
    IBOutlet UITableViewCell *itemDescriptionCell;
    IBOutlet UITableViewCell *amountCell;
}

@property (strong, nonatomic) IBOutlet UITextView *itemDescription;
@property (strong, nonatomic) IBOutlet UITextField *amountField;

@property (nonatomic) NSInteger *responder;
@property (strong, nonatomic) NSString *description;
@property (strong, nonatomic) NSString *amount;

- (IBAction)cancel:(id)sender;

@end








@interface ExpensePaymentVC : UITableViewController<UIPickerViewDataSource, UIPickerViewDelegate>
{
    IBOutlet UITableViewCell *paymentTypeCell;
    IBOutlet UITableViewCell *amountCell;
    UIPickerView *paymentTypePicker;
    NSMutableArray *paymentTypes;
}

@property (strong, nonatomic) IBOutlet UITextField *paymentType;
@property (strong, nonatomic) IBOutlet UITextField *amountField;

@property (strong, nonatomic) NSString *amount;

- (IBAction)cancel:(id)sender;

@end
