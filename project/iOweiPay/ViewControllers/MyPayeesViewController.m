//
//  MyPayeesViewController.m
//  iOweiPay
//
//  Created by Ajit Randhawa on 9/4/12.
//  Copyright (c) 2012 Ajit Randhawa. All rights reserved.
//

#import "MyPayeesViewController.h"

@interface MyPayeesViewController ()

@end

@implementation MyPayeesViewController

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
    self.tableView.contentOffset = CGPointMake(0, 44);
    //self.tableView.contentInset = UIEdgeInsetsMake(44, 0, 0, 0);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [super viewDidUnload];
}
@end
