//
//  RetrievePDFData.m
//  PDFScan
//
//  Created by Liwei Lin on 11/18/12.
//  Copyright (c) 2012 Ajit Randhawa. All rights reserved.
//

#import "RetrievePDFData.h"
#import <CommonCrypto/CommonDigest.h>
#import <mach/mach.h>
#import <mach/mach_host.h>
#import "Database.h"
#import "AFDownloadRequestOperation.h"
#import "SDImageCache.h"
#import "UIImageView+WebCache.h"
#import "KDGoalBar.h"
#import "ReaderDocument.h"
typedef void(^SuccessBlock)(NSData *pdfData);
@interface RetrievePDFData(){
    PDFDownloadStatus status;
}
@property (nonatomic, assign) PDFDownloadStatus status;
@end
@implementation RetrievePDFData{
    AFHTTPRequestOperation *request2;
}
@synthesize request=request,status=status;
//@synthesize progressView=progressView;

-(KDGoalBar  *)DownloadWithUrl :(NSString*) url{
 
    KDGoalBar *progressView = [[KDGoalBar alloc]initWithFrame:CGRectMake(15, 28, 50, 50)];
     NSString *path=[[NSString alloc]initWithFormat:@"Documents/%@",[self cachePathForKey:url]];
    path = [NSHomeDirectory() stringByAppendingPathComponent:path];


    
    NSMutableURLRequest *requestn = [NSMutableURLRequest requestWithURL:[[NSURL alloc]initWithString:url ] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:3600];
    
    AFDownloadRequestOperation *operation = [[AFDownloadRequestOperation alloc] initWithRequest:requestn targetPath:path shouldResume:YES];
   
    __weak AFDownloadRequestOperation *pdfRequestWeak = operation;
    [pdfRequestWeak setShouldExecuteAsBackgroundTaskWithExpirationHandler:^{
        NSLog(@"Download background time expired for %@", pdfRequestWeak);
    }];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"DownloadFinished" object:self];
        NSLog(@"Successfully downloaded file to %@", path);
        self.status = PDFDownloadStatusFinished;
        [RetrievePDFData cacheImage:url];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"DownloadFailed" object:self];
        self.status=PDFDownloadStatusFailed;
    }];
    
    [operation setProgressiveDownloadProgressBlock:^(NSInteger bytesRead, long long totalBytesRead, long long totalBytesExpected, long long totalBytesReadForFile, long long totalBytesExpectedToReadForFile) {
        float percentDone = totalBytesReadForFile/(float)totalBytesExpectedToReadForFile;
        
        [progressView setPercent:percentDone*100 animated:YES];

        // self.currentSizeLabel.text = [NSString stringWithFormat:@"CUR : %lli M",totalBytesReadForFile/1024/1024];
        //  self.totalSizeLabel.text = [NSString stringWithFormat:@"TOTAL : %lli M",totalBytesExpectedToReadForFile/1024/1024];
        
        //  NSLog(@"------%f",percentDone);
        // NSLog(@"Operation%i: bytesRead: %d", 1, bytesRead);
        // NSLog(@"Operation%i: totalBytesRead: %lld", 1, totalBytesRead);
        //NSLog(@"Operation%i: totalBytesExpected: %lld", 1, totalBytesExpected);
        //NSLog(@"Operation%i: totalBytesReadForFile: %lld", 1, totalBytesReadForFile);
        //NSLog(@"Operation%i: totalBytesExpectedToReadForFile: %lld", 1, totalBytesExpectedToReadForFile);
    }];
    
    
    [operation start];
    
    request2 = operation;
    
    return progressView;
}

/*+(KDGoalBar  *)DownloadWithUrl :(NSString*) url{
   return [[[RetrievePDFData alloc]init] DownloadWithUrl:url];
}*/



+(PDFDownloadStatus) processDownloadStatus{
    
    return [[[RetrievePDFData alloc]init] status];
}
+(NSData*)RetriveData:(NSDate*)date{
    NSDateFormatter *formater=[[NSDateFormatter alloc]init];
    [formater setDateFormat:@"yyyyMMddHHmmss"];

    NSString *pdfFilePath=[NSString stringWithFormat:@"Documents/"];//,NSHomeDirectory(),[self cachePathForKey:forKey]];
  //  NSArray *retrivePath=[[NSString stringWithFormat:@"%@", document.fileURL] componentsSeparatedByString:@"/"];
    pdfFilePath = [pdfFilePath stringByAppendingFormat:@"%@",[RetrievePDFData cachePathForKey:[NSString stringWithFormat:@"http://173.15.239.213/PDF/PDFS/%@.PDF" ,[formater stringFromDate:date]]]];
    
    pdfFilePath =[NSHomeDirectory() stringByAppendingPathComponent:pdfFilePath];
    NSLog(@"Retrive path:%@===",pdfFilePath);
    NSData *data=[[NSData alloc]initWithContentsOfFile:pdfFilePath];
    return data;
}
+(UIImage*)cacheImage:(NSString*)forKey{
    UIImage* image;
    //UIImageView*imageView;
  //  NSString  *path = [[NSString alloc]initWithFormat:@"Documents/%@",[self cachePathForKey:forKey]];
   // path = [NSHomeDirectory() stringByAppendingPathComponent: path];
   // NSString*filePath =urlString;//[[NSBundle mainBundle] pathForResource:kPDFName ofType:@"pdf"];
   // CFStringRef path = CFStringCreateWithCString(NULL, [path UTF8String], kCFStringEncodingUTF8);
   // CFURLRef url = CFURLCreateWithFileSystemPath(NULL, path, kCFURLPOSIXPathStyle, 0);
   // CFRelease(path);
    
    NSString *pdfFilePath=[NSString stringWithFormat:@"Documents/%@",[self cachePathForKey:forKey]];
    pdfFilePath=[NSHomeDirectory() stringByAppendingPathComponent:pdfFilePath];
    CFURLRef pdfURL = (CFURLRef)CFBridgingRetain([[NSURL alloc] initFileURLWithPath:pdfFilePath]);
   // CGPDFDocumentRef pdf = CGPDFDocumentCreateWithURL((CFURLRef)pdfURL);
    
    
  //  CGPDFPageRef PDFPage = CGPDFDocumentGetPage(pdf, 1);
    //CFRelease(pdfURL);
    
    //CGPDFPageRetain(PDFPage);
    CGPDFDocumentRef pdfRef = CGPDFDocumentCreateWithURL(pdfURL);
    
    CFRelease(pdfURL);
    
    CGPDFPageRef page = CGPDFDocumentGetPage(pdfRef,1);
    CGPDFPageRetain(page);
    if (page) {
     
        CGRect pageSize = CGPDFPageGetBoxRect(page, kCGPDFMediaBox);//(595.276,807.874)
        CGBitmapInfo bmi = (kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipFirst);
        CGContextRef outContext =CGBitmapContextCreate(NULL,pageSize.size.width,pageSize.size.height,8,0,CGColorSpaceCreateDeviceRGB(),bmi);
        if (outContext)
        {
            CGContextDrawPDFPage(outContext, page);
            CGImageRef pdfImageRef = CGBitmapContextCreateImage(outContext);
            CGContextRelease(outContext);
            image = [UIImage imageWithCGImage:pdfImageRef];
            
            CGImageRelease(pdfImageRef);
            
            CGPDFDocumentRelease(pdfRef);
            pdfRef = NULL;
        }
    }
   // [UIImagePNGRepresentation(image) writeToFile:urlString atomically:NO];
    image = [RetrievePDFData Scaleimage:image TargetSize:CGSizeMake(94, 110)];
    [[SDImageCache sharedImageCache] storeImage:image  forKey:forKey toDisk:YES];
    return image;
}

+ (UIImage *)Scaleimage:(UIImage*)source  TargetSize:(CGSize)targetSize{
    UIImage *sourceImage=source;
    UIImage *newImage = nil;
    //NSLog(@"sourceImage.size:%f,%f",sourceImage.size.width,sourceImage.size.height);
    UIGraphicsBeginImageContext(CGSizeMake(targetSize.width, targetSize.height));
    CGRect thumbnailRect=CGRectMake(0, 0, targetSize.width,targetSize.height);
    [sourceImage drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    //NSLog(@"newimage:%f,%f",newImage.size.width,newImage.size.height);
    if(newImage == nil)
        NSLog(@"could not scale image");
    return newImage;
}

+(void)asyncDownload:(NSString*)url{
   // NSData *pdf;
    
    
    
    dispatch_queue_t queue;
    queue =  dispatch_queue_create("ocm", NULL);
    dispatch_async(queue, ^{
        if ([self DownloadFromWeb:url]!=nil) {
        dispatch_async(dispatch_get_main_queue(), ^{
        //    [self DownloadWithUrl:url];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"DownloadFinished" object:self];
        });
        }else{
            Database *dataProcess = [[Database alloc]init];
            [dataProcess deleteItem:url];

            NSLog(@"no file");
        }
    });
  //  return pdf;
}

+(NSData*)DownloadFromWeb:(NSString*)url{
    NSData * webData=[[NSData alloc]initWithContentsOfURL:[[NSURL alloc] initWithString:url]];
    if (webData) {
        return webData;
    }
    return nil;
}



+(NSData *)RetrievePDFData:(NSString *)PDFForKey{
  //  NSLog(@"Retrieve Data:%@",PDFForKey);
    NSString  *path = [[NSString alloc]initWithFormat:@"Documents/%@",[self cachePathForKey:PDFForKey]];
    path = [NSHomeDirectory() stringByAppendingPathComponent: path];
  //   NSLog(@"Retrieve :%@",path);
    NSData *pdfData =[[NSData alloc]initWithContentsOfFile:path];
   // [pdfData writeToFile:path atomically:NO];
   // NSFileManager *filemgr = [NSFileManager defaultManager];
    if (pdfData ) {
        NSLog(@"pdf Data not null!");
    }
    return pdfData;
}

+ (NSString *)cachePathForKey:(NSString *)key
{
    const char *str = [key UTF8String];
    unsigned char r[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), r);
    NSString *filename = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                          r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10], r[11], r[12], r[13], r[14], r[15]];
    
    return filename;
}
- (NSString *)cachePathForKey:(NSString *)key
{
    const char *str = [key UTF8String];
    unsigned char r[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), r);
    NSString *filename = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                          r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10], r[11], r[12], r[13], r[14], r[15]];
    
    return filename;
}
+(void)fileCopy:(ReaderDocument *)object:(NSDate *)date{
 //   NSArray *pathSong = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  //  NSDate *date=[[NSDate alloc]init];
    NSDateFormatter *formater=[[NSDateFormatter alloc]init];
    [formater setDateFormat:@"yyyyMMddHHmmss"];
    NSString *toPath = [[NSString alloc]initWithFormat:@"Documents/%@",[self cachePathForKey:[NSString stringWithFormat:@"http://173.15.239.213/PDF/PDFS/%@.PDF",[formater stringFromDate:date]]]];
    NSString *fromPath=@"Documents/Inbox/";
   // NSString *strdestination = [fromPath stringByAppendingPathComponent:@"sg.mp3"];
    NSArray *documentUrlArray=[[NSString stringWithFormat:@"%@",[object fileURL]] componentsSeparatedByString:@"/"];
    
    fromPath =[fromPath stringByAppendingFormat:@"%@",[documentUrlArray objectAtIndex:[documentUrlArray count]-1]];
    toPath = [NSHomeDirectory() stringByAppendingPathComponent: toPath];
    fromPath = [NSHomeDirectory() stringByAppendingPathComponent: fromPath];
    NSError *Error;

    NSLog(@"document from url:%@",fromPath);
     NSLog(@"document to url:%@",toPath);
    
    Database *database=[[Database alloc]init];
   [ database insertData:date :date :[NSString stringWithFormat:@"%@", object.pageCount]];

    dispatch_queue_t queue;
    queue =  dispatch_queue_create("ocm", NULL);
   
    if([[NSFileManager defaultManager]copyItemAtPath:fromPath toPath:toPath error:&Error]==NO){
        UIAlertView *Alert=[[UIAlertView alloc]initWithTitle:@"copy" message:[NSString stringWithFormat:@"%@",Error] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [Alert show];

    }
    else{
        //UIAlertView *Alert=[[UIAlertView alloc]initWithTitle:@"Not copy" message:[NSString stringWithFormat:@"%@",Error] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
       // [Alert show];
        //DELETE THE FILE AT THE LOCATION YOU'RE COPYING TO
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager removeItemAtPath:fromPath error:NULL];
        [[SDImageCache sharedImageCache] storeImage:[RetrievePDFData Scaleimage:[RetrievePDFData cacheImage:[NSString stringWithFormat:@"http://173.15.239.213/PDF/PDFS/%@.PDF",[formater stringFromDate:date]]] TargetSize:CGSizeMake(94, 117)]  forKey:[NSString stringWithFormat:@"http://173.15.239.213/PDF/PDFS/%@.PDF",[formater stringFromDate:date]] toDisk:YES];

    }
}
+(void)deleteFile:(NSString*)url{
    NSString *toPath = [[NSString alloc]initWithFormat:@"Documents/%@",[self cachePathForKey:url]];
    toPath = [NSHomeDirectory() stringByAppendingPathComponent: toPath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:toPath error:NULL];
    [[SDImageCache sharedImageCache] removeImageForKey:url];
}
@end
