//
//  WalletAddMenuViewController.h
//  cdsPayment
//
//  Created by Ajit Randhawa on 7/23/12.
//  Copyright (c) 2012 Ajit Randhawa. All rights reserved.
//

#import "DVTableViewController.h"
@class WalletMasterViewController;
@interface WalletAddMenuViewController : DVTableViewController <DVTableViewControllerDelegate>
@property WalletMasterViewController *masterView;
-(void)cancel;
@end
