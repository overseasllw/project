//
//  NavigationTabBarViewController.m
//  cdsPayment
//
//  Created by Ajit Randhawa on 8/8/12.
//  Copyright (c) 2012 Ajit Randhawa. All rights reserved.
//

#import "NavigationTabBarViewController.h"

@interface NavigationTabBarViewController ()
//- (void)copyNavigationItem:(UIViewController *)other;
@end

@implementation NavigationTabBarViewController

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        //
//    }
//    return self;
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
//   self.delegate = self;
//    
//    int index = self.selectedIndex;
//    if (index < 0 || index > self.viewControllers.count)
//        index = 0;
//    if (self.viewControllers.count > 0)
//    {
//        UIViewController *controller = (UIViewController *)[self.viewControllers objectAtIndex:index];
//        [self copyNavigationItem:controller];
//    }
    
    self.tabBar.tintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"gradient"]];
}

//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//}
//
//- (void)viewDidAppear:(BOOL)animated
//{
//    [super viewDidAppear:animated];
//    [self copyNavigationItem:self.selectedViewController];
//}
//
//- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
//{
//    [self copyNavigationItem:viewController];
//}
//
//-(void)copyNavigationItem:(UIViewController *)other
//{
//    self.navigationItem.title = other.navigationItem.title;
//    self.navigationItem.prompt = other.navigationItem.prompt;
//    self.navigationItem.rightBarButtonItems = other.navigationItem.rightBarButtonItems;
//    self.navigationItem.leftBarButtonItems = other.navigationItem.leftBarButtonItems;
//    self.navigationItem.leftItemsSupplementBackButton = other.navigationItem.leftItemsSupplementBackButton;
//    self.navigationItem.backBarButtonItem = other.navigationItem.backBarButtonItem;
//    
//   
////    
////    return;
////    
////#define COPY_PROPERTY(propname) self.navigationItem. propname = other.navigationItem. propname
////    
////    //self.navigationItem.
////    COPY_PROPERTY(backBarButtonItem);
////    COPY_PROPERTY(hidesBackButton);
////    COPY_PROPERTY(leftBarButtonItems);
////    COPY_PROPERTY(leftItemsSupplementBackButton);
////    COPY_PROPERTY(rightBarButtonItems);
////    COPY_PROPERTY(title);
////    COPY_PROPERTY(titleView);
////    
////#undef COPY_PROPERTY
//}

//- (UINavigationItem *)navigationItem
//{
//    if (!self.selectedViewController)
//        return super.navigationItem;
//    return self.selectedViewController.navigationItem;
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
