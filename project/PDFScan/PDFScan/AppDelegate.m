//
//  AppDelegate.m
//  PDFScan
//
//  Created by Ajit Randhawa on 11/12/12.
//  Copyright (c) 2012 Ajit Randhawa. All rights reserved.
//

#import "AppDelegate.h"
#import "ReaderViewController.h"
#import "Reachability.h"
#import "Database.h"
#import "FMDatabase.h"
#import "RetrievePDFData.h"
#import "PDFCollectionViewController.h"
#import "ReaderDocument.h"
#import "ReaderViewController.h"
#import "UIImageView+WebCache.h"
#import "SDImageCache.h"
#import "SDWebImageManager.h"
#import "UploadPDF.h"
#import "CheckDataUpdate.h"
@implementation AppDelegate{
 
}
@synthesize rootNavigationController;
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  //  [self updatePage];
       Database *datab=[[Database alloc]init];
    self.window =[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [datab databaseConnection];
    UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
  //  NSLog(@"didFinishedLaunch!");
    // [RetrievePDFData DownloadWithUrl:@"http://173.15.239.213/PDF/PDFS/20121119001524D49AB58A-9793-4B95-9729-9086DABE07EA.PDF"];
   // [RetrievePDFData RetrievePDFData:@"http://173.15.239.213/PDF/PDFS/20121119001524D49AB58A-9793-4B95-9729-9086DABE07EA.PDF"];
    
    wifiReach = [Reachability reachabilityForInternetConnection];
    [wifiReach startNotifier];
    if ([wifiReach currentReachabilityStatus]!=NotReachable) {
        if ([[datab importDistanceDatabase:@"http://173.15.239.213/PDF/getAllData.php"] count]>0&&[datab checkImportOrNot]) {
            [datab createTableData];
        }
        [CheckDataUpdate CheckPageNumberUpdate];

     //   [self checkDeviceUserExist:appIdString];
        [self checkUpload:wifiReach];
        [self checkUnsuccessfulUploadPic];
    }

  //  ReaderDocument *document = [ReaderDocument withDocumentFilePath:pdfFilePath password:nil];
   // PDFCollectionViewController *pdfViewControllerRoot = [[PDFCollectionViewController alloc]initWithCollectionViewLayout:[[UICollectionViewLayout alloc]init]];
    
    self.rootNavigationController= [storyBoard instantiateViewControllerWithIdentifier:@"navigationController"];
    self.window.rootViewController = self.rootNavigationController;
    [self.window makeKeyAndVisible];
    return YES;
}
-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
  // NSLog(@"openUrl:%@",url);
    
       return  [self handleOpenURL:url];
}

- (BOOL)handleOpenURL:(NSURL *)launchPDFURL {
      if ([launchPDFURL isFileURL] && [[NSFileManager defaultManager] fileExistsAtPath:[launchPDFURL path]]) {
          NSArray *pathArray=[[NSString stringWithFormat:@"%@", launchPDFURL] componentsSeparatedByString:@"/"];
          
          NSString *path=[[NSString alloc]initWithFormat:@"Documents/Inbox/%@",[pathArray objectAtIndex:[pathArray count]-1]];
          path = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",path]];

          NSLog(@"Path: %@",path);
          
              ReaderDocument *document = [[ReaderDocument alloc ]initWithFilePath:path password:nil];


          //===============
           UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
            UINavigationController *pdfController = (UINavigationController *)[storyBoard  instantiateViewControllerWithIdentifier:@"navigationController"];//collectionView
          self.window.rootViewController =pdfController;
          ReaderViewController *con=[[storyBoard instantiateViewControllerWithIdentifier:@"readerView"]initWithReaderDocument:document];
          if (con) {
                     }

          PDFCollectionViewController *reader=[pdfController.viewControllers objectAtIndex:0];
          [reader handleImportURL:document];
          return YES;
    }
    return NO;
 }


-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
   // PDFCollectionViewController *pdfView=(PDFCollectionViewController *)application.nextResponder ;
    //[pdfView handleImportURL:url];
 //   NSLog(@"handle :%@+++%@",url,@"dddd");
    return [self handleOpenURL:url];
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    Database *datab=[[Database alloc]init];
    [datab databaseConnection];

    wifiReach = [Reachability reachabilityForInternetConnection];
    [wifiReach startNotifier];

    [self checkUpload:wifiReach];

    if ([wifiReach currentReachabilityStatus]!=NotReachable) {
      //  NSLog(@"~~~~~~~~~~~~~~~1");
        if ([[datab importDistanceDatabase:@"http://173.15.239.213/PDF/getAllData.php"] count]>0&&[datab checkImportOrNot]) {
            [datab createTableData];
        //    NSLog(@"~~~~~~~~~~~~~~~2");
        }
        Database *datarefresh=[[Database alloc]init];
        [self checkUnsuccessfulUploadPic];
       // NSLog(@"~~~~~~~~~~~~~~~3");
        [datarefresh checkDeleteItem];
      //  NSLog(@"~~~~~~~~~~~~~~~4");
        [datarefresh updateImageInof];
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
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



- (void) reachabilityChanged: (NSNotification* )note
{
	Reachability* curReach = [note object];
	NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    [self checkUpload:curReach];
    NSLog(@"network status change!!");
}

-(void)updatePage{
    //   NSString *pdfPath1 = [documentsDirectory stringByAppendingPathComponent:[RetrievePDFData cachePathForKey:PDF1]];
    // NSString *pdfPath2 = [documentsDirectory stringByAppendingPathComponent:[RetrievePDFData cachePathForKey:PDF2]];
  //  Database *da=[[Database alloc]init];
    FMDatabase *db =[FMDatabase databaseWithPath:[[[Database alloc]init] getPath]];
    if(![db open]){
        NSLog(@"no database available!");
    }
    FMResultSet *result=[db executeQuery:@"select * from pdfData"];
    while ([result next]) {
    NSString *pdfPathOutput = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@",[RetrievePDFData cachePathForKey:[result stringForColumn:@"filepath"]]]];
        ReaderDocument *docu=[[ReaderDocument alloc]initWithFilePath:pdfPathOutput password:nil];
      if ( [db executeUpdate:@"update pdfData set numberOfPage=? where filepath=?",docu.pageCount,[result stringForColumn:@"filepath"]])
          NSLog(@"%@-----%@",[result stringForColumn:@"filepath"],docu.pageCount);
 }
}

@end
