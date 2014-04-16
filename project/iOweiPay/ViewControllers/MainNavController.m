//
//  MainNavController.m
//  iOweiPay
//
//  Created by Ajit Randhawa on 8/30/12.
//  Copyright (c) 2012 Ajit Randhawa. All rights reserved.
//

#import "MainNavController.h"
#import "GHMenuViewController.h"
#import "Segues.h"
#import <QuartzCore/QuartzCore.h>
#import "../DataModel/DataModel.h"
#import "../Server/Server.h"

@interface NAVSEG : UIStoryboardSegue
@end
@implementation NAVSEG
- (void)perform {
    UIViewController *src = self.sourceViewController;
    UIViewController *dst = self.destinationViewController;
    src.view.window.rootViewController = dst; }
@end

@interface MainNavController ()
{
}
@property (readonly) GHMenuViewController *menu;
@end

@implementation MainNavController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (UIViewController *)controllerWithColor:(UIColor *)color
{
    UIViewController *c = [[UIViewController alloc]  init];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
    view.backgroundColor = color;
    [c.view addSubview:view];
    
    UINavigationController *controller = [[UINavigationController alloc] initWithRootViewController:c];
    controller.navigationBar.tintColor = color;
    
    return controller;
    //return c;
}

- (void)viewControllerWillBeShown:(UIViewController *)controller
{
    if ([controller isKindOfClass:[UINavigationController class]])
    {
        UINavigationController *c = (UINavigationController *)controller;
        [self addPanGestureToView:c.navigationBar];
    } else
        [self addPanGestureToView:controller.view];
}

- (GHMenuViewController *)menu
{
    return (GHMenuViewController *)self.sidebarViewController;
}

- (NSArray *) verboseMenuSections
{
    id sections = @[
    
    [[GHMenuSection alloc] initWithHeader:nil items:
     @[
     [[GHMenuItem alloc] initWithLabel:@"Home" image:[UIImage imageNamed:@"Home"] segue:MENU_ITEM_HOME]
     ]
     ],
    [[GHMenuSection alloc] initWithHeader:@"Payments" items:
     @[
     [[GHMenuItem alloc] initWithLabel:@"My Owes" image:nil segue:MENU_ITEM_OWES],
     [[GHMenuItem alloc] initWithLabel:@"My Payments" image:nil segue:MENU_ITEM_PAYMENTS],
     [[GHMenuItem alloc] initWithLabel:@"Something Else" image:nil viewController:[self controllerWithColor:[UIColor blueColor]]]
     ]
     ],
    [[GHMenuSection alloc] initWithHeader:@"Wallet" items:
     @[
     [[GHMenuItem alloc] initWithLabel:@"My Wallet" image:nil segue:MENU_ITEM_WALLET],
     [[GHMenuItem alloc] initWithLabel:@"My Credit Cards" image:[UIImage imageNamed:@"CreditCards"] segue:MENU_ITEM_CREDIT_CARDS],
     [[GHMenuItem alloc] initWithLabel:@"My Bank Accounts" image:[UIImage imageNamed:@"Bank"] segue:MENU_ITEM_BANK_ACCOUNTS]
     ]
     ],
    
    [[GHMenuSection alloc] initWithHeader:@"Expenses" items:
     @[
     [[GHMenuItem alloc] initWithLabel:@"My Expenses" image:nil segue:MENU_ITEM_EXPENSES]
     ]],
    
    [[GHMenuSection alloc] initWithHeader:@"Other" items:
     @[
     [[GHMenuItem alloc] initWithLabel:@"My Documents" image:nil segue:MENU_ITEM_DOCUMENTS],
     [[GHMenuItem alloc] initWithLabel:@"My Logins" image:nil segue:MENU_ITEM_LOGINS],
     [[GHMenuItem alloc] initWithLabel:@"My Notes" image:nil segue:MENU_ITEM_NOTES]
     ]
     ],
    [[GHMenuSection alloc] initWithHeader:@" " items:
     @[
     [[GHMenuItem alloc] initWithLabel:@"Settings" image:nil segue:MENU_ITEM_SETTINGS]
     ]
     ]
    ];
    return sections;
}

- (NSArray *)menuSections
{
    id sections = @[
    
    [[GHMenuSection alloc] initWithHeader:nil items:
     @[
     [[GHMenuItem alloc] initWithLabel:@"Home" image:nil segue:MENU_ITEM_HOME]
     ]
     ],
    [[GHMenuSection alloc] initWithHeader:@"Payments" items:
     @[
     [[GHMenuItem alloc] initWithLabel:@"Scan to Pay" image:nil segue:MENU_ITEM_SCAN_TO_PAY],
     [[GHMenuItem alloc] initWithLabel:@"Payees" image:nil segue:MENU_ITEM_PAYEES],         ///segue:MENU_ITEM_OWES],
     [[GHMenuItem alloc] initWithLabel:@"My Credit Cards" image:nil segue:MENU_ITEM_CREDIT_CARDS],
     [[GHMenuItem alloc] initWithLabel:@"My Bank Accounts" image:nil segue:MENU_ITEM_BANK_ACCOUNTS]
     ]
     ],
    [[GHMenuSection alloc] initWithHeader:@"Invite a Friend" items:
     @[
     [[GHMenuItem alloc] initWithLabel:@"Invite by Email" image:nil viewController:[self controllerWithColor:[UIColor blackColor]]],
     [[GHMenuItem alloc] initWithLabel:@"Invite by SMS" image:nil viewController:[self controllerWithColor:[UIColor blueColor]]]
     ]
     ],
    
    [[GHMenuSection alloc] initWithHeader:@" " items:
     @[
     [[GHMenuItem alloc] initWithLabel:@"Settings" image:nil segue:MENU_ITEM_SETTINGS]
     ]
     ]
    ];
    return sections;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [Account main].walletItems = [[Account main] fetchWalletItems:nil];
    
    self.defaultNavigationBarTint = [UIColor colorWithRed:134.0/255.0 green:170.0/255.0 blue:84.0/255.0 alpha:1.0];
    
    [_contentView removeFromSuperview];
    _contentView = self.mainContainerView;
    _contentView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    _contentView.backgroundColor = [UIColor clearColor];
    _contentView.layer.masksToBounds = NO;
    
    CALayer *layer = self.moveableView.layer;
    
    layer.shadowColor = [UIColor blackColor].CGColor;
    layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    layer.shadowOpacity = .8f;
    layer.shadowRadius = 35.0f;
    layer.shadowPath = [UIBezierPath bezierPathWithRect:layer.bounds].CGPath;

//    layer.corne
    
    id sections = [self menuSections];
    
    UIColor *bgColor = [UIColor colorWithRed:(50.0f/255.0f) green:(57.0f/255.0f) blue:(74.0f/255.0f) alpha:1.0f];
    UIToolbar *bar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    
    UIBarButtonItem *logoutbutton = [[UIBarButtonItem alloc] initWithTitle:@"Log Out" style:UIBarButtonItemStyleBordered target:self action:@selector(logout)];
    logoutbutton.tintColor = [UIColor blackColor];
    [bar setItems:@[
     
     //[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
     
     logoutbutton ]];
    
    bar.translucent = NO;
    bar.tintColor = bgColor;
    
    //self.balanceToolbar.tintColor = bgColor;
    self.balanceToolbar.translucent = NO;
    [self addPanGestureToView:self.balanceToolbar];
    
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"List"] landscapeImagePhone:[UIImage imageNamed:@"List"] style:UIBarButtonItemStylePlain target:self action:@selector(showNav)];
    item1.imageInsets = UIEdgeInsetsMake(7, -12, 0, 15);
    
    id baritems = [[NSMutableArray alloc] init];
    [baritems addObject:item1];
    [baritems addObjectsFromArray:self.balanceToolbar.items];
    
    self.balanceToolbar.items = baritems;
    
    //@[ [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"List"]] landscapeImagePhone:[UIImage imageNamed:@"List"] style:UIBarButtonItemStylePlain target:self action:@selector(showNav)]  ,[[UIBarButtonItem alloc] initWithTitle:@"Test." style:UIBarButtonItemStyleBordered target:nil action:nil] ];
    
    GHMenuViewController *menuController = [[GHMenuViewController alloc] initWithSidebarViewController:self withSearchBar:nil sections:sections];
//    id menuController = [[GHMenuViewController alloc] initWithSidebarViewController:self withHeader:bar headerIsFixed:NO sections:sections];
    menuController.footer = bar;
    self.sidebarViewController = menuController;
    
    // Add drag feature to each root navigation controller
//	[controllers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
//		[((NSArray *)obj) enumerateObjectsUsingBlock:^(id obj2, NSUInteger idx2, BOOL *stop2){
//			UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self
//																						 action:@selector(dragContentView:)];
//			panGesture.cancelsTouchesInView = YES;
//            if ([obj2 isKindOfClass:[UINavigationController class]])
//                [((UINavigationController *)obj2).navigationBar addGestureRecognizer:panGesture];
//            else
//                [[obj2 view] addGestureRecognizer:panGesture];
//		}];
//	}];
    
    
    [self.moveableView.superview bringSubviewToFront:self.moveableView];
    
}

- (void)showNav
{
    [self toggleSidebar:YES duration:.25];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    BOOL shouldHideBalance = //[segue.identifier isEqualToString:MENU_ITEM_BALANCE] ||
                             [segue.identifier isEqualToString:MENU_ITEM_SETTINGS];
    
    shouldHideBalance = NO;
    
    if (shouldHideBalance)
    {
        [UIView animateWithDuration:.35 animations:^{
            self.moveableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height + self.balanceToolbar.frame.size.height);
            self.footerView.frame = CGRectMake(0, self.view.frame.size.height, self.footerView.frame.size.width, self.footerView.frame.size.height);
        }];
    } else
    {
        //[UIView animateWithDuration:.35 animations:^{
            self.moveableView.frame = CGRectMake(self.moveableView.frame.origin.x, 0, self.view.frame.size.width, self.view.frame.size.height);
        self.footerView.frame = CGRectMake(0, self.view.frame.size.height - self.footerView.frame.size.height, self.footerView.frame.size.width, self.footerView.frame.size.height);
        //}];
    }
    
    if ([segue.identifier isEqualToString:MENU_ITEM_BALANCE])
    {
        [self.menu setHighlightedIndexPath:nil];
    }
}

- (IBAction)showBalance:(id)sender {
    
    [UIView animateWithDuration:.5 animations:^{
        self.moveableView.frame = CGRectOffset(self.moveableView.frame, 0, -1 * self.moveableView.frame.size.height);
    }];
}

-(void)selectMenuItemWithSegue:(NSString *)segue
{
    if (segue == nil)
        return;
    
    GHMenuViewController *menu = (GHMenuViewController *)self.sidebarViewController;
    
    for (int i = 0; i < menu.sections.count; i++)
    {
        GHMenuSection *section = [menu.sections objectAtIndex:i];
        for (int n = 0; n < section.items.count; n++)
        {
            GHMenuItem *item = [section.items objectAtIndex:n];
            if ([item.segue isEqualToString:segue])
            {
                [menu setHighlightedIndexPath:[NSIndexPath indexPathForRow:n inSection:i] scrollPosition:UITableViewScrollPositionNone];
//                [menu selectRowAtIndexPath:[NSIndexPath indexPathForRow:n inSection:i] animated:NO scrollPosition:UITableViewScrollPositionTop];
                return;
            }
        }
    }
}

- (void)logout
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Log Out" otherButtonTitles:nil, nil];
    sheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [sheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;
{
    if (actionSheet.cancelButtonIndex != buttonIndex)
    {
        [self toggleSidebar:NO duration:.25 completion:^(BOOL finished) {
            [self dismissModalViewControllerAnimated:YES];
            [DatabaseService performOperation:@"iosLogout"];
        }];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setBalanceToolbar:nil];
    [self setMainContainerView:nil];
    [self setMoveableView:nil];
    [self setFooterView:nil];
    [super viewDidUnload];
}
@end
