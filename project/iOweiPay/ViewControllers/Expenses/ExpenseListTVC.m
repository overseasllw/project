//
//  ExpenseListTVC.m
//  iOweiPay
//
//  Created by Ajit Randhawa on 8/13/12.
//  Copyright (c) 2012 Ajit Randhawa. All rights reserved.
//

#import "ExpenseListTVC.h"
#include "ExpenseSheetTVC.h"
#import "Account.h"
#import "../../Server/Server.h"

@implementation ExpenseListTVC

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
    
    mySearchBar.delegate = self;
    
    CGRect newBounds = self.tableView.bounds;
    newBounds.origin.y = newBounds.origin.y +mySearchBar.bounds.size.height;

    self.tableView.bounds = newBounds;
    
    isFiltered = NO;
    isSearchBarHidden = YES;
}

- (IBAction)rightBarButtonActions:(UISegmentedControl *)sender

{
    if (sender.selectedSegmentIndex == 0)
    {
        if (isSearchBarHidden)
        {
            CGRect newBounds = self.tableView.bounds;
            newBounds.origin.y = newBounds.origin.y -mySearchBar.bounds.size.height;
            
            [self.tableView scrollRectToVisible:newBounds animated:YES];
            isSearchBarHidden = NO;
        }
        else
        {
            isFiltered = NO;
            [self.view endEditing:YES];
            [self.tableView reloadData];
            CGRect newBounds = self.tableView.bounds;
            newBounds.origin.y = newBounds.origin.y +mySearchBar.bounds.size.height;
            
            [self.tableView scrollRectToVisible:newBounds animated:YES];
            isSearchBarHidden = YES;
        }
        
    }
    else
    {
        [self performSegueWithIdentifier:@"AddExpenseSegue" sender:nil];
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}


-(void)viewWillAppear:(BOOL)animated
{
    DatabaseRequest *request = [[DatabaseRequest alloc] initWithOperation:@"getExpenses"];
    
    [DatabaseService performRequest:request completion:^(DatabaseAccessResult *result)
     {
         if (result.success)
         {
             NSLog(@"Success");
             expenseList = result.returnedRows;
             
             [self.tableView reloadData];
         }
     }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (isFiltered == YES)
        return [searchResults count];
    else
        return [expenseList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ExpenseListCell *cell = [mainTableView dequeueReusableCellWithIdentifier:@"ExpenseListCell"];
    
    
    
    NSDictionary *info;
    
    if (isFiltered == YES)
        info = [searchResults objectAtIndex:indexPath.row];
    else
        info = [expenseList objectAtIndex:indexPath.row];

    [cell addInfoFromDictionary:info];
    
    return cell;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == mainTableView)
        return YES;
    return NO;
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [SVProgressHUD showWithStatus:@"Deleting.."];
        // Delete the row from the data source
        DatabaseRequest *request = [[DatabaseRequest alloc] initWithOperation:@"deleteExpense" dictionary:[expenseList objectAtIndex:indexPath.row]];
        
        [DatabaseService performRequest:request completion:^(DatabaseAccessResult *result)
         {
             if (result.success)
             {
                 [expenseList removeObjectAtIndex:indexPath.row];
                 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                 [SVProgressHUD dismissWithSuccess:@"Done"];
             }
             else
                [SVProgressHUD dismissWithError:@"Cannot Delete"];
         }];
    }   
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
}

#pragma mark - Table view delegate
NSDictionary *expenseInfo;

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (isFiltered == YES)
        expenseInfo = [searchResults objectAtIndex:indexPath.row];
    else
        expenseInfo = [expenseList objectAtIndex:indexPath.row];

    
    [self performSegueWithIdentifier:@"editExpenseSegue" sender:nil];
}



-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"editExpenseSegue"])
    {
        EditExpenseSheetTVC *editExpense = (EditExpenseSheetTVC *)segue.destinationViewController;
        editExpense.expenseInfo = expenseInfo;
    }
}


#pragma mark - Search Bar Delegate Methods

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    isFiltered = NO;
    [self.view endEditing:YES];
    [self.tableView reloadData];
    
    CGRect newBounds = self.tableView.bounds;
    newBounds.origin.y = newBounds.origin.y +mySearchBar.bounds.size.height;
    isSearchBarHidden = YES;
    
    [self.tableView scrollRectToVisible:newBounds animated:YES];

}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    CGRect newBounds = self.tableView.bounds;
    newBounds.origin.y = newBounds.origin.y +mySearchBar.bounds.size.height;
    
    [self.tableView scrollRectToVisible:newBounds animated:YES];
    [self.tableView reloadData];
    isSearchBarHidden = YES;
}

NSString *currentSearchText;

 - (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope
{
    [self searchBar:searchBar textDidChange:currentSearchText];
}


-(void)searchBar:(UISearchBar*)searchBar textDidChange:(NSString*)text
{
    currentSearchText = text;
    isSearchBarHidden = NO;
    if(text.length == 0)
    {
        isFiltered = NO;
    }
    else
    {
        isFiltered = true;
        
        [searchResults removeAllObjects];
        searchResults = [[NSMutableArray alloc] init];
        
        NSString *scopeTitle;
        
        
        if ([searchBar selectedScopeButtonIndex] == 0)
            scopeTitle = @"ExpenseTitle";
        else if ([searchBar selectedScopeButtonIndex] == 1)
            scopeTitle = @"ExpenseFor";
        
        for (NSDictionary *info in expenseList)
        {
            NSString *compareString = [info objectForKey:scopeTitle];
            
            NSComparisonResult result = NSOrderedAscending;
            
            if (compareString != nil)
            {
                NSString *lowercase;
                lowercase=[compareString lowercaseString];
                compareString = lowercase;
                
                lowercase=[text lowercaseString];
                text = lowercase;
                
                NSRange range = [compareString rangeOfString:text];
                if (range.location != NSNotFound)
                    result = NSOrderedSame;
            }
            if (result == NSOrderedSame)
            {
                [searchResults addObject:info];
            }
        }
        
    }
    
    [self.tableView reloadData];
}


- (void)viewDidUnload {
    mainTableView = nil;
    [super viewDidUnload];
}
@end



@implementation ExpenseListCell

-(void)addInfoFromDictionary:(NSDictionary *)info
{
    self.expenseTitle.text = [info objectForKey:@"ExpenseTitle"];
    self.expenseFor.text = [info objectForKey:@"ExpenseFor"];
    self.total.text = [info objectForKey:@"Total"];
    self.balance.text = [info objectForKey:@"Balance"];
}

@end



