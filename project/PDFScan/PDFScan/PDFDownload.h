//
//  PSCDownload.h
//  PSPDFCatalog
//
//  Copyright 2011-2012 Peter Steinberger. All rights reserved.
//

#import "PDFManager.h"

typedef NS_ENUM(NSUInteger, PDFStoreDownloadStatus) {
    PDFStoreDownloadStatusIdle,
    PDFStoreDownloadStatusLoading,
    PDFStoreDownloadStatusFinished,
    PDFStoreDownloadStatusFailed,
};

/// Wrapper that helps downloading a PDF.
@interface PDFDownload : NSObject

/// Initialize a new PDF download.
+ (PDFDownload *)PDFDownloadWithURL:(NSURL *)URL;

/// Initialize a new PDF download.
- (id)initWithURL:(NSURL *)URL;

/// Start download.
- (void)startDownload;

/// Cancel running download.
- (void)cancelDownload;

/// Current download status.
@property (nonatomic, assign, readonly) PDFStoreDownloadStatus status;

/// Current download progress.
@property (nonatomic, assign, readonly) float downloadProgress;

/// Download URL.
@property (nonatomic, strong, readonly) NSURL *URL;

/// Magazine that's being downloaded.
@property (nonatomic, strong) PDFManager *magazine;

/// Exposed error.
@property (nonatomic, strong, readonly) NSError *error;

/// Download cancelled?
@property (atomic, assign, readonly, getter=isCancelled) BOOL cancelled;

@end
