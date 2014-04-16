//
//  QRCodeScannerViewController.m
//  cdsPayment
//
//  Created by Ajit Randhawa on 8/6/12.
//  Copyright (c) 2012 Ajit Randhawa. All rights reserved.
//

#import "QRCodeScannerViewController.h"
#import "ZXing.h"
#import "SVProgressHUD.h"

#import "QRObjectEncoder.h"

@interface QRCodeScannerViewController ()

@end

@implementation QRCodeScannerViewController

- (id)init
{
    self = [super initWithDelegate:nil showCancel:YES OneDMode:NO showLicense:NO];
    if (self) {
        self.overlayView.instructionsLabel.text = @"Position the barcode inside the viewfinder to scan it.";
        
        NSMutableSet *_readers = [[NSMutableSet alloc ] init];
        
#if ZXQR
        QRCodeReader* qrcodeReader = [[QRCodeReader alloc] init];
        [_readers addObject:qrcodeReader];
#endif
        
#if ZXAZ
        AztecReader *aztecReader = [[AztecReader alloc] init];
        [_readers addObject:aztecReader];
#endif
        self.delegate = self;
        self.readers = _readers;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [SVProgressHUD show];
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [SVProgressHUD dismiss];
    [super viewDidAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)scan:(id)sender {
    ZXingWidgetController *controller = [[ZXingWidgetController alloc] initWithDelegate:self showCancel:YES OneDMode:NO];
    
    NSMutableSet *_readers = [[NSMutableSet alloc ] init];
    
#if ZXQR
    QRCodeReader* qrcodeReader = [[QRCodeReader alloc] init];
    [_readers addObject:qrcodeReader];
#endif
    
#if ZXAZ
    AztecReader *aztecReader = [[AztecReader alloc] init];
    [_readers addObject:aztecReader];
#endif
    
    controller.readers = _readers;
    
    //controller.soundToPlay = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"beep-beep" ofType:@"aiff"] isDirectory:NO];
    
    //[self presentModalViewController:controller animated:YES];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [SVProgressHUD dismiss];
}

#pragma mark - ZXingDelegate Methods

- (void)zxingController:(ZXingWidgetController*)controller didScanResult:(NSString *)result
{
    [self.navigationController dismissModalViewControllerAnimated:YES];
    [[[UIAlertView alloc] initWithTitle:@"QR" message:result delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil] show];
}

- (void)zxingControllerDidCancel:(ZXingWidgetController*)controller
{
    [SVProgressHUD show];
    [self.presentingViewController dismissModalViewControllerAnimated:YES];
}


@end
