//
//  PDFImageConverter.m
//
//  Created by Sorin Nistor on 4/21/11.
//  Copyright 2011 iPDFdev.com. All rights reserved.
//

#import "PDFImageConverter.h"

#import "RetrievePDFData.h"
#import "SDImageCache.h"
#import "CheckDataUpdate.h"
@implementation PDFImageConverter

+ (NSData *) convertImageToPDF: (UIImage *) image {
    return [PDFImageConverter convertImageToPDF: image withResolution: 96];
}

+ (NSData *) convertImageToPDF: (UIImage *) image withResolution: (double) resolution {
    return [PDFImageConverter convertImageToPDF: image withHorizontalResolution: resolution verticalResolution: resolution];
}

+ (NSData *) convertImageToPDF: (UIImage *) image withHorizontalResolution: (double) horzRes verticalResolution: (double) vertRes {
    if ((horzRes <= 0) || (vertRes <= 0)) {
        return nil;
    }
    
    double pageWidth = image.size.width * image.scale * 72 / horzRes;
    double pageHeight = image.size.height * image.scale * 72 / vertRes;
    
    NSMutableData *pdfFile = [[NSMutableData alloc] init];
    CGDataConsumerRef pdfConsumer = CGDataConsumerCreateWithCFData((__bridge CFMutableDataRef)pdfFile);
    // The page size matches the image, no white borders.
    CGRect mediaBox = CGRectMake(0, 0, pageWidth, pageHeight);
    CGContextRef pdfContext = CGPDFContextCreate(pdfConsumer, &mediaBox, NULL);
    
    CGContextBeginPage(pdfContext, &mediaBox);
    CGContextDrawImage(pdfContext, mediaBox, [image CGImage]);
    CGContextEndPage(pdfContext);
    CGContextRelease(pdfContext);
    CGDataConsumerRelease(pdfConsumer);    
    return pdfFile;
}

+ (NSData *) convertImageToPDF: (UIImage *) image withResolution: (double) resolution maxBoundsRect: (CGRect) boundsRect pageSize: (CGSize) pageSize {
    if (resolution <= 0) {
        return nil;
    }
    
    double imageWidth = image.size.width * image.scale * 72 / resolution;
    double imageHeight = image.size.height * image.scale * 72 / resolution;
    
    double sx = imageWidth / boundsRect.size.width;
    double sy = imageHeight / boundsRect.size.height;
    
    // At least one image edge is larger than maxBoundsRect
    if ((sx > 1) || (sy > 1)) {
        double maxScale = sx > sy ? sx : sy;
        imageWidth = imageWidth / maxScale;
        imageHeight = imageHeight / maxScale;
    }
    
    // Put the image in the top left corner of the bounding rectangle
    CGRect imageBox = CGRectMake(boundsRect.origin.x, boundsRect.origin.y + boundsRect.size.height - imageHeight, imageWidth, imageHeight);
    
    NSMutableData *pdfFile = [[NSMutableData alloc] init];
    CGDataConsumerRef pdfConsumer = CGDataConsumerCreateWithCFData((__bridge CFMutableDataRef)pdfFile);
    
    CGRect mediaBox = CGRectMake(0, 0, pageSize.width, pageSize.height);
    CGContextRef pdfContext = CGPDFContextCreate(pdfConsumer, &mediaBox, NULL);
    
    CGContextBeginPage(pdfContext, &mediaBox);
    CGContextDrawImage(pdfContext, imageBox, [image CGImage]);
    CGContextEndPage(pdfContext);
    CGContextRelease(pdfContext);
    CGDataConsumerRelease(pdfConsumer);
    return pdfFile;
}

+(void)WriteToLocal:(NSData *)pdfData withPDFName:(NSString*)filename{

    NSString *path=[[NSString alloc]initWithFormat:@"Documents/%@",[RetrievePDFData cachePathForKey:filename]];
    path = [NSHomeDirectory() stringByAppendingPathComponent:path];
    
   // NSLog(@"Write to local:%@",path);
    
    if (pdfData) {
        [pdfData writeToFile:path atomically:NO];
         NSLog(@"Write to Local!!");
    }       
    
}


+(void)MergeTwoPDF:(NSData*)PDF1:(NSData*)PDF2:(NSString*)filename{
    // Documents dir
   // NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //NSString *documentsDirectory = [paths objectAtIndex:0];
  //  NSLog(@"====%@====",filename);
    // File paths
 //   NSString *pdfPath1 = [documentsDirectory stringByAppendingPathComponent:[RetrievePDFData cachePathForKey:PDF1]];
   // NSString *pdfPath2 = [documentsDirectory stringByAppendingPathComponent:[RetrievePDFData cachePathForKey:PDF2]];
    NSString *pdfPathOutput = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@",[RetrievePDFData cachePathForKey:filename]]];


    [[SDImageCache sharedImageCache] removeImageForKey:filename fromDisk:YES];
    // File URLs
 //   CFURLRef pdfURL1 = (CFURLRef)CFBridgingRetain([[NSURL alloc] initFileURLWithPath:pdfPath1]);
 //   CFURLRef pdfURL2 = (CFURLRef)CFBridgingRetain([[NSURL alloc] initFileURLWithPath:pdfPath2]);
    CFURLRef pdfURLOutput = (CFURLRef)CFBridgingRetain([[NSURL alloc] initFileURLWithPath:pdfPathOutput]);
   // CFDataRef *ref=[cfdataget]
   // CGDataProviderCreateWithCFData( );

    CFDataRef PDFData1 = (CFDataRef)CFBridgingRetain(PDF1);
    CGDataProviderRef provider1 = CGDataProviderCreateWithCFData(PDFData1);
    CFDataRef PDFData2 = (CFDataRef)CFBridgingRetain(PDF2);
    CGDataProviderRef provider2 = CGDataProviderCreateWithCFData(PDFData2);
  //  CGPDFDocumentRef pdf = CGPDFDocumentCreateWithProvider(provider);


    // File references
    CGPDFDocumentRef pdfRef1 = CGPDFDocumentCreateWithProvider(provider1); //CGPDFDocumentCreateWithURL((CFURLRef) pdfURL1);

    UIImage *image = [[UIImage alloc]init];
    CGPDFPageRef page1 = CGPDFDocumentGetPage(pdfRef1,1);
    if (page1) {

        CGRect pageSize = CGPDFPageGetBoxRect(page1, kCGPDFMediaBox);//(595.276,807.874)
        CGBitmapInfo bmi = (kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipFirst);
        CGContextRef outContext =CGBitmapContextCreate(NULL,pageSize.size.width,pageSize.size.height,8,0,CGColorSpaceCreateDeviceRGB(),bmi);
        if (outContext)
        {
            CGContextDrawPDFPage(outContext, page1);
            CGImageRef pdfImageRef = CGBitmapContextCreateImage(outContext);
            CGContextRelease(outContext);
            image = [UIImage imageWithCGImage:pdfImageRef];

            CGImageRelease(pdfImageRef);

            
            //  CGPDFDocumentRelease(pdfRef);
            //  pdfRef = NULL;
        }
    }

    // [UIImagePNGRepresentation(image) writeToFile:urlString atomically:NO];
    image = [RetrievePDFData Scaleimage:image TargetSize:CGSizeMake(77, 106)];
    [[SDImageCache sharedImageCache] storeImage:image  forKey:filename toDisk:YES];

    if ([[SDImageCache sharedImageCache] imageFromKey:filename fromDisk:YES]) {
      //  [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadFlag" object:nil];
        NSLog(@"image exist! second");
    }else{
        NSLog(@"not eixst file second");
    }

    CGPDFDocumentRef pdfRef2 = CGPDFDocumentCreateWithProvider(provider2);//CGPDFDocumentCreateWithURL((CFURLRef) pdfURL2);
    
    // Number of pages
    NSInteger numberOfPages1 = CGPDFDocumentGetNumberOfPages(pdfRef1);
    NSInteger numberOfPages2 = CGPDFDocumentGetNumberOfPages(pdfRef2);
    
    // Create the output context
    CGContextRef writeContext = CGPDFContextCreateWithURL(pdfURLOutput, NULL, NULL);
    
    // Loop variables
    CGPDFPageRef page;
    CGRect mediaBox;
    
    // Read the first PDF and generate the output pages
    NSLog(@"GENERATING PAGES FROM PDF 1 (%i)...", numberOfPages1);
    for (int i=1; i<=numberOfPages1; i++) {
        page = CGPDFDocumentGetPage(pdfRef1, i);
        mediaBox = CGPDFPageGetBoxRect(page, kCGPDFMediaBox);
        CGContextBeginPage(writeContext, &mediaBox);
        CGContextDrawPDFPage(writeContext, page);
        CGContextEndPage(writeContext);
    }
    
    // Read the second PDF and generate the output pages
    NSLog(@"GENERATING PAGES FROM PDF 2 (%i)...", numberOfPages2);
    for (int i=1; i<=numberOfPages2; i++) {
        page = CGPDFDocumentGetPage(pdfRef2, i);
        mediaBox = CGPDFPageGetBoxRect(page, kCGPDFMediaBox);
        CGContextBeginPage(writeContext, &mediaBox);
        CGContextDrawPDFPage(writeContext, page);
        CGContextEndPage(writeContext);
    }
    NSLog(@"DONE!");
    
    CGPDFContextClose(writeContext);
   // [CheckDataUpdate changePageNumberAfterMerge:(numberOfPages1+numberOfPages2) :filename];
    CFRelease(pdfURLOutput);
    CGPDFDocumentRelease(pdfRef1);
    CGPDFDocumentRelease(pdfRef2);
    CGContextRelease(writeContext);

}



@end
