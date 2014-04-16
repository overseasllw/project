//
//  UploadPDF.m
//  PDFScan
//
//  Created by Ajit Randhawa on 11/28/12.
//  Copyright (c) 2012 Ajit Randhawa. All rights reserved.
//

#import "UploadPDF.h"
#import "PDFImageConverter.h"
#import "UIImageView+WebCache.h"
#import "RetrievePDFData.h"
#import "FMDatabase.h"

@implementation UploadPDF{
    
}


+(void)uploadPic:(NSData *)imageData:(NSObject *)filenametag{
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd-HH:mm:ss"];
    NSString *urlString = @"http://173.15.239.213/PDF/upload.php";
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    NSDateFormatter *formatter1 =[[NSDateFormatter alloc] init] ;
    [formatter1 setDateFormat:@"yyyyMMddHHmmss"];
     NSString *te =[[NSString alloc]init];
    if ([filenametag isKindOfClass:[NSString class]]) {
        te = [@"Content-Disposition: form-data; name=\"pdf\"; filename=\"" stringByAppendingString:[NSString stringWithFormat:@"%@",filenametag]];
    }else if ([filenametag isKindOfClass:[NSDate class]]){
        te = [@"Content-Disposition: form-data; name=\"pdf\"; filename=\"" stringByAppendingString:[formatter1 stringFromDate:(NSDate *)filenametag]];
    }

    te =  [te stringByAppendingString:@"\"\r\n"];
    NSMutableData *body = [NSMutableData data];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:te,index] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: application/pdf\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:imageData]];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:body];
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    NSLog(@"%@",returnString);
}


+(void)updatePDFUploadStatus:(NSDate*)date{
    NSDateFormatter *formatter1 =[[NSDateFormatter alloc] init] ;
    [formatter1 setDateFormat:@"yyyyMMddHHmmss"];
    Database *database=[[Database alloc]init];
    FMDatabase *updateinfo =[FMDatabase databaseWithPath:[database getPath]];
    if (![updateinfo open]) {
        NSLog(@"no available database!");
    }
    [updateinfo executeUpdate:@"update pdfData set uploaded='NO' where filepath=?",[NSString stringWithFormat:@"http://173.15.239.213/PDF/PDFS/%@.PDF",[formatter1 stringFromDate:date]]];
}
+(void)uploadPDFInfo:(NSDate *)filenametag:(NSString *)phplink:(ReaderDocument*)document{
    NSDateFormatter *formatter1 =[[NSDateFormatter alloc] init] ;
    [formatter1 setDateFormat:@"yyyyMMddHHmmss"];
    NSString *imagePath =@"http://173.15.239.213/PDF/PDFS/";
    imagePath =[imagePath stringByAppendingFormat:@"%@.PDF",[formatter1 stringFromDate:filenametag]];
    // NSLog(@"upload info%@",imagePath);
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd-HH:mm:ss"];
    NSString *urlString2 = @"http://173.15.239.213/PDF/";
    urlString2 = [urlString2 stringByAppendingFormat:@"%@.php?tag=%@&filename=%@&page=%@",phplink,[formatter stringFromDate:filenametag],[formatter1 stringFromDate:filenametag],document.pageCount];
    // NSLog(@"%@",urlString2);
    NSURL *moveImageURL = [NSURL URLWithString:urlString2];
    NSMutableURLRequest *updateimageinfo = [[NSMutableURLRequest alloc]initWithURL:moveImageURL];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:updateimageinfo delegate:self startImmediately:NO];


    [connection start];
/*
    NSData *returnData = [NSURLConnection sendSynchronousRequest:updateimageinfo returningResponse:nil error:nil];
    NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    NSLog(@"-------%@",returnString);*/
   // [PDFImageConverter WriteToLocal:[PDFImageConverter convertImageToPDF:self.image] withPDFName:imagePath];
    //  NSLog(@"upload info %@",imagePath);
   // [[SDImageCache sharedImageCache] storeImage:[RetrievePDFData Scaleimage:self.image TargetSize:CGSizeMake(94, 117)]  forKey:imagePath toDisk:YES];
}

+(void)cachePDF:(NSDate*)filename{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString *imagePath;
    
    imagePath =@"http://173.15.239.213/PDF/PDFS/";
    imagePath =[imagePath stringByAppendingFormat:@"%@.PDF",[dateFormatter stringFromDate:filename]];
    Database *dataInsert = [[Database alloc]init];
    FMDatabase *updateinfo =[FMDatabase databaseWithPath:[dataInsert getPath]];
    if (![updateinfo open]) {
        NSLog(@"no available database!");
    }
    [updateinfo executeUpdate:@"update pdfData set uploaded='NO' where filepath=?",imagePath];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd-HH:mm:ss"];
    //[PDFImageConverter WriteToLocal:[PDFImageConverter convertImageToPDF:self.image] withPDFName:imagePath];
}
@end
