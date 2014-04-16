//
//  AppDelegate.h
//  PDFScan
//
//  Created by Ajit Randhawa on 11/12/12.
//  Copyright (c) 2012 Ajit Randhawa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReaderDocument.h"
#import "ReaderViewController.h"
@class Reachability;
@interface AppDelegate : UIResponder <UIApplicationDelegate,ReaderViewControllerDelegate,UINavigationControllerDelegate>{
      Reachability *wifiReach;
    id <ReaderViewControllerDelegate> delegate;
   //  UINavigationController *navigationController;
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain)   UINavigationController *rootNavigationController;
@end
