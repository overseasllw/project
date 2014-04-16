//
//  UploadPDF.h
//  PDFScan
//
//  Created by Ajit Randhawa on 11/28/12.
//  Copyright (c) 2012 Ajit Randhawa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReaderDocument.h"
@interface UploadPDF : NSObject{
    
}

+(void)uploadPic:(NSData *)imageData:(NSObject *)filenametag;
+(void)uploadPDFInfo:(NSDate *)filenametag:(NSString *)phplink:(ReaderDocument*)document;
+(void)updatePDFUploadStatus:(NSDate*)date;
@end
