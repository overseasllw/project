//
//  ExpenseSheetTVC.m
//  iOweiPay
//
//  Created by Ajit Randhawa on 8/13/12.
//  Copyright (c) 2012 Ajit Randhawa. All rights reserved.
//


#import "ExpenseSheetTVC.h"
#import "Account.h"
#import "../../Server/Server.h"


@implementation ExpenseSheetTVC

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self)
    {
        
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    doneFunction = @"addNewExpense";
    expense = [[NSMutableDictionary alloc] init];
    
    numberOfItems = 0;
    
    titleLabels = [NSArray arrayWithObjects:@"Title:", @"For:", nil];
    addExpenseLabels = [NSArray arrayWithObjects:@"Add Expense", nil];
    summaryLabels = [NSArray arrayWithObjects:@"Total: ", @"Paid: ", @"Balance: ", nil];
    
    labels = [NSMutableArray arrayWithObjects:titleLabels, addExpenseLabels, summaryLabels, nil];
    
    title = [[UITextView alloc]init];
    person = [[UITextField alloc]init];
    totalField = [[UITextField alloc]init];
    paidField = [[UITextField alloc]init];
    balanceField = [[UITextField alloc]init];
    
    title.backgroundColor = [UIColor clearColor];
    title.frame = CGRectMake(70, 3, 210, 24);
    title.userInteractionEnabled = NO;
    title.font = [UIFont systemFontOfSize:14];
    
    
    
    paidField.keyboardType = UIKeyboardTypeDecimalPad;
    paidField.textAlignment = NSTextAlignmentRight;
    totalField.textAlignment = NSTextAlignmentRight;
    balanceField.textAlignment = NSTextAlignmentRight;
    
    extra = [[UITextField alloc] init];
    
    [self modifyTextField:person];
    [self modifyTextField:totalField];
    [self modifyTextField:paidField];
    [self modifyTextField:balanceField];
    
    person.frame = CGRectMake(76, 12, 205, 24);
    
    titleFields = [NSArray arrayWithObjects:title, person, nil];
    addExpenseFields = [NSArray arrayWithObjects:extra, nil];
    summaryFields = [NSArray arrayWithObjects:totalField, paidField, balanceField, nil];
    
    fields = [NSMutableArray arrayWithObjects:titleFields, addExpenseFields, summaryFields, nil];
    
    [self.tableView setAllowsSelectionDuringEditing:YES];
    [self.tableView setEditing:YES];
    [self.tableView reloadData];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    int height = title.contentSize.height;
    if (height > 120)
    {
        height = 120;
    }
    title.frame = CGRectMake(70, 3, 210, height);
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)previewDone:(UISegmentedControl *)sender
{
    
    if (sender.selectedSegmentIndex == 0)
    {
        [self performSegueWithIdentifier:@"PreviewExpense" sender:nil];
    }
    else
    {
        [SVProgressHUD showWithStatus:@"Updating"];
        [self done];
    }
    
}

- (IBAction)cancel:(UIBarButtonItem *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Table View Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [labels count];;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[labels objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BOOL showAccessory = YES;
    
    NSString *CellIdentifier;
    if (indexPath.section == 1)
    {
        CellIdentifier = @"AddExpense";
    }
    else if (indexPath.section == [labels count]-1)
    {
        CellIdentifier = @"Summary";
        if (indexPath.row == 0 || indexPath.row == 2)
            showAccessory = NO;
    }
    else if ([[[labels objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] isEqualToString:@"Amount: "])
    {
       CellIdentifier = @"Amount";
    }
    else
    {
        CellIdentifier = @"Expense";
    }
    
    
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    UILabel *label;
    
    UIImageView *accessory = [[UIImageView alloc] initWithFrame:CGRectMake(280, 16, 12, 12)];
    accessory.image = [UIImage imageNamed:@"Disclosure"];
    
    // Configure the cell...
    //if (cell == nil)
    //{
    UITableViewCell *cell = [[UITableViewCell alloc] init]; //WithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 105, 24)];
        label.tag = 1;
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:14.0];
        
        if ([CellIdentifier isEqualToString:@"Summary"])
        {
            label.textAlignment = NSTextAlignmentRight;
        }
        else if ([CellIdentifier isEqualToString:@"AddExpense"])
        {
            accessory.frame = CGRectMake(246, 16, 12, 12);
        }
        else if ([CellIdentifier isEqualToString:@"Amount"])
        {
            label.textAlignment = NSTextAlignmentRight;
            label.frame = CGRectMake(13, 10, 80, 24);
            accessory.frame = CGRectMake(246, 16, 12, 12);
        }
    
    if (![[[labels objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] isEqualToString:@"Description"])
        [cell.contentView addSubview:label];
        [cell.contentView addSubview: [[fields objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]];
    
    if (showAccessory)
    {
        [cell.contentView addSubview:accessory];
    }
    
    
    //}
    
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    //label = (UILabel *)[cell.contentView viewWithTag:1];
    
    label.textColor = [UIColor grayColor];
    label.text = [[labels objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    label.font = [UIFont systemFontOfSize:14.0];
    
    return cell;
}

#pragma mark - Table View Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectedRow = indexPath;
    if (indexPath.section == 0)
    {
        [self performSegueWithIdentifier:@"editExpenseInfoSegue" sender:nil];
    }
    else if (indexPath.section == 1)
    {
        [self performSegueWithIdentifier:@"newExpenseItemSegue" sender:nil];
    }
    else if (indexPath.section == [labels count]-1)
    {
        [self performSegueWithIdentifier:@"editExpensePaymentSegue" sender:nil];
    }
    else
    {
         [self performSegueWithIdentifier:@"editExpenseItemSegue" sender:nil];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 4;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0)
    {
        if (title.contentSize.height < 44)
        {
            return 44;
        }
        else if (title.contentSize.height > 120)
        {
            return 120;
        }
        return title.contentSize.height+8;
    }
    else if ([[[labels objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] isEqualToString:@"Description"])
    {
        UITextView *textView = (UITextView *) [[fields objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        if (textView.contentSize.height < 44)
        {
            return 44;
        }
        else if (textView.contentSize.height > 120)
        {
            return 120;
        }
        return textView.contentSize.height+8;
    }
    else
        return 44;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 1)
    {
        return  UITableViewCellEditingStyleInsert;
    }
    else if (indexPath.section >1 && indexPath.section != [labels count]-1)
    {
        if (indexPath.row == 1)
            return UITableViewCellEditingStyleDelete;
        else
            return UITableViewCellEditingStyleNone;
        
    }
    else
        return UITableViewCellEditingStyleNone;
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [labels removeObjectAtIndex:indexPath.section];
        [fields removeObjectAtIndex:indexPath.section];
        
        numberOfItems--;
        [self calculateTotal];
        [self.tableView setEditing:NO animated:YES];
        
        [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
    }
}




#pragma mark ADD or Delete Item

-(void)addNewItem:(NSString *)description amount:(NSString *)amount
{
    UITextView *itemNameField = [[UITextView alloc] init];
    UITextField *amountField = [[UITextField alloc] init];
    
    itemNameField.userInteractionEnabled = NO;
    itemNameField.text = description;
    itemNameField.backgroundColor = [UIColor clearColor];
    itemNameField.font = [UIFont systemFontOfSize:14];
    itemNameField.textAlignment = NSTextAlignmentLeft;
    
    amountField.frame = CGRectMake(70, 12, 150, 24);
    amountField.userInteractionEnabled = NO;
    amountField.font = [UIFont systemFontOfSize:14];
    amountField.textAlignment = NSTextAlignmentRight;
    
    amountField.text = amount;

    itemNameField.frame = CGRectMake(10, 5, 260, 30);
    
    int height = itemNameField.contentSize.height;
    if (height > 120)
    {
        height = 120;
    }
    itemNameField.frame = CGRectMake(10, 5, 260, height);
    
    [self.tableView beginUpdates];
    NSMutableArray *label = [NSMutableArray arrayWithObjects:@"Description", @"Amount: ", nil];
    NSMutableArray *field = [NSMutableArray arrayWithObjects:itemNameField, amountField, nil];
    
    [labels insertObject:label atIndex:2];
    [fields insertObject:field atIndex:2];
    
    [self.tableView insertSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    
    [self.tableView endUpdates];

    numberOfItems++;
}


-(void)deleteItem:(UIButton *) sender
{    
    //NSIndexPath *indexPath = [self.tableView indexPathForCell:(UITableViewCell *)sender.superview.superview];
    
    if (self.tableView.editing == YES)
        [self.tableView setEditing:NO animated:YES];
    else
        [self.tableView setEditing:YES animated:YES];
}


#pragma mark Calculation Methods

-(void)calculateTotal
{
    float sum =0.00;
    for (int i =0; i < numberOfItems; i++)
    {
        NSString *formattedAmount = [[[fields objectAtIndex:2+i] objectAtIndex:1] text];
        
        float amount = [[self getAmountWithoutDollarSign:formattedAmount] floatValue];
        
        sum += amount;
    }
    
    totalField.text = [self formatAmount:sum];
    
    [self calculateBalance];
}

-(void)calculateBalance
{
    float balance = 0;
    
    float paidAmount = [[self getAmountWithoutDollarSign:paidField.text] floatValue];
    float totalAmount = [[self getAmountWithoutDollarSign:totalField.text] floatValue];
    
    balance = totalAmount - paidAmount;
    
    balanceField.text = [self formatAmount:balance];
}

-(NSString *) getAmountString:(NSString *) amount
{
    NSMutableString *returnAmount = [NSMutableString stringWithString:@"$0.00"];
    
    if (![amount isEqualToString:@""])
        returnAmount = [NSMutableString stringWithFormat:@"$%@",amount];
    
    return returnAmount;
}

-(NSString *) formatAmount:(float) amount
{
    if (amount == 0)
        return @"$0.00";
    return [NSString stringWithFormat:@"$%@", [[NSNumber numberWithFloat:amount] stringValue]];
}

-(NSString *) getAmountWithoutDollarSign:(NSString *) amount
{
    if (amount == nil || [amount isEqualToString:@""])
        return @"0.00";
    
    NSMutableString *a = [NSMutableString stringWithString:amount];
    
    NSRange range;
    range.location = 0;
    range.length = 1;
    [a deleteCharactersInRange:range];
    return a;
}


#pragma mark Segue Methods

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"editExpenseInfoSegue"])
    {
        expenseTitle = (ExpenseInfoVC *)segue.destinationViewController;
        
        expenseTitle.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(addExpenseTitle)];
        
        expenseTitle.title = title.text;
        expenseTitle.person = person.text;
        
        if (selectedRow.row == 0)
            expenseTitle.responder = 0;
        else
            expenseTitle.responder = (NSInteger *)1;
    }
    else if ([segue.identifier isEqualToString:@"newExpenseItemSegue"])
    {
        currentExpenseItem = (ExpenseItemVC *)segue.destinationViewController;
        
        currentExpenseItem.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(addExpenseItem)];
    }
    else if ([segue.identifier isEqualToString:@"editExpensePaymentSegue"])
    {
        expensePayment = (ExpensePaymentVC *)segue.destinationViewController;
        
        expensePayment.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(addExpensePayment)];
        
        NSString *amount;
        if ([paidField.text isEqualToString:@""])
            amount = @"";
        else
            amount = [self getAmountWithoutDollarSign:paidField.text];
        
        expensePayment.amount = amount;
    }
    else if ([segue.identifier isEqualToString:@"editExpenseItemSegue"])
    {
        currentExpenseItem = (ExpenseItemVC *)segue.destinationViewController;
        currentExpenseItem.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(updateExpenseItem)];
        
        UITextView *textView = (UITextView *) [[fields objectAtIndex:selectedRow.section] objectAtIndex:0];
        UITextField *amount = (UITextField *) [[fields objectAtIndex:selectedRow.section] objectAtIndex:1];
        
        currentExpenseItem.description = textView.text;
        currentExpenseItem.amount = [self getAmountWithoutDollarSign:amount.text];
        
        if (selectedRow.row == 0)
            currentExpenseItem.responder = 0;
        else
            currentExpenseItem.responder = (NSInteger *)1;
    }
    else if ([segue.identifier isEqualToString:@"PreviewExpense"])
    {
        PreviewExpense *preview = (PreviewExpense *)segue.destinationViewController;
        
        [self createExpenseString];
        NSLog(@"expense String      %@", expenseString);
        
        preview.expense = expenseString;
    }
}



#pragma mark DETAIL VIEW - ADD, UPDATE AND DONE METHODS

-(void)addExpenseTitle
{
    int height = expenseTitle.expenseTitle.contentSize.height;
    if (height > 120)
    {
        height = 120;
    }
    
    title.frame = CGRectMake(70, 3, 210, height);
    title.text = expenseTitle.expenseTitle.text;
    person.text = expenseTitle.expenseFor.text;
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    [expenseTitle.navigationController popViewControllerAnimated:YES];
    
}

-(void)addExpenseItem
{
    [self addNewItem:currentExpenseItem.itemDescription.text amount:[self getAmountString:currentExpenseItem.amountField.text]];
    [self calculateTotal];
    [currentExpenseItem.navigationController popViewControllerAnimated:YES];
}

-(void)updateExpenseItem
{
    
    UITextView *textView = (UITextView *) [[fields objectAtIndex:selectedRow.section] objectAtIndex:0];
    UITextField *amount = (UITextField *) [[fields objectAtIndex:selectedRow.section] objectAtIndex:1];
    
    textView.text = currentExpenseItem.itemDescription.text;
    amount.text = [self getAmountString:currentExpenseItem.amountField.text];
    
    
    int height = textView.contentSize.height;
    if (height > 120)
    {
        height = 120;
    }
    textView.frame = CGRectMake(10, 5, 260, height);
    
    
    [[fields objectAtIndex:selectedRow.section] replaceObjectAtIndex:0 withObject:textView];
    [[fields objectAtIndex:selectedRow.section] replaceObjectAtIndex:1 withObject:amount];
    
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    
    [self calculateTotal];
    
    [currentExpenseItem.navigationController popViewControllerAnimated:YES];
}


-(void)addExpensePayment
{
    paidField.text = [self getAmountString:expensePayment.amountField.text];
    [self calculateBalance];
    [expensePayment.navigationController popViewControllerAnimated:YES];
    
}


-(void)modifyTextField:(UITextField *)textfield
{
    textfield.frame = CGRectMake(100, 12, 150, 24);
    textfield.userInteractionEnabled = NO;
    textfield.font = [UIFont systemFontOfSize:14];
    
}

-(void)createExpenseString
{
    if (totalField.text == nil)
        totalField.text = @"$0.00";
    if (balanceField.text == nil)
        balanceField.text = @"$0.00";
    if (paidField.text == nil)
        paidField.text = @"$0.00";
    
    [self calculateTotal];
    expenseString = [[NSMutableString alloc] init];
    
    [expenseString appendString:[NSString stringWithFormat:@"ExpenseTitle=%@", title.text]];
    [expenseString appendString:[NSString stringWithFormat:@"&ExpenseFor=%@", person.text]];
    [expenseString appendString:[NSString stringWithFormat:@"&NumberOfItems=%@", @(numberOfItems)]];
    [expenseString appendString:[NSString stringWithFormat:@"&Total=%@", totalField.text]];
    [expenseString appendString:[NSString stringWithFormat:@"&PaidAmount=%@", paidField.text]];
    [expenseString appendString:[NSString stringWithFormat:@"&Balance=%@", balanceField.text]];
    
    for (int i =0; i < numberOfItems; i++)
    {
        
        NSString *itemName = [[[fields objectAtIndex:2+i] objectAtIndex:0] text];
        NSString *amount = [[[fields objectAtIndex:2+i] objectAtIndex:1] text];
        
        if (itemName == nil || amount == nil)
        {
            [SVProgressHUD show];
            [SVProgressHUD dismissWithError:@"Enter Item Description or Delete Item" afterDelay:2];
            return;
        }
        [expenseString appendString:[NSString stringWithFormat:@"&ItemName%d=%@", i , itemName]];
        [expenseString appendString:[NSString stringWithFormat:@"&ItemAmount%d=%@", i , amount]];
    }
}




-(void)done
{
    
    if (title.text == nil)
    {
        [SVProgressHUD show];
        [SVProgressHUD dismissWithError:@"Please, Enter a Title For Expense" afterDelay:1.0];
    }
    else if (person.text == nil)
    {
        [SVProgressHUD show];
        [SVProgressHUD dismissWithError:@"Please, Select or Enter Name" afterDelay:1.0];
    }
    else
    {
        
        if (totalField.text == nil)
            totalField.text = @"$0.00";
        if (balanceField.text == nil)
            balanceField.text = @"$0.00";
        if (paidField.text == nil)
            paidField.text = @"$0.00";
        
        [self calculateTotal];
        
        [expense setObject:title.text forKey:@"ExpenseTitle"];
        [expense setObject:person.text forKey:@"ExpenseFor"];
        [expense setObject:@(numberOfItems) forKey:@"NumberOfItems"];
        [expense setObject:totalField.text forKey:@"Total"];
        [expense setObject:paidField.text forKey:@"PaidAmount"];
        [expense setObject:balanceField.text forKey:@"Balance"];
        
        for (int i =0; i < numberOfItems; i++)
        {
            NSString *itemTitle = [NSString stringWithFormat:@"Item%d",i];
            NSString *AmountTitle = [NSString stringWithFormat:@"Amount%d",i];
            
            NSString *itemName = [[[fields objectAtIndex:2+i] objectAtIndex:0] text];
            NSString *amount = [[[fields objectAtIndex:2+i] objectAtIndex:1] text];
            
            if (itemName == nil || amount == nil)
            {
                [SVProgressHUD show];
                [SVProgressHUD dismissWithError:@"Enter Item Description or Delete Item" afterDelay:2];
                return;
            }
            
            [expense setObject:itemName forKey:itemTitle];
            [expense setObject:amount forKey:AmountTitle];
        }
        
        DatabaseRequest *request = [[DatabaseRequest alloc] initWithOperation:doneFunction dictionary:expense];
        
        [DatabaseService performRequest:request completion:^(DatabaseAccessResult *result)
         {
             if (result.success)
             {
                 NSLog(@"Success");
                 [SVProgressHUD dismissWithSuccess:@"Done"];
                 [self.navigationController popViewControllerAnimated:YES];
             }
         }];
        
    }
}


@end

@implementation EditExpenseSheetTVC
@synthesize expenseInfo;

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    doneFunction = @"updateExpense";
    
    numberOfItems = [[self.expenseInfo objectForKey:@"NumberOfItems"] integerValue];
    title.text = [self.expenseInfo objectForKey:@"ExpenseTitle"];
    person.text = [self.expenseInfo objectForKey:@"ExpenseFor"];
    paidField.text = [self.expenseInfo objectForKey:@"PaidAmount"];
    totalField.text = [self.expenseInfo objectForKey:@"Total"];
    balanceField.text = [self.expenseInfo objectForKey:@"Balance"];
    
    self.title = [NSString stringWithFormat:@"Edit %@", title.text];
    
    int height = title.contentSize.height;
    if (height > 120)
    {
        height = 120;
    }
    title.frame = CGRectMake(70, 3, 210, height);
    
    DatabaseRequest *request = [[DatabaseRequest alloc] initWithOperation:@"getExpenseItems" dictionary:expenseInfo];
    
    [DatabaseService performRequest:request completion:^(DatabaseAccessResult *result)
     {
         if (result.success)
         {
             NSLog(@"Success");
             NSMutableArray *itemsList = result.returnedRows;
             
             for (int i = 0; i < numberOfItems; i++)
             {
                 NSDictionary *itemInfo = [itemsList objectAtIndex:i];
                 numberOfItems--;
                 
                 NSString *itemName = [itemInfo objectForKey:@"ItemName"];
                 NSString *itemAmount  = [itemInfo objectForKey:@"Amount"];
                 
                 [self addNewItem:itemName amount:itemAmount];
             }
             //[self.tableView reloadData];
         }
     }];
}

-(void)updateExpense
{
    [expense setObject:[expenseInfo objectForKey:@"id"] forKey:@"id"];
    [self done];
    
}

- (IBAction)previewUpdate:(UISegmentedControl *)sender
{
    if (sender.selectedSegmentIndex == 0)
    {
        [self performSegueWithIdentifier:@"PreviewExpense" sender:nil];
    }
    else
    {
        [expense setObject:[expenseInfo objectForKey:@"id"] forKey:@"id"];
        [self done];
    }
}

- (IBAction)cancel:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

// Toolbar methods



@end











