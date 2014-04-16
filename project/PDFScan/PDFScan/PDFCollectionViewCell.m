//
//  PDFCollectionViewCell.m
//  PDFScan
//
//  Created by Ajit Randhawa on 11/12/12.
//  Copyright (c) 2012 Ajit Randhawa. All rights reserved.
//

#import "PDFCollectionViewCell.h"


@implementation PDFCollectionViewCell{
    
}
@synthesize downLoading;

static void PDFDispatchIfNotOnMainThread(dispatch_block_t block) {
    if (block) {
        [NSThread isMainThread] ? block() : dispatch_async(dispatch_get_main_queue(), block);
    }
}
@synthesize pdfView,pdfUrl,loadingImageURLString;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
               [pdfView setFrame:frame];
      
        downLoading=NO;
    }
    return self;
}




+ (BOOL)automaticallyNotifiesObserversForKey: (NSString *)theKey
{
    BOOL automatic;
    
    if ([theKey isEqualToString:@"thumbnailImage"]) {
        automatic = NO;
    } else {
        automatic = [super automaticallyNotifiesObserversForKey:theKey];
    }
    
    return automatic;
}

-(void) prepareForReuse {

  //  [self.imageLoadingOperation cancel];
}

@end
