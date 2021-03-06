#import "CaptureSessionManager.h"
#import <ImageIO/ImageIO.h>

@implementation CaptureSessionManager

@synthesize captureSession;
@synthesize previewLayer;

#pragma mark Capture Session Configuration

- (id)init {
	if ((self = [super init])) {
		[self setCaptureSession:[[AVCaptureSession alloc] init]];
	}
	return self;
}

+(CaptureSessionManager *)get
{
    static CaptureSessionManager *instance = nil;
    
    if (instance == nil)
    {
        instance = [[CaptureSessionManager alloc] init];
        
        [instance addVideoInput];
        [instance addVideoPreviewLayer];
        [instance addStillImageOutput];
    }
    
    return instance;
}

- (void)addVideoPreviewLayer {
    
    [self setPreviewLayer:[[AVCaptureVideoPreviewLayer alloc] initWithSession:[self captureSession]]];
	[[self previewLayer] setVideoGravity:AVLayerVideoGravityResizeAspectFill];
  
}

- (void)addVideoInput {
	AVCaptureDevice *videoDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];	
	if (videoDevice) {
		NSError *error;
		AVCaptureDeviceInput *videoIn = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:&error];
		if (!error) {
			if ([[self captureSession] canAddInput:videoIn])
				[[self captureSession] addInput:videoIn];
			else
				NSLog(@"Couldn't add video input");		
		}
		else
			NSLog(@"Couldn't create video input");
	}
	else
		NSLog(@"Couldn't create video capture device");
}

- (void)dealloc {

	[[self captureSession] stopRunning];

	//[previewLayer release];
    previewLayer = nil;
	//[captureSession release];
    captureSession = nil;

	//[super dealloc];
}


@synthesize stillImageOutput, stillImage;

- (void)addStillImageOutput
{
    [self setStillImageOutput:[[AVCaptureStillImageOutput alloc] init]];
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey,nil];
    [[self stillImageOutput] setOutputSettings:outputSettings];
    
    AVCaptureConnection *videoConnection = nil;
    for (AVCaptureConnection *connection in [[self stillImageOutput] connections]) {
        for (AVCaptureInputPort *port in [connection inputPorts]) {
            if ([[port mediaType] isEqual:AVMediaTypeVideo] ) {
                videoConnection = connection;
                break;
            }
        }
        if (videoConnection) {
            break;
        }
    }
    
    [[self captureSession] addOutput:[self stillImageOutput]];
}

- (void)captureStillImage:(StillImageCapturedBlock)block
{
	AVCaptureConnection *videoConnection = nil;
	for (AVCaptureConnection *connection in [[self stillImageOutput] connections]) {
		for (AVCaptureInputPort *port in [connection inputPorts]) {
			if ([[port mediaType] isEqual:AVMediaTypeVideo]) {
				videoConnection = connection;
				break;
			}
		}
		if (videoConnection) {
            break;
        }
	}
    
	NSLog(@"about to request a capture from: %@", [self stillImageOutput]);
	[[self stillImageOutput] captureStillImageAsynchronouslyFromConnection:videoConnection
                                                         completionHandler:^(CMSampleBufferRef imageSampleBuffer, NSError *error) {
                                                             CFDictionaryRef exifAttachments = CMGetAttachment(imageSampleBuffer, kCGImagePropertyExifDictionary, NULL);
                                                             if (exifAttachments) {
                                                                 NSLog(@"attachements: %@", exifAttachments);
                                                             } else {
                                                                 NSLog(@"no attachments");
                                                             }
                                                             NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
                                                             
                                                             
                                                             UIImage *image = [UIImage imageWithData:imageData];
                                                             //UIImage *image = [[UIImage alloc] initWithData:imageData];
                                                             
                                                             
                                                             [self setStillImage:image];
                                                             block(image);
                                                         }];
}

//// Create and configure a capture session and start it running
//- (void)setupCaptureSession
//{
//    NSError *error = nil;
//    
//    // Create the session
//    AVCaptureSession *session = [[AVCaptureSession alloc] init];
//    
//    // Configure the session to produce lower resolution video frames, if your
//    // processing algorithm can cope. We'll specify medium quality for the
//    // chosen device.
//    session.sessionPreset = AVCaptureSessionPresetMedium;
//    
//    // Find a suitable AVCaptureDevice
//    AVCaptureDevice *device = [AVCaptureDevice
//                               defaultDeviceWithMediaType:AVMediaTypeVideo];
//    
//    // Create a device input with the device and add it to the session.
//    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device
//                                                                        error:&error];
//    if (!input) {
//        // Handling the error appropriately.
//    }
//    [session addInput:input];
//    
//    // Create a VideoDataOutput and add it to the session
//    AVCaptureVideoDataOutput *output = [[[AVCaptureVideoDataOutput alloc] init] autorelease];
//    [session addOutput:output];
//    
//    // Configure your output.
//    dispatch_queue_t queue = dispatch_queue_create("myQueue", NULL);
//    [output setSampleBufferDelegate:self queue:queue];
//    dispatch_release(queue);
//    
//    // Specify the pixel format
//    output.videoSettings =
//    [NSDictionary dictionaryWithObject:
//     [NSNumber numberWithInt:kCVPixelFormatType_32BGRA]
//                                forKey:(id)kCVPixelBufferPixelFormatTypeKey];
//    
//    
//    // If you wish to cap the frame rate to a known value, such as 15 fps, set
//    // minFrameDuration.
//    output.minFrameDuration = CMTimeMake(1, 15);
//    
//    // Start the session running to start the flow of data
//    [session startRunning];
//    
//    // Assign session to an ivar.
//    [self setSession:session];
//}
//
//// Delegate routine that is called when a sample buffer was written
//- (void)captureOutput:(AVCaptureOutput *)captureOutput
//didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
//       fromConnection:(AVCaptureConnection *)connection
//{
//    // Create a UIImage from the sample buffer data
//    UIImage *image = [self imageFromSampleBuffer:sampleBuffer];
//    
//    < Add your code here that uses the image >
//    
//}
//
//// Create a UIImage from sample buffer data
//- (UIImage *) imageFromSampleBuffer:(CMSampleBufferRef) sampleBuffer
//{
//    // Get a CMSampleBuffer's Core Video image buffer for the media data
//    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
//    // Lock the base address of the pixel buffer
//    CVPixelBufferLockBaseAddress(imageBuffer, 0);
//    
//    // Get the number of bytes per row for the pixel buffer
//    void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);
//    
//    // Get the number of bytes per row for the pixel buffer
//    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
//    // Get the pixel buffer width and height
//    size_t width = CVPixelBufferGetWidth(imageBuffer);
//    size_t height = CVPixelBufferGetHeight(imageBuffer);
//    
//    // Create a device-dependent RGB color space
//    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
//    
//    // Create a bitmap graphics context with the sample buffer data
//    CGContextRef context = CGBitmapContextCreate(baseAddress, width, height, 8,
//                                                 bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
//    // Create a Quartz image from the pixel data in the bitmap graphics context
//    CGImageRef quartzImage = CGBitmapContextCreateImage(context);
//    // Unlock the pixel buffer
//    CVPixelBufferUnlockBaseAddress(imageBuffer,0);
//    
//    // Free up the context and color space
//    CGContextRelease(context);
//    CGColorSpaceRelease(colorSpace);
//    
//    // Create an image object from the Quartz image
//    UIImage *image = [UIImage imageWithCGImage:quartzImage];
//    
//    // Release the Quartz image
//    CGImageRelease(quartzImage);
//    
//    return (image);
//}

@end
