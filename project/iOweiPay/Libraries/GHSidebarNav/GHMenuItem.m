//
//  GHMenuItem.m
//  iOweiPay
//
//  Created by Ajit Randhawa on 8/30/12.
//  Copyright (c) 2012 Ajit Randhawa. All rights reserved.
//

#import "GHMenuItem.h"

@implementation GHMenuSection

@synthesize header, items;

-(id)initWithHeader:(NSString *)hdr items:(NSArray *)itms
{
    self = [super init];
    if (self)
    {
        self.header = hdr;
        self.items = itms;
    }
    return self;
}

@end

@interface GHMenuItem ()
{
    NSString *_segue;
    UIViewController *_viewController;
    GHMenuItemViewControllerStyle _viewControllerStyle;
}
@end

@implementation GHMenuItem

@synthesize label, image, viewControllerStyle = _viewControllerStyle;

//-(void)setViewControllerStyle:(GHMenuItemViewControllerStyle)viewControllerStyle
//{
//    _viewControllerStyle = viewControllerStyle;
//}
//-(GHMenuItemViewControllerStyle)viewControllerStyle
//{
//    return _viewControllerStyle;
//}

-(NSString *)segue
{
    return _segue;
}
-(void)setSegue:(NSString *)segue
{
    _segue = segue;
    self.viewControllerStyle = GHMenuItemViewControllerStyleSegue;
}

-(UIViewController *)viewController
{
    return _viewController;
}
-(void)setViewController:(UIViewController *)viewController
{
    _viewController = viewController;
    self.viewControllerStyle = GHMenuItemViewControllerStyleViewController;
}

- (id)initWithLabel:(NSString *)lbl image:(UIImage *)img segue:(NSString *)seg
{
    self = [super init];
    if (self)
    {
        self.label = lbl;
        self.image = img;
        self.segue = seg;
        self.viewControllerStyle = GHMenuItemViewControllerStyleSegue;
        if (seg == nil)
            self.viewControllerStyle = GHMenuItemViewControllerStyleNone;
    }
    return self;
}

-(id)initWithLabel:(NSString *)lbl image:(UIImage *)img viewController:(UIViewController *)controller
{
    self = [super init];
    if (self)
    {
        self.label = lbl;
        self.image = img;
        self.viewController = controller;
        self.viewControllerStyle = GHMenuItemViewControllerStyleViewController;
        if (controller == nil)
            self.viewControllerStyle = GHMenuItemViewControllerStyleNone;
    }
    return self;
}

@end
