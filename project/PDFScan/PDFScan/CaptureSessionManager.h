#import <CoreMedia/CoreMedia.h>
#import <AVFoundation/AVFoundation.h>

typedef void (^StillImageCapturedBlock)(UIImage *);

@interface CaptureSessionManager : NSObject {

}

+ (CaptureSessionManager *)get;

@property (retain) AVCaptureVideoPreviewLayer *previewLayer;
@property (retain) AVCaptureSession *captureSession;

- (void)addVideoPreviewLayer;
- (void)addVideoInput;


@property (retain) AVCaptureStillImageOutput *stillImageOutput;
@property (nonatomic, retain) UIImage *stillImage;

- (void)addStillImageOutput;
//- (void)addVideoDataOutput;
- (void)captureStillImage:(StillImageCapturedBlock)block;

@end
