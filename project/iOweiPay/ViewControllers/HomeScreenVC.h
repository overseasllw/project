//
//  HomeScreenVC.h
//  iOweiPay
//
//  Created by Ajit Randhawa on 8/16/12.
//  Copyright (c) 2012 Ajit Randhawa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeScreenVC : UIViewController<UIScrollViewDelegate>
{
    IBOutlet UIScrollView *scrollView;
    IBOutlet UIPageControl *pageControl;
    
    BOOL pageControlBeingUsed;
}

- (IBAction)changePage;

- (IBAction)logOut:(id)sender;

@end
