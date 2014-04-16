//
//  CheckDataUpdate.h
//  PDFScan
//
//  Created by Liwei Lin on 12/1/12.
//  Copyright (c) 2012 Ajit Randhawa. All rights reserved.
//
//#define imageUrl @"http://173.15.239.213/PDF/getAllData.php"
#import <Foundation/Foundation.h>
#import "Database.h"

@class Reachability;
@interface CheckDataUpdate : NSObject{
    Reachability *wifiStatus;
}
@property Database *databse;
+(void)CheckPageNumberUpdate;
+(void) changePageNumberAfterMerge:(NSInteger)pageNum:(NSString *)url;
-(void)checkUnsuccessfulUploadPic;
-(void)checkUpload:(Reachability*)curReach;
-(void)updateDistanceDatabase:(NSString*)urlString:(NSString*)filepath;
@end
