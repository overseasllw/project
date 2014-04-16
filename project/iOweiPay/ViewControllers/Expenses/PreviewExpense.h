//
//  PreviewExpense.h
//  iOweiPay
//
//  Created by Ajit Randhawa on 8/21/12.
//  Copyright (c) 2012 Ajit Randhawa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface PreviewExpense : UIViewController<MFMailComposeViewControllerDelegate>
{
    IBOutlet UIWebView *PDFview;
}

@property(strong, nonatomic) NSString* expense;

- (IBAction)cancel:(UIBarButtonItem *)sender;
- (IBAction)email:(UIBarButtonItem *)sender;

@end
