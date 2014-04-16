//
//  PDFCollectionViewController.h
//  PDFScan
//
//  Created by Ajit Randhawa on 11/12/12.
//  Copyright (c) 2012 Ajit Randhawa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReaderViewController.h"
#import "KDGoalBar.h"
#import "RetrievePDFData.h"
@class Reachability;
@interface PDFCollectionViewController : UICollectionViewController< UICollectionViewDataSource,UIScrollViewDelegate, UICollectionViewDelegate,ReaderViewControllerDelegate,UINavigationControllerDelegate,UINavigationBarDelegate>{
    CGPDFDocumentRef pdf;
    NSMutableArray *pdfArray;
    NSIndexPath *selectIndex;
    KDGoalBar *progressView;
    RetrievePDFData *retrive;
    NSString *openUrl;
    ReaderDocument *documentOut;
    NSString *existFile;
    NSData *pdfData;
    NSData *originalData;
    
    
    
    UIView *refreshHeaderView;
    UILabel *refreshLabel;
    UIImageView *refreshArrow;
    UIActivityIndicatorView *refreshSpinner;
    BOOL isDragging;
    BOOL isLoading;
    NSString *textPull;
    NSString *textRelease;
    NSString *textLoading;

}
@property (nonatomic,retain) NSMutableArray *pdfArray;
@property (nonatomic,retain) NSIndexPath *selectIndex;
@property (nonatomic,retain) RetrievePDFData *retrive;
@property (nonatomic,retain) NSString *openUrl;
@property (nonatomic,retain) NSString *existFile;
@property (nonatomic,retain) NSData *pdfData;
@property (nonatomic,retain)  NSData *originalData;
@property   KDGoalBar *progressView;
@property (nonatomic,retain) ReaderDocument *documentOut;
-(IBAction)takePic:(id)sender;
-(void)handleImportURL:(ReaderDocument *)document;

@property (nonatomic, retain) UIView *refreshHeaderView;
@property (nonatomic, retain) UILabel *refreshLabel;
@property (nonatomic, retain) UIImageView *refreshArrow;
@property (nonatomic, retain) UIActivityIndicatorView *refreshSpinner;
@property (nonatomic, copy) NSString *textPull;
@property (nonatomic, copy) NSString *textRelease;
@property (nonatomic, copy) NSString *textLoading;

- (void)setupStrings;
- (void)addPullToRefreshHeader;
- (void)startLoading;
- (void)stopLoading;
- (void)refresh;



@end
