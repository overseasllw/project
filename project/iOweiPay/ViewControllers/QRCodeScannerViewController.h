//
//  QRCodeScannerViewController.h
//  cdsPayment
//
//  Created by Ajit Randhawa on 8/6/12.
//  Copyright (c) 2012 Ajit Randhawa. All rights reserved.
//

#import <UIKit/UIKit.h>

//#import "../Libraries/ZXing.h"
//#import "../Libraries/zxing/ZXingWidgetController.h"
#import "ZXingWidgetController.h"

@interface QRCodeScannerViewController : ZXingWidgetController<ZXingDelegate>

@end
