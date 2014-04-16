//
//  ExpenseSheetTVC.h
//  iOweiPay
//
//  Created by Ajit Randhawa on 8/13/12.
//  Copyright (c) 2012 Ajit Randhawa. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "SVProgressHUD.h"
#import "ExpenseDetailVC.h"
#import "PreviewExpense.h"
#import "../../Libraries/SVProgressHUD/SVProgressHUD.h"

@interface ExpenseSheetTVC: UITableViewController
{
    NSMutableArray *titleLabels, *addExpenseLabels,  *summaryLabels;
    NSMutableArray *titleFields, *addExpenseFields,  *summaryFields;
    NSMutableArray *labels, *fields;
    
    int numberOfItems;
    NSIndexPath *selectedRow;
    
    UITextView *title;
    UITextField *extra;
    UITextField *person;
    
    UITextField *totalField;
    UITextField *paidField;
    UITextField *balanceField;
    
    NSMutableDictionary *expense;
    NSMutableString *expenseString;
    NSString *doneFunction;
    
    ExpenseInfoVC *expenseTitle;
    ExpenseItemVC *currentExpenseItem;
    ExpensePaymentVC *expensePayment;
    
}

@property (assign, nonatomic) NSNumber *userID;

- (IBAction)previewDone:(UISegmentedControl *)sender;
- (IBAction)cancel:(UIBarButtonItem *)sender;


@end



@interface EditExpenseSheetTVC : ExpenseSheetTVC

@property (strong, nonatomic) NSDictionary *expenseInfo;
- (IBAction)previewUpdate:(UISegmentedControl *)sender;
- (IBAction)cancel:(id)sender;


@end
