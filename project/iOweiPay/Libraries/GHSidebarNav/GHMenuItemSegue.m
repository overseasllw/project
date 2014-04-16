//
//  GHMenuItemSegue.m
//  iOweiPay
//
//  Created by Ajit Randhawa on 8/30/12.
//  Copyright (c) 2012 Ajit Randhawa. All rights reserved.
//

#import "GHMenuItemSegue.h"

#import "GHRevealViewController.h"

@implementation GHMenuItemSegue

- (void)perform
{
    GHRevealViewController *src = self.sourceViewController;
    UIViewController *dst = self.destinationViewController;
//    if (![dst isViewLoaded])
//        [dst loadView];
    //[dst viewDidLoad];
    UIViewController *actualController = dst;
    
    if (![dst isKindOfClass:[UINavigationController class]])
    {
        actualController = [[UINavigationController alloc] initWithRootViewController:dst];
        ((UINavigationController *)actualController).navigationBar.tintColor = src.defaultNavigationBarTint;
    }
    
    src.contentViewController = actualController;
   
    [src toggleSidebar:NO duration:kGHRevealSidebarDefaultAnimationDuration];
}

@end
