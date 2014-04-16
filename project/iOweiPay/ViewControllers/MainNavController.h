//
//  MainNavController.h
//  iOweiPay
//
//  Created by Ajit Randhawa on 8/30/12.
//  Copyright (c) 2012 Ajit Randhawa. All rights reserved.
//

#import "../Libraries/GHSidebarNav/GHRevealViewController.h"

@interface MainNavController : GHRevealViewController<UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UIToolbar *balanceToolbar;
@property (weak, nonatomic) IBOutlet UIView *mainContainerView;
@property (weak, nonatomic) IBOutlet UIView *moveableView;
@property (weak, nonatomic) IBOutlet UIView *footerView;

-(void)selectMenuItemWithSegue:(NSString *)segue;

@end
