//
//  ExpenseDetailVC.m
//  iOweiPay
//
//  Created by Ajit Randhawa on 8/29/12.
//  Copyright (c) 2012 Ajit Randhawa. All rights reserved.
//

#import "ExpenseDetailVC.h"

@implementation ExpenseInfoVC

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.title != nil)
    {
        self.expenseTitle.text = self.title;
    }
    if (self.person != nil)
    {
        self.expenseFor.text = self.person;
    }
    
    if (self.responder == 0)
        [self.expenseTitle becomeFirstResponder];
    else
        [self.expenseFor becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    if (indexPath.section == 0)
    {
        cell = expenseTitleCell;
    }
    else
        cell = expenseForCell;
    
    return cell;
}

- (void)viewDidUnload {
    [self setExpenseTitle:nil];
    [self setExpenseTitle:nil];
    [self setExpenseFor:nil];
    [super viewDidUnload];
}
- (IBAction)cancel:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end



@implementation ExpenseItemVC

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (self.description != nil)
    {
        self.itemDescription.text = self.description;
    }
    if (self.amount != nil)
    {
        self.amountField.text = self.amount;
    }
    
    if (self.responder == 0)
        [self.itemDescription becomeFirstResponder];
    else
        [self.amountField becomeFirstResponder];
    
    [self.tableView scrollToRowAtIndexPath:[self.tableView indexPathForCell:amountCell] atScrollPosition:UITableViewScrollPositionNone animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    if (indexPath.section == 0)
    {
        cell = itemDescriptionCell;
    }
    else
        cell = amountCell;
    
    return cell;
}

- (void)viewDidUnload
{
    itemDescriptionCell = nil;
    amountCell = nil;
    [self setItemDescription:nil];
    [self setAmountField:nil];
    [super viewDidUnload];
}

- (IBAction)cancel:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end




@implementation ExpensePaymentVC

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self)
    {
        // Custom initialization
        paymentTypes = [NSMutableArray arrayWithObjects:@"Cash", @"Check", @"iOweiPay Transfer", nil];
        
        paymentTypePicker = [[UIPickerView alloc] init];
        paymentTypePicker.delegate = self;
        paymentTypePicker.dataSource = self;
        paymentTypePicker.showsSelectionIndicator = YES;
        self.paymentType.inputView = paymentTypePicker;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.amount != nil)
        self.amountField.text = self.amount;
    
    paymentTypes = [NSMutableArray arrayWithObjects:@"Cash", @"Check", @"iOweiPay Transfer", nil];
    
    paymentTypePicker = [[UIPickerView alloc] init];
    paymentTypePicker.delegate = self;
    paymentTypePicker.dataSource = self;
    paymentTypePicker.showsSelectionIndicator = YES;
    self.paymentType.inputView = paymentTypePicker;
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [paymentTypes count];
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [paymentTypes objectAtIndex:row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.paymentType.text = [paymentTypes objectAtIndex:row];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    if (indexPath.row == 0)
        cell = paymentTypeCell;
    else
        cell = amountCell;
    
    return cell;
}


- (void)viewDidUnload {
    paymentTypeCell = nil;
    amountCell = nil;
    [self setPaymentType:nil];
    [self setAmountField:nil];
    [super viewDidUnload];
}


- (IBAction)cancel:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end