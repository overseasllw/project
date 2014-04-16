//
//  HomeScreenVC.m
//  iOweiPay
//
//  Created by Ajit Randhawa on 8/16/12.
//  Copyright (c) 2012 Ajit Randhawa. All rights reserved.
//

#import "HomeScreenVC.h"
#import "Segues.h"
#import "Account.h"
#import "WalletMasterViewController.h"

#import "MainNavController.h"

@interface HomeScreenVC ()
@property (readonly) MainNavController *navController;
@end

@implementation HomeScreenVC

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
    
    pageControlBeingUsed = NO;
	scrollView.contentSize = CGSizeMake(640, 347);
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    // Update the page when more than 50% of the previous/next page is visible
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    pageControl.currentPage = page;
}


- (IBAction)changePage
{
    // update the scroll view to the appropriate page
    CGRect frame;
    frame.origin.x = scrollView.frame.size.width * pageControl.currentPage;
    frame.origin.y = 0;
    frame.size = scrollView.frame.size;
    [scrollView scrollRectToVisible:frame animated:YES];
    
    pageControlBeingUsed = YES;
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
	pageControlBeingUsed = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	pageControlBeingUsed = NO;
}

- (MainNavController *)navController
{
    UIViewController *controller = self;
    
    while ((controller != nil) && (![controller isKindOfClass:[MainNavController class]]))
        controller = controller.parentViewController;
    
    return (MainNavController *)controller;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navController selectMenuItemWithSegue:MENU_ITEM_HOME];
}

//TODO: When we click an icon from the homescreen, If the destination view controller is also represented in the sidebar, we want to select that item in the sidebar when we do the segue to the destination. But when this view appears, we want to go back to having the Home item selected.
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:GLOBAL_WALLET_SEGUE])
    {
        [self.navController selectMenuItemWithSegue:MENU_ITEM_WALLET];
        
        WalletMasterViewController *controller = (WalletMasterViewController *)segue.destinationViewController;
        //[controller putObjectsInTable:[[Account main] walletItems]];
        [controller putObjectsInTable:[controller initialObjects]];
        
        
        [[Account main] fetchWalletItems:^(FetchResult result, NSMutableArray *items) {
            if (result == FetchResultSuccess)
            {
                [Account main].walletItems = items;
                [controller putObjectsInTable:[controller initialObjects]];
            }
        }];
    } else if ([segue.identifier isEqualToString:VIEW_LOGINS_FROM_HOMESCREEN_SEGUE])
    {
        [self.navController selectMenuItemWithSegue:MENU_ITEM_LOGINS];
    } else if ([segue.identifier isEqualToString:VIEW_NOTES_FROM_HOMESCREEN_SEGUE])
    {
        [self.navController selectMenuItemWithSegue:MENU_ITEM_NOTES];
    } else if ([segue.identifier isEqualToString:VIEW_DOCS_FROM_HOMESCREEN_SEGUE])
    {
        [self.navController selectMenuItemWithSegue:MENU_ITEM_DOCUMENTS];
    } else if ([segue.identifier isEqualToString:VIEW_EXPENSES_FROM_HOMESCREEN_SEGUE])
    {
        [self.navController selectMenuItemWithSegue:MENU_ITEM_EXPENSES];
    }
}




@end
