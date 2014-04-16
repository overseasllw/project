//
//  MyBankAccountsViewController.m
//  iOweiPay
//
//  Created by Ajit Randhawa on 9/1/12.
//  Copyright (c) 2012 Ajit Randhawa. All rights reserved.
//

#import "MyBankAccountsViewController.h"
#import "Wallet/WalletItemDetailViewController.h"
#import "../Appearance.h"
#import "../DataModel/DataModel.h"
#import "Segues.h"

@interface MyBankAccountsViewController ()

@end

@implementation MyBankAccountsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (MDTableViewStyle *)style
{
    return [Appearance styleForWalletMasterView];
}

- (NSArray *)initialObjects
{
    return [Account main].bankAccounts;
}

- (void)addItem:(id)sender
{
    [self performSegueWithIdentifier:ADD_BANK_ACCOUNT_SEGUE sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:ADD_BANK_ACCOUNT_SEGUE])
    {
        [(WalletItemDetailViewController *)segue.destinationViewController setupForAddMode:WalletItemTypeBankAccount];
    } else if ([segue.identifier isEqualToString:VIEW_BANK_ACCOUNT_SEGUE])
    {
        WalletItemDetailViewController *detailView = (WalletItemDetailViewController *)segue.destinationViewController;
        WalletItem *item = (WalletItem *)selectedItem;
        [detailView setMasterView:self];
        [detailView loadExistingItem:item];
    }
}

-(void)didSelectObject:(id)object atIndexPath:(NSIndexPath *)indexPath
{
    if ([object isKindOfClass:[WalletItem class]])
    {
        selectedItem = object;
        [self performSegueWithIdentifier:VIEW_BANK_ACCOUNT_SEGUE sender:self];
    } else
        [super didSelectObject:object atIndexPath:indexPath];
}

-(MDTableViewCell *)cellForObject:(id)object withIndexPath:(NSIndexPath *)indexPath
{
    return [super cellForObject:object withIndexPath:indexPath];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
