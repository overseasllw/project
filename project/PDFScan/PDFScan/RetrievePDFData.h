//
//  RetrievePDFData.h
//  PDFScan
//
//  Created by Liwei Lin on 11/18/12.
//  Copyright (c) 2012 Ajit Randhawa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFDownloadRequestOperation.h"
#import "KDGoalBar.h"
#import "ReaderDocument.h"
#import "Database.h"
typedef NS_ENUM(NSUInteger, PDFDownloadStatus) {
    PDFDownloadStatusIdle,
    PDFDownloadStatusLoading,
    PDFDownloadStatusFinished,
    PDFDownloadStatusFailed,
};

@interface RetrievePDFData:NSObject{
   
    AFHTTPRequestOperation *request;
}

@property (nonatomic, assign, readonly) PDFDownloadStatus status;
//@property  (nonatomic,strong)IBOutlet KDGoalBar *progressView;
@property (nonatomic, strong) AFHTTPRequestOperation *request;
+(NSData *)RetrievePDFData:(NSString *)PDFForKey;
//+(UIProgressView *)DownloadWithUrl :(NSString*) url;
//+(KDGoalBar *)DownloadWithUrl :(NSString*) url;
-(KDGoalBar *)DownloadWithUrl :(NSString*) url;
+(void)asyncDownload:(NSString*)url;
+ (NSString *)cachePathForKey:(NSString *)key;
+(NSData*)DownloadFromWeb:(NSString*)url;
+(PDFDownloadStatus) processDownloadStatus;
+(UIImage*)cacheImage:(NSString*)forKey;
+ (UIImage *)Scaleimage:(UIImage*)source  TargetSize:(CGSize)targetSize;
+(void)fileCopy:(ReaderDocument *)object:(NSDate *)date;
+(NSData*)RetriveData:(NSDate*)date;
+(void)deleteFile:(NSString*)url;
//-(MKNetworkOperation*) downloadFatAssFileFrom:(NSString*) remoteURL;
@end
