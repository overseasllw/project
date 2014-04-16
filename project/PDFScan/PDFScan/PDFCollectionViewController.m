//
//  PDFCollectionViewController.m
//  PDFScan
//
//  Created by Ajit Randhawa on 11/12/12.
//  Copyright (c) 2012 Ajit Randhawa. All rights reserved.
//

#import "PDFCollectionViewController.h"
#import "PDFCollectionViewCell.h"
#import "TiledPDFView.h"
#import "TakePictureViewController.h"
#import "ReaderViewController.h"
#import "ReaderDocument.h"
#import "UIImageView+WebCache.h"
#import "Database.h"
#import "RetrievePDFData.h"
#import "KDGoalBar.h"
#import "PDFImageConverter.h"
#import "SVProgressHUD.h"
#import "CheckDataUpdate.h"
#import "Reachability.h"
#define REFRESH_HEADER_HEIGHT 52.0f
@interface PDFCollectionViewController (){
    ReaderViewController *readerViewController;
    NSMutableDictionary *pdfDictionary;
}
//@property (nonatomic,strong)UIProgressView *progressview;
@property (nonatomic,assign) PDFDownloadStatus status;
@end

@implementation PDFCollectionViewController{
    Database *dataFetch;
   // PDFDownloadStatus status;
}
@synthesize textLoading=textLoading,textPull=textPull,textRelease=textRelease;
@synthesize refreshArrow,refreshHeaderView,refreshSpinner,refreshLabel;
@synthesize existFile=existFile,pdfData=pdfData;
@synthesize openUrl=openUrl,documentOut=documentOut;
@synthesize retrive=retrive;
@synthesize progressView=progressView;
@synthesize originalData=originalData;
@synthesize pdfArray=pdfArray,selectIndex=selectIndex;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       [self setupStrings];
        textPull = @"Pull down to refresh...";
        textRelease = @"Release to refresh...";
        textLoading = @"Loading...";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    textPull = @"Pull down to refresh...";
    textRelease = @"Release to refresh...";
    textLoading = @"Loading...";
     dataFetch =[[Database alloc]init];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateInfo)
                                                 name:@"DownloadFinished"
                                               object:self];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateInfo2)
                                                 name:@"new"
                                               object:nil];
  //  [self addPullToRefreshHeader];
    
    UIRefreshControl *refreshControl = UIRefreshControl.alloc.init;
    [refreshControl addTarget:self action:@selector(refresh:)
             forControlEvents:UIControlEventValueChanged];
    [self.collectionView addSubview:refreshControl];
    
    [self.collectionView setUserInteractionEnabled:YES];
    pdfArray = [[NSMutableArray alloc]initWithArray: [dataFetch fetchData:@"SELECT * FROM (select * from pdfData where DeleteMark='NO') as im group by tag"]];
   // NSLog(@"Exist:%@",self.existFile);
}


-(void)updateInfo{
    [self.collectionView reloadData];
  //  NSLog(@"status:%d",retrive.status);
    pdfArray = [[NSMutableArray alloc]initWithArray: [dataFetch fetchData:@"SELECT * FROM (select * from pdfData where DeleteMark='NO') as im group by tag"]];
   // [self viewDidLoad];
}

-(void)updateInfo2{
    //NSLog(@"reload------");
     [self.collectionView reloadData];
     pdfArray = [[NSMutableArray alloc]initWithArray: [dataFetch fetchData:@"SELECT * FROM (select * from pdfData where DeleteMark='NO') as im group by tag"]];
    [self viewDidLoad];
   
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    if ([pdfArray count]%3 != 0) {
      
            return  ([pdfArray count] /3) + 1;
        
    }else{
        
       
            return [pdfArray count] / 3;
               
    }
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    int abc=0;
    if (section ==[pdfArray count]/3) {
        
        return abc = 3-((section+1)*3-[pdfArray count]);
    }else{
        
        return abc = 3;
    }

}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PDFCollectionViewCell *cell =[collectionView dequeueReusableCellWithReuseIdentifier:@"pdfView" forIndexPath:indexPath];
    if (cell==NULL) {
        cell = [[PDFCollectionViewCell alloc]init];
    }

    pdfDictionary =[pdfArray objectAtIndex:(indexPath.section*3+indexPath.row)];
    cell.pdfUrl=[pdfDictionary objectForKey:@"filepath"];
   
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    UIImageView *newView;// = [[UIImageView alloc]init];
    UIImage *cachedImage = [manager imageWithURL:[NSURL URLWithString:[pdfDictionary objectForKey:@"filepath"]] ];
      NSString *path=[[NSString alloc]initWithFormat:@"Documents/%@",[RetrievePDFData cachePathForKey:[pdfDictionary objectForKey:@"filepath"]]];
    path = [NSHomeDirectory() stringByAppendingPathComponent:path];
    
    
    if (cachedImage) {
      //  NSLog(@"Set image!!!!");
        cell.downLoading=YES;
        newView=[[UIImageView alloc]initWithImage:[RetrievePDFData Scaleimage:cachedImage TargetSize:CGSizeMake(77, 106)]];
        [cell.pdfView addSubview:newView];
        [newView clipsToBounds];
        newView.contentMode = UIImageResizingModeStretch;
        [newView sizeToFit];
        
    }else{
        // [RetrievePDFData asyncDownload:[pdfDictionary objectForKey:@"filepath"]];
        //cell.pdfView =nil;
        cell.downLoading=NO;
        newView = [[UIImageView alloc]initWithImage:[RetrievePDFData Scaleimage:[UIImage imageNamed:@"pdfplaceholder.png"] TargetSize:CGSizeMake(77, 106)]];
        [newView clipsToBounds];
        newView.contentMode = UIImageResizingModeStretch;
        [newView sizeToFit];
        
        
        [cell.pdfView addSubview:newView];
        ReaderDocument *document =[[ReaderDocument alloc]initWithFilePath:path password:nil];
        if (document) {
            [self setPDFPage:cell.pdfView :path];
            cell.downLoading=YES;
        }
        //[RetrievePDFData DownloadWithUrl:[pdfDictionary objectForKey:@"filepath"]];
    }
    if (cell.downLoading&&progressView) {
        [progressView removeFromSuperview];
    }
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    PDFCollectionViewCell *cellView= (PDFCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
 //   NSLog(@"pdf url%@",cellView.pdfUrl);
    if ([self.existFile isEqualToString:@"exist"]) {

        [SVProgressHUD showWithStatus:@"Merging" maskType:SVProgressHUDMaskTypeBlack];
       // [SVProgressHUD transitionFromView:<#(UIView *)#> toView:<#(UIView *)#> duration:<#(NSTimeInterval)#> options:<#(UIViewAnimationOptions)#> completion:<#^(BOOL finished)completion#>]
        self.originalData=[RetrievePDFData RetrievePDFData:cellView.pdfUrl];
        [PDFImageConverter MergeTwoPDF:self.pdfData :self.originalData:cellView.pdfUrl];
         selectIndex = indexPath;
        [SVProgressHUD dismiss];
        [self performSegueWithIdentifier:@"pdfView" sender:self];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadFlag" object:nil];
    }else{
    
    if (cellView.downLoading==NO)
    {
      //  progressView =[[KDGoalBar alloc]initWithFrame:CGRectMake(20, 30, 50, 50)];
        retrive=[[RetrievePDFData alloc]init];
        progressView= [retrive DownloadWithUrl:cellView.pdfUrl];
        
      //  NSLog(@"download status: %d --%d",retrive.status,PDFDownloadStatusIdle);
        
        [cellView.pdfView addSubview:progressView];
        [progressView bringSubviewToFront:cellView.pdfView];
    }else{
    selectIndex = indexPath;
        NSLog(@"=======%@========",cellView.pdfUrl);
    [self performSegueWithIdentifier:@"pdfView" sender:self];
    }
    }
    self.existFile=@"";
}

- (void)setPDFPage:(UIView *)cellView:(NSString *)path
{
    NSString *pdfFilePath=[NSString stringWithFormat:@"%@/Documents/%@",NSHomeDirectory(),path];
    CFURLRef pdfURL = (CFURLRef)CFBridgingRetain([[NSURL alloc] initFileURLWithPath:pdfFilePath]);
    pdf = CGPDFDocumentCreateWithURL((CFURLRef)pdfURL);
    
       
    CGPDFPageRef PDFPage = CGPDFDocumentGetPage(pdf, 1);
    CFRelease(pdfURL);
    
    CGPDFPageRetain(PDFPage);

   // Determine the size of the PDF page.
    CGRect pageRect = CGPDFPageGetBoxRect(PDFPage, kCGPDFMediaBox);
  //  NSLog(@"%f--%f ",cellView.frame.size.width,cellView.frame.size.height);
    CGFloat _PDFScaleX = cellView.frame.size.width/pageRect.size.width;
    CGFloat _PDFScaleY = cellView.frame.size.height/pageRect.size.height;
    CGSize scaleSize=CGSizeMake(_PDFScaleX, _PDFScaleY);
    NSLog(@"%f---%f",pageRect.size.width,pageRect.size.height);
    pageRect.size = CGSizeMake(77, 106);
    
   
    TiledPDFView *tiledPDFView = [[TiledPDFView alloc] initWithFrame:pageRect scale:scaleSize];
    [tiledPDFView setPage:PDFPage];
    
    [cellView addSubview:tiledPDFView];
    
   // self.tiledPDFView = tiledPDFView;
}



-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"take"]) {
        
        TakePictureViewController *takePic = [segue destinationViewController];
        takePic.addNewPic = @"isNotAddNewPic";

    } else if([[segue identifier]isEqualToString:@"pdfView"]){
       NSString *phrase = nil;
        PDFCollectionViewCell *cellView= (PDFCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:selectIndex];
             
        NSString *filePath = [RetrievePDFData cachePathForKey:cellView.pdfUrl];
        
        NSString *pdfFilePath=[NSString stringWithFormat:@"%@/Documents/%@",NSHomeDirectory(),filePath];
    
        assert(pdfFilePath != nil);
     
        
        ReaderDocument *document = [ReaderDocument withDocumentFilePath:pdfFilePath password:phrase];
        
        if (document != nil) // Must have a valid ReaderDocument object in order to proceed
        {
            
            if ([self.existFile isEqualToString:@"exist"]) {
                [CheckDataUpdate changePageNumberAfterMerge:[document.pageCount intValue] :cellView.pdfUrl];
            }
            
            readerViewController = [[segue destinationViewController] initWithReaderDocument:document];
           
            
            readerViewController.delegate = self; // Set the ReaderViewController delegate to self
            
          //  readerViewController.saveOrNot=@"YES";
            readerViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            readerViewController.modalPresentationStyle = UIModalPresentationFullScreen;
            
        }
    }else if([[segue identifier] isEqualToString:@"PDFDirectly"]){
        
        readerViewController = [[segue destinationViewController] initWithReaderDocument:documentOut:@"YES"];
        readerViewController.saveOrNot =@"YES";
    //    NSLog(@"segue");
        readerViewController.delegate = self; // Set the ReaderViewController delegate to self
        readerViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        readerViewController.modalPresentationStyle = UIModalPresentationFullScreen;

    }
}


-(void)handleImportURL:(ReaderDocument *)document{
   // self.openUrl = [NSString stringWithFormat:@"%@", url];
   //ReaderViewController *reader = [[self.storyboard instantiateViewControllerWithIdentifier:@"readerView"]initWithReaderDocument:document] ;
    self.documentOut = document;
    
//  [[self navigationController] presentViewController:reader animated:YES completion:nil];
   
}

-(void)viewDidAppear:(BOOL)animated{
    if (documentOut) {
        [self performSegueWithIdentifier:@"PDFDirectly" sender:self];
        documentOut=nil;
    }
}
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateInfo)
                                                 name:@"DownloadFinished"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateInfo2)
                                                 name:@"new"
                                               object:nil];
   // [self addPullToRefreshHeader];
  //  UIRefreshControl *refreshControl = UIRefreshControl.alloc.init;
    //[refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
   // [self.collectionView addSubview:refreshControl];
     pdfArray = [[NSMutableArray alloc]initWithArray: [dataFetch fetchData:@"SELECT * FROM (select * from pdfData where DeleteMark='NO') as im group by tag"]];
}

-(IBAction)takePic:(id)sender{
    [self performSegueWithIdentifier:@"take" sender:self];
}

- (void)didReceiveMemoryWarning
{
#ifdef DEBUG
	NSLog(@"%s", __FUNCTION__);
#endif
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ReaderViewControllerDelegate methods

- (void)dismissReaderViewController:(ReaderViewController *)viewController
{
#if (DEMO_VIEW_CONTROLLER_PUSH == TRUE)
    
	[self.navigationController popViewControllerAnimated:YES];
    
#else // dismiss the modal view controller
    
	[self dismissViewControllerAnimated:YES completion:nil];
    
#endif // DEMO_VIEW_CONTROLLER_PUSH
}


-(UIImage*)cacheImage:(NSString*)urlString{
    UIImage* image;  
    NSString*filePath =urlString;//[[NSBundle mainBundle] pathForResource:kPDFName ofType:@"pdf"];
    CFStringRef path = CFStringCreateWithCString(NULL, [filePath UTF8String], kCFStringEncodingUTF8);
    CFURLRef url = CFURLCreateWithFileSystemPath(NULL, path, kCFURLPOSIXPathStyle, 0);
    CFRelease(path);
    CGPDFDocumentRef pdfRef = CGPDFDocumentCreateWithURL(url);

    CFRelease(url);
    
    CGPDFPageRef page = CGPDFDocumentGetPage(pdfRef,1);
    if (page) {
        CGRect pageSize = CGPDFPageGetBoxRect(page, kCGPDFMediaBox);//(595.276,807.874)
       
        CGContextRef outContext =CGBitmapContextCreate(NULL,pageSize.size.width,pageSize.size.height,8,0,CGColorSpaceCreateDeviceRGB(),kCGImageAlphaPremultipliedLast);
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
    
    return image;
}


- (void)setupStrings{
    textPull = @"Pull down to refresh...";
    textRelease = @"Release to refresh...";
    textLoading = @"Loading...";
}

- (void)addPullToRefreshHeader {
    refreshHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0 - REFRESH_HEADER_HEIGHT, 320, REFRESH_HEADER_HEIGHT)];
    refreshHeaderView.backgroundColor = [UIColor clearColor];
    
    refreshLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, REFRESH_HEADER_HEIGHT)];
    refreshLabel.backgroundColor = [UIColor whiteColor];
    refreshLabel.font = [UIFont boldSystemFontOfSize:12.0];
    refreshLabel.textAlignment = NSTextAlignmentCenter;
    
    refreshArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow.png"]];
    refreshArrow.frame = CGRectMake(floorf((REFRESH_HEADER_HEIGHT - 27) / 2),
                                    (floorf(REFRESH_HEADER_HEIGHT - 44) / 2),
                                    27, 44);
    
    refreshSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    refreshSpinner.frame = CGRectMake(floorf(floorf(REFRESH_HEADER_HEIGHT - 20) / 2), floorf((REFRESH_HEADER_HEIGHT - 20) / 2), 20, 20);
    refreshSpinner.hidesWhenStopped = YES;
    
    [refreshHeaderView addSubview:refreshLabel];
    [refreshHeaderView addSubview:refreshArrow];
    [refreshHeaderView addSubview:refreshSpinner];
    [self.collectionView addSubview:refreshHeaderView];
}

//-(void)co
-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
   // NSLog(@"abc");
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (isLoading) return;
    isDragging = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (isLoading) {
        // Update the content inset, good for section headers
        if (scrollView.contentOffset.y > 0)
            self.collectionView.contentInset = UIEdgeInsetsZero;
        else if (scrollView.contentOffset.y >= -REFRESH_HEADER_HEIGHT)
            self.collectionView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (isDragging && scrollView.contentOffset.y < 0) {
        // Update the arrow direction and label
        [UIView beginAnimations:nil context:NULL];
        if (scrollView.contentOffset.y < -REFRESH_HEADER_HEIGHT) {
            // User is scrolling above the header
            refreshLabel.text = self.textRelease;
            [refreshArrow layer].transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
        } else { // User is scrolling somewhere within the header
            refreshLabel.text = self.textPull;
            [refreshArrow layer].transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
        }
        [UIView commitAnimations];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (isLoading) return;
    isDragging = NO;
    if (scrollView.contentOffset.y <= -REFRESH_HEADER_HEIGHT) {
        // Released above the header
        [self startLoading];
    }
}

- (void)startLoading {
    isLoading = YES;
    
    // Show the header
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    self.collectionView.contentInset = UIEdgeInsetsMake(REFRESH_HEADER_HEIGHT, 0, 0, 0);
    refreshLabel.text = self.textLoading;
    refreshArrow.hidden = YES;
    [refreshSpinner startAnimating];
    [UIView commitAnimations];
    
    // Refresh action!
    [self refresh];
}

- (void)stopLoading {
    isLoading = NO;
    
    // Hide the header
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDidStopSelector:@selector(stopLoadingComplete:finished:context:)];
    self.collectionView.contentInset = UIEdgeInsetsZero;
    UIEdgeInsets tableContentInset = self.collectionView.contentInset;
    tableContentInset.top = 0.0;
    self.collectionView.contentInset = tableContentInset;
    [refreshArrow layer].transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
    [UIView commitAnimations];
}

- (void)stopLoadingComplete:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    // Reset the header
    refreshLabel.text = self.textPull;
    refreshArrow.hidden = NO;
    [refreshSpinner stopAnimating];
}
-(void)refresh{
    Database *datab=[[Database alloc]init];
    [datab databaseConnection];
    CheckDataUpdate *check=[[CheckDataUpdate alloc]init];
    Reachability *wifiReach = [Reachability reachabilityForInternetConnection];
    [wifiReach startNotifier];

    [check checkUpload:wifiReach];
   
    if ([wifiReach currentReachabilityStatus]!=NotReachable) {
        //  NSLog(@"~~~~~~~~~~~~~~~1");
        if ([[datab importDistanceDatabase:@"http://173.15.239.213/PDF/getAllData.php"] count]>0&&[datab checkImportOrNot]) {
            [datab createTableData];
            //    NSLog(@"~~~~~~~~~~~~~~~2");
        }
        Database *datarefresh=[[Database alloc]init];
        [check checkUnsuccessfulUploadPic];
        // NSLog(@"~~~~~~~~~~~~~~~3");
        [datarefresh checkDeleteItem];
        //  NSLog(@"~~~~~~~~~~~~~~~4");
        [datarefresh updateImageInof];
    }
}

- (void)refresh:(UIRefreshControl *)refresh{//
 refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Refreshing data..."];
    [self performSelector:@selector(refresh) withObject:nil afterDelay:2];
    [self.collectionView reloadData];
    [self viewDidLoad];
    [refresh endRefreshing];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
[formatter setDateFormat:@"MMM d, h:mm a"];
         NSString *lastUpdated = [NSString stringWithFormat:@"Last updated on %@",
        [formatter stringFromDate:[NSDate date]]];
         refresh.attributedTitle = [[NSAttributedString alloc] initWithString:lastUpdated];


   
   // [self performSelector:@selector(stopLoading) withObject:nil afterDelay:1.0];
}




@end
