//
//  GHMenuItem.h
//  iOweiPay
//
//  Created by Ajit Randhawa on 8/30/12.
//  Copyright (c) 2012 Ajit Randhawa. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    GHMenuItemViewControllerStyleNone,
    GHMenuItemViewControllerStyleSegue,
    GHMenuItemViewControllerStyleViewController
} GHMenuItemViewControllerStyle;

@interface GHMenuSection : NSObject

@property NSString *header;
@property NSArray *items;

-(id)initWithHeader:(NSString *)hdr items:(NSArray *)itms;

@end

@interface GHMenuItem : NSObject

-(id)initWithLabel:(NSString *)lbl image:(UIImage *)img viewController:(UIViewController *)controller;
-(id)initWithLabel:(NSString *)lbl image:(UIImage *)img segue:(NSString *)seg;

@property NSString *label;
@property UIImage *image;
@property UIViewController *viewController;
@property NSString *segue;

@property GHMenuItemViewControllerStyle viewControllerStyle;

@end
