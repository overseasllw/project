//
//  PreviewExpense.m
//  iOweiPay
//
//  Created by Ajit Randhawa on 8/21/12.
//  Copyright (c) 2012 Ajit Randhawa. All rights reserved.
//

#import "PreviewExpense.h"

@implementation PreviewExpense
@synthesize expense;

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
	// Do any additional setup after loading the view.
    
    NSError *error;
    
    NSData * postData = [self.expense dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:NO];
    
    NSString * postLength = [NSString stringWithFormat:@"%d",[postData length]];
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] init];
    
    NSMutableString *url = [NSMutableString stringWithString:@"http://173.15.239.213/ioweipay/preview.php"];
    
    [request setURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    PDFview.scalesPageToFit = YES;
    [PDFview loadRequest:request];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancel:(UIBarButtonItem *)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)email:(UIBarButtonItem *)sender
{
    UIColor *myGreenColor = [UIColor colorWithRed:134.0/255.0 green:170.0/255.0 blue:84.0/255.0 alpha:1.0];
    
    MFMailComposeViewController *mailView = [[MFMailComposeViewController alloc] init];
    
    [mailView setSubject:@"Invoice #"];
    [mailView setMessageBody:@"This is an Invitation to Use This App" isHTML:NO];
    
    mailView.navigationBar.tintColor = myGreenColor;
    
    
    NSData * postData = [self.expense dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:NO];
    
    NSString * postLength = [NSString stringWithFormat:@"%d",[postData length]];
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] init];
    
    NSMutableString *url = [NSMutableString stringWithString:@"http://173.15.239.213/ioweipay/preview.php"];
    
    [request setURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSData *pdfData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    [mailView addAttachmentData:pdfData mimeType:@"application/pdf" fileName:@"invoice.pdf"];
    
    mailView.mailComposeDelegate = self;
    
    [self presentViewController:mailView animated:YES completion:NULL];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
