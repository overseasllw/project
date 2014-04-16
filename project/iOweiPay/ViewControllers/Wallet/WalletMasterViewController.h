//
//  WalletMasterViewController.h
//  cdsPayment
//
//  Created by Ajit Randhawa on 7/23/12.
//  Copyright (c) 2012 Ajit Randhawa. All rights reserved.
//

#import "MVTableViewController.h"
#import "WalletItemDetailViewController.h"

#define TAG_ADD_WALLET_ITEM -300

@class WalletItem;

@interface WalletMasterViewController : MVTableViewController <DVTableViewControllerDelegate>
{
    BOOL isPresentingModalDetailView;
    
    id selectedItem;
}



// Methods

- (IBAction)addItem:(id)sender;

- (NSArray *)initialObjects;
- (void)putObjectsInTable:(NSArray *)objects;

- (NSString *)textForEmptyView;         // The text that is displayed when there are no items. eg. "You have no wallet items";
- (MDTableViewCell *)cellForAddOnEmpty; // The cell that is added to the table when there are no items. eg. [   Add Item    > ]

- (NSMutableArray *)generateSectionsForItems:(NSArray *)items;

// These methods get called from the WalletItemDetailView
- (void)insertWalletItem:(WalletItem *)item;

@end
