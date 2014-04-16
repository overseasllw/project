//
//  PDFCollectionViewCell.h
//  PDFScan
//
//  Created by Ajit Randhawa on 11/12/12.
//  Copyright (c) 2012 Ajit Randhawa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KDGoalBar.h"
@interface PDFCollectionViewCell : UICollectionViewCell{
    IBOutlet UIView *pdfView;
    NSString *pdfUrl;
   
    

}

@property (nonatomic,assign,getter = isDownloading) BOOL downLoading;
@property IBOutlet UIView  *pdfView;
@property (nonatomic,retain) NSString *pdfUrl;


@property (nonatomic, strong) NSString* loadingImageURLString;

@end
