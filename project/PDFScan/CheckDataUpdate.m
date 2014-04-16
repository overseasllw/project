//
//  CheckDataUpdate.m
//  PDFScan
//
//  Created by Liwei Lin on 12/1/12.
//  Copyright (c) 2012 Ajit Randhawa. All rights reserved.
//

#import "CheckDataUpdate.h"
#import "Database.h"
#import "FMDatabase.h"
//#import "FMResultSet.h"
#import "UploadPDF.h"
#import "RetrievePDFData.h"
#import "ReaderDocument.h"
#import "Reachability.h"
#import "UIImageView+WebCache.h"
#import "SDImageCache.h"
#import "SDWebImageManager.h"

#define imageUrl @"http://173.15.239.213/PDF/getAllData.php"
#define updateUrl @"http://173.15.239.213/PDF/updatePage.php"
#define deleteUrl @"http://173.15.239.213/PDF/php3.php"
@implementation CheckDataUpdate{
    Database *database;
}
@synthesize databse;
+(void)CheckPageNumberUpdate{
   Database *databse = [[Database alloc]init];
    NSMutableArray *pdfArray=[databse importDistanceDatabase:imageUrl];
  //  NSLog(@"array %@",pdfArray);
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *dbPath = [documentDirectory stringByAppendingPathComponent:@"iOweiPay.sqlite"];
    NSMutableDictionary *pdfDataDic=[[NSMutableDictionary alloc]init];
    FMDatabase *db =[FMDatabase databaseWithPath:dbPath];
  //  NSLog(@"%@",dbPath);
    if (![db open]) {
        NSLog(@"Database can not open!");
    }else{
    
    }
    // [db executeUpdate:@"updata pdfData set filepath=? where filepath=?",@"http://173.15.239.213/PDF/PDFS/20121126163658.PDF",@"http://173.15.239.213/PDF/PDFS/20121126163658CFBC0044-D088-4EF2-9EF3-919BFEC6BDC6.PDF"];
   // FMResultSet *result;//=[db executeQuery:@"select * from pdfData"];
    for (int i=0; i<[pdfArray count]; i++) {
        pdfDataDic=[pdfArray objectAtIndex:i];
       FMResultSet *result=[db executeQuery:@"select * from pdfData where filepath=?",[pdfDataDic objectForKey:@"filepath"]];
        int distancePagenumber=[[pdfDataDic objectForKey:@"numberOfPage"] intValue];
        while ([result next]) {
            int localPagenumber=[[result stringForColumn:@"numberOfPage"] intValue];
            if( localPagenumber> distancePagenumber){
                NSLog(@"There exist PDF have been modified,need to upload!");
                NSMutableURLRequest *updatePDFInfo = [[NSMutableURLRequest alloc]initWithURL:[[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@?filepath=%@",deleteUrl,[pdfDataDic objectForKey:@"filepath"]]]];
                NSURLConnection *connection2 = [[NSURLConnection alloc] initWithRequest:updatePDFInfo delegate:self startImmediately:NO];
                [connection2 start];
                dispatch_queue_t queue;
               
                queue =  dispatch_queue_create("o12cm", NULL);
                dispatch_async(queue, ^{
                NSMutableURLRequest *updatePDFInfo = [[NSMutableURLRequest alloc]initWithURL:[[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@?filepath=%@&pageNumber=%d",updateUrl,[pdfDataDic objectForKey:@"filepath"],localPagenumber]]];
                NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:updatePDFInfo delegate:self startImmediately:NO];
                [UploadPDF uploadPic:[RetrievePDFData RetrievePDFData:[pdfDataDic objectForKey:@"filepath"]]:[pdfDataDic objectForKey:@"filename"]];
// NSString *pdfPathOutput = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@",[RetrievePDFData cachePathForKey:[pdfDataDic objectForKey:@"filepath"]]]];
          //          ReaderDocument *docu = [[ReaderDocument alloc]initWithFilePath:pdfPathOutput password:nil];
  //
   //                 NSLog(@"------%@------------%f",[pdfDataDic objectForKey:@"filename"],[docu.fileSize floatValue]/1024/1024);
                    dispatch_async(dispatch_get_main_queue(), ^{
                    NSLog(@"Upload Finished!!");
                   [connection start];
                    });
                });


                //     NSData *returnData = [NSURLConnection sendSynchronousRequest:updatePDFInfo returningResponse:nil error:nil];
             //   NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
             //   NSLog(@"-------%@",returnString);
            }else if (localPagenumber < distancePagenumber){
                 NSLog(@"There exist PDF have been modified! need download new PDF");
                [db executeUpdate:@"update pdfData set numberOfPage=? where filepath=?",[NSString stringWithFormat:@"%d", distancePagenumber],[pdfDataDic objectForKey:@"filepath"]];

                [RetrievePDFData deleteFile:[pdfDataDic objectForKey:@"filepath"]];
            }
        }
        
    }

   
}

+(void) changePageNumberAfterMerge:(NSInteger)pageNum:(NSString *)url{
     FMDatabase *db =[FMDatabase databaseWithPath:[[[Database alloc]init] getPath]];
    if (![db open]) {
        NSLog(@"Database %@ not open",db);
    }
    NSLog(@"update pdfData set numberOfPage=%@ where filepath=%@",[NSString stringWithFormat:@"%d",pageNum],url);
    if ([db executeUpdate:@"update pdfData set numberOfPage=? where filepath=?",[NSString stringWithFormat:@"%d",pageNum],url]) {
        NSLog(@"Page No. has been updated.");
    }
    
     Reachability *networkStatus= [Reachability reachabilityForLocalWiFi];
    [networkStatus startNotifier];
    if ([networkStatus currentReachabilityStatus]!=NotReachable ) {
        NSMutableURLRequest *updatePDFInfo = [[NSMutableURLRequest alloc]initWithURL:[[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@?filepath=%@&pageNumber=%d",updateUrl,url,pageNum]]];
        NSURLConnection *connection2 = [[NSURLConnection alloc] initWithRequest:updatePDFInfo delegate:self startImmediately:NO];
       // [connection2 start];

       
          //  [self uploadImageInfo:filenametag :@"imagesupload"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"new" object:self];
            dispatch_queue_t queue;
            queue =  dispatch_queue_create("ocm", NULL);
            dispatch_async(queue, ^{
                /*  [self uploadPic:UIImagePNGRepresentation([[UIImage alloc] imageWithImage:self.image scaledToSizeWithSameAspectRatio:CGSizeMake(120, 160) ]) :filenametag:YES];*/
                NSArray *filenamewithExtension=[url componentsSeparatedByString:@"/"];
                NSArray *filename=[[filenamewithExtension objectAtIndex:[filenamewithExtension count]-1] componentsSeparatedByString:@"."];
                NSLog(@"-------%@----------",[filename objectAtIndex:0]);
                [UploadPDF uploadPic:[RetrievePDFData RetrievePDFData:url]:[filename objectAtIndex:0]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [connection2 start];
                    //  [[NSNotificationCenter defaultCenter] postNotificationName:@"UPLOAD_DOWN"  object:self];
                });
            });
    }
}
+(void)uploadPDFData:(NSData*)data:(NSString *)filename:(NSString*)filepath{
    
}


-(void)checkUnsuccessfulUploadPic{
    NSLog(@"To Check unsuccessful upload PDF!");
    NSURL *importUrl = [NSURL URLWithString:@"http://173.15.239.213/PDF/getAllUnsuccessful.php"];
    NSData *importData = [NSData dataWithContentsOfURL:importUrl];
    NSError *error;
    NSMutableArray *infoArray = [NSJSONSerialization JSONObjectWithData:importData options:kNilOptions error:&error];
    NSMutableDictionary *unuploadPic;
    if ([infoArray count]>0) {
        for (int i=0; i<[infoArray count]; i++) {
            unuploadPic =[infoArray objectAtIndex:i];
            UIImage *image = [[SDImageCache sharedImageCache] imageFromKey:[unuploadPic objectForKey:@"filepath"]];
            if (image) {
                NSLog(@"Exist unsuccessful uploaded PDF");
                // NSLog(@"check unsuccess %@",[unuploadPic objectForKey:@"fullpath"]);
                dispatch_queue_t queue;
                // dispatch_queue_t queue2;
                queue =  dispatch_queue_create("ocm51", NULL);
                NSString *unuploadpicURL=[NSString stringWithFormat:@"%@",[unuploadPic objectForKey:@"filepath"]];
                dispatch_async(queue, ^{
                    //[self uploadPic:UIImagePNGRepresentation(image):[unuploadPic objectForKey:@"filename"]:NO];
                    //[self uploadPic:UIImagePNGRepresentation(image):[unuploadPic objectForKey:@"filename"]:YES];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSURL *moveImageURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://173.15.239.213/PDF/updateAllUnsuccessful.php?fullpath=%@", unuploadpicURL]];
                        NSLog(@"unuploadURL %@",unuploadpicURL);
                        NSMutableURLRequest *updateimageinfo = [[NSMutableURLRequest alloc]initWithURL:moveImageURL];
                        NSData *returnData = [NSURLConnection sendSynchronousRequest:updateimageinfo returningResponse:nil error:nil];
                        NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
                        
                        NSLog(@"=======%@=======",returnString);
                    });
                });
            }
        }
    }else{
        NSLog(@"no unsuccessful uploaded PDF!");
    }
    
}


-(void)checkUpload:(Reachability*)curReach{
    NSLog(@"check if exist unupload pic");
    if ([curReach currentReachabilityStatus]!=NotReachable) {
        FMDatabase *upload=[FMDatabase databaseWithPath:[[[Database alloc]init] getPath]];
        if(![upload open]){
            NSLog(@"database not available!");
        }
        FMResultSet *resultSet =[upload executeQuery:@"select * from pdfData where uploaded ='NO'"];
        while ([resultSet next]) {
            NSLog(@"--------unupload PDF File!!!--------");
            UIImage *image = [[SDImageCache sharedImageCache] imageFromKey:[resultSet stringForColumn:@"filepath"] fromDisk:YES];
            if (image) {
                NSLog(@"unupload image exist");
                NSString *filename=[resultSet stringForColumn:@"filename"];
                NSString *subTitle=[resultSet stringForColumn:@"subTitle"];
                NSString *fullpath=[resultSet stringForColumn:@"filepath"];
                NSString *tag=[resultSet stringForColumn:@"tag"];
                NSString *picOrder=[resultSet stringForColumn:@"numberOfPage"];
                NSString *checkUpload =[NSString stringWithFormat:@"%@?filename=%@&subTitle=%@&fullpath=%@&tag=%@&page=%@",@"http://173.15.239.213/PDF/checkUpload.php",filename,subTitle,fullpath,tag,picOrder];
                dispatch_queue_t queue;
                queue =  dispatch_queue_create("ocm15", NULL);
                dispatch_async(queue, ^{
                    //  [self uploadPic:UIImagePNGRepresentation(image) :filename:NO];
                    //   [self uploadPic:UIImagePNGRepresentation(image) :filename:YES];
                    [UploadPDF uploadPic:[RetrievePDFData RetrievePDFData:fullpath]:filename];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self updateDistanceDatabase:checkUpload :fullpath];
                    });
                });
                
            }else{
                NSLog(@"an unupload PDF file information found but file not exist!");
                
                [upload executeUpdate:@"delete from pdfData where filepath=? and uploaded=NO",[resultSet stringForColumn:@"filepath"]];
            }
            
            
        }
        
        [upload close];
    }
    
}

-(void)updateDistanceDatabase:(NSString*)urlString:(NSString*)filepath{
    
    NSURL *moveImageURL = [NSURL URLWithString:urlString];
    NSMutableURLRequest *updateimageinfo = [[NSMutableURLRequest alloc]initWithURL:moveImageURL];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:updateimageinfo delegate:self startImmediately:NO];
    [connection start];
    FMDatabase *db =[FMDatabase databaseWithPath:[[[Database alloc]init] getPath]];
    if(![db open]){
        NSLog(@"no database available!");
    }
    [db executeUpdate:@"update pdfData set uploaded='YES' where filepath=?",filepath];
    [db close];
}


@end
