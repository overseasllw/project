//
//  ExpenseListTVC.h
//  iOweiPay
//
//  Created by Ajit Randhawa on 8/13/12.
//  Copyright (c) 2012 Ajit Randhawa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "../../Libraries/SVProgressHUD/SVProgressHUD.h"

@interface ExpenseListTVC : UITableViewController<UISearchBarDelegate>
{
    NSMutableArray *expenseList, *searchResults;
    IBOutlet UISearchBar *mySearchBar;
    IBOutlet UITableView *mainTableView;
    
    BOOL isFiltered, isSearchBarHidden;
}


- (IBAction)rightBarButtonActions:(UISegmentedControl *)sender;

@end


@interface ExpenseListCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *expenseTitle;
@property (strong, nonatomic) IBOutlet UILabel *expenseFor;
@property (strong, nonatomic) IBOutlet UILabel *total;
@property (strong, nonatomic) IBOutlet UILabel *balance;

-(void)addInfoFromDictionary:(NSDictionary *)info;

@end

