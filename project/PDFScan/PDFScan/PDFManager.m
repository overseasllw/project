//
//  PSPDFMagazine.m
//  PSPDFCatalog
//
//  Copyright 2011-2012 Peter Steinberger. All rights reserved.
//

#import "PDFManager.h"

#import <QuartzCore/CATiledLayer.h>

#if !__has_feature(objc_arc)
#error "Compile this file with ARC"
#endif

@implementation PDFManager

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSObject

+ (PDFManager *)magazineWithPath:(NSString *)path {
    NSURL *URL = path ? [NSURL fileURLWithPath:path] : nil;
    PDFManager *magazine = [(PDFManager *)[[self class] alloc] initWithFilePath:[NSString stringWithFormat:@"%@", URL] password:nil];
    magazine.available = YES;
    return magazine;
}

- (id)init {
    if ((self = [super init])) {
        // most magazines can enable this to speed up display (aspect ration doesn't need to be recalculated)
        //aspectRatioEqual_ = YES;
    }
    return self;
}


///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Meta Data

- (UIImage *)coverImageForSize:(CGSize)size {
    UIImage *coverImage = nil;
    
    // basic check if file is available - don't check for pageCount here, it's lazy evaluated.
 /*   if (self.basePath) {
        coverImage = [[PSPDFCache sharedCache] cachedImageForDocument:self page:0 size:PSPDFSizeThumbnail];
    }*/
    @autoreleasepool {
        
            if (!CGSizeEqualToSize(size, CGSizeZero)) {
                UIGraphicsBeginImageContextWithOptions(size, YES, 0.0);
                [[UIColor colorWithWhite:0.9 alpha:1.f] setFill];
                CGContextFillRect(UIGraphicsGetCurrentContext(), (CGRect){.size=size});
                UIImage *lockImage = [UIImage imageNamed:@"lock"];
                CGSize lockImageTargetSize = CGSizeMake(lockImage.size.width*0.3, lockImage.size.height*0.3);
                [lockImage drawInRect:(CGRect){.origin={floorf((size.width-lockImageTargetSize.width)/2), floorf((size.height-lockImageTargetSize.height)/2)}, .size=lockImageTargetSize}];
                coverImage = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
            }
        }
    
    
    return coverImage;
}

// example how to manually rotate a page
/*
 - (PSPDFPageInfo *)pageInfoForPage:(NSUInteger)page pageRef:(CGPDFPageRef)pageRef {
 PSPDFPageInfo *pi = [super pageInfoForPage:page pageRef:pageRef];
 pi.pageRotation = (pi.pageRotation + 90) % 360;
 return pi;
 }*/

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Public


///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFDocument

- (void)setDownloading:(BOOL)downloading {
    if (downloading != _downloading) {
        _downloading = downloading;
        
        if(!downloading) {
            // clear cache, needed to recalculate pageCount
         //   [self clearCache];
            
            // request coverImage - grid listens for those events
            [self coverImageForSize:CGSizeZero];
        }
    }
}

@end
