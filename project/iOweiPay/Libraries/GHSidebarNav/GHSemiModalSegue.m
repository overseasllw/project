//
//  GHSemiModalSegue.m
//  iOweiPay
//
//  Created by Ajit Randhawa on 9/1/12.
//  Copyright (c) 2012 Ajit Randhawa. All rights reserved.
//

#import "GHSemiModalSegue.h"
#import "GHRevealViewController.h"
@implementation GHSemiModalSegue

- (void)perform
{
    GHRevealViewController *src = self.sourceViewController;
    UIViewController *dst = self.destinationViewController;
    //    if (![dst isViewLoaded])
    //        [dst loadView];
    [dst viewDidLoad];
    UIViewController *actualController = dst;
    
    if (0)//(![dst isKindOfClass:[UINavigationController class]])
    {
        actualController = [[UINavigationController alloc] initWithRootViewController:dst];
        ((UINavigationController *)actualController).navigationBar.tintColor = src.defaultNavigationBarTint;
    }
    
    //[src showViewControllerSemiModal:actualController];
    [src showViewControllerPushed:actualController];
}

@end
