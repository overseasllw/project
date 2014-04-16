//
//  DVPictureBox.m
//  cdsPayment
//
//  Created by Ajit Randhawa on 7/24/12.
//  Copyright (c) 2012 Ajit Randhawa. All rights reserved.
//

#import "DVPictureBox.h"
#import "CaptureSessionManager.h"
#import "UIImage+Crop.h"

#import "BJImageCropper.h"

#define ANIMATION_DURATION .4

@implementation DVPictureBox
{
    UIToolbar *_toolbar;
    
    UIBarButtonItem *clearButton;
    UIBarButtonItem *changeButton;
    UIBarButtonItem *doneButton;
    UIBarButtonItem *cancelButton;
    UIBarButtonItem *takeButton;
    UIBarButtonItem *cropButton;
    
    UIBarButtonItem *spacer;
    
    NSArray *disabledButtons;
    NSArray *activeButtons;
    NSArray *croppingButtons;
    
    UILabel *noImageLabel;
    
    UIImageView *imageView;
    
    UIImageView *overlayView;
    
    CGRect imageRect;
    CGRect _autoSnapRect;
    
    UIView *autoSnapPreview;
    
    UIView *contentView;
    
    UISegmentedControl *segmentLight;
    // Cropping
    
    BJImageCropper *cropper;
}

@synthesize delegate=_delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //self.backgroundColor = [UIColor redColor];
        
        //self.opaque = NO;
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.85];
        
        
        _toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0,410, 320, 44)];
        _toolbar.barStyle = UIBarStyleBlack;
        
        [self addSubview:_toolbar];
        
        clearButton = [[UIBarButtonItem alloc] initWithTitle:@"Clear" style:UIBarButtonItemStyleBordered target:self action:@selector(clear)];
        changeButton = [[UIBarButtonItem alloc] initWithTitle:@"Change" style:UIBarButtonItemStyleBordered target:self action:@selector(change)];
        doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:nil action:@selector(done)];
        cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancel)];
        takeButton = [[UIBarButtonItem alloc] initWithTitle:@"Take" style:UIBarButtonItemStyleDone target:self action:@selector(take)];
        cropButton = [[UIBarButtonItem alloc] initWithTitle:@"crop" style:UIBarButtonItemStyleDone target:self action:@selector(crop)];
        
        segmentLight = [[UISegmentedControl alloc]initWithItems:[NSArray arrayWithObjects:@"Auto",@"ON",@"OFF", nil]];
        [segmentLight setBackgroundColor:[UIColor blueColor]];
        [segmentLight setFrame:CGRectMake(5, 20, 50, 30)];
        segmentLight.segmentedControlStyle =UISegmentedControlStylePlain;
        
        spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        disabledButtons = [NSArray arrayWithObjects:clearButton, changeButton, spacer, doneButton, nil];
        activeButtons = [NSArray arrayWithObjects:cancelButton, spacer, takeButton, nil];
        croppingButtons = [NSArray arrayWithObjects:cancelButton, spacer, cropButton, nil];
        
        imageRect = CGRectMake(0, 0, 320, 416);
        
        noImageLabel = [[UILabel alloc] initWithFrame:imageRect];
        noImageLabel.textColor = [UIColor whiteColor];
        noImageLabel.textAlignment = NSTextAlignmentCenter;
        noImageLabel.text = @"Tap 'Change' to add an image.";
        noImageLabel.backgroundColor = [UIColor clearColor];
        
        imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        captureManager = [CaptureSessionManager get];
        
        
        
        self.state = DVPictureBoxStateDisabled;
        self.image = nil;
        
        overlayView = [[UIImageView alloc] initWithFrame:imageRect];
        overlayView.image = [UIImage imageNamed:@"creditCardFrame"];
        overlayView.contentMode = UIViewContentModeTop;
        
        self.autoSnapRect = CGRectMake(30, 100, 260, 160);
        
        contentView = [[UIView alloc] initWithFrame:imageRect];
        [self addSubview:contentView];
        cropper = [[BJImageCropper alloc] initWithFrame:imageRect];
        
        
    }
    return self;
}



-(void)setFrame:(CGRect)frame
{

    [super setFrame:frame];
    
    imageRect = CGRectMake(0, 0, frame.size.width, frame.size.height - 44);
    
    contentView.frame = imageRect;
    
    CGRect r = CGRectOffset(imageRect, -1 * imageRect.origin.x, -1 * imageRect.origin.y);
    
    imageView.frame = r;
    overlayView.frame = r;
    noImageLabel.frame = r;
    

}

-(DVPictureBoxState)state
{
    return _state;
}


- (void)setState:(DVPictureBoxState)state
{
    if (state == DVPictureBoxStateActive)
    {
        [self.toolbar setItems:activeButtons animated:YES];
        
        if (_state == DVPictureBoxStateDisabled)
        {
            [self createPreview];
        }
        
        [UIView animateWithDuration:ANIMATION_DURATION animations:^{
            imageView.alpha = 0.0;
        } completion:^(BOOL finished) {
            if (finished)
                [imageView removeFromSuperview];
        }];
        
    } else if (state == DVPictureBoxStateDisabled)
    {
        [self.toolbar setItems:disabledButtons animated:YES];
        [contentView addSubview:imageView];
        [UIView animateWithDuration:ANIMATION_DURATION animations:^{
            imageView.alpha = 1.0;
            cropper.alpha = 0.0;
        } completion:^(BOOL finished) {
            if (finished)
                [cropper removeFromSuperview];
        }];
        
        if (_state == DVPictureBoxStateActive)
        {
            [self destroyPreview];
        }
    } else if (state == DVPictureBoxStateCropping)
    {
        [self.toolbar setItems:croppingButtons animated:YES];
        
        [contentView addSubview:cropper];
        
        [UIView animateWithDuration:ANIMATION_DURATION animations:^{
            cropper.frame = contentView.bounds;
            cropper.alpha = 1.0;
        }];
        
        
        if (_state == DVPictureBoxStateActive)
        {
            [self destroyPreview];
        }
    }
    
    _state = state;
}



- (void)createPreview
{
    NSLog(@"----------");
    imageRect = self.layer.bounds;
    //imageRect.origin.y += _toolbar.bounds.size.height;
    imageRect.size.height -= _toolbar.bounds.size.height;
	[[captureManager previewLayer] setBounds:imageRect];
	[[captureManager previewLayer] setPosition:CGPointMake(CGRectGetMidX(imageRect),
                                                                  CGRectGetMidY(imageRect))];
	[self.layer addSublayer:[captureManager previewLayer]];
    [self addSubview:segmentLight];
    overlayView.alpha = 1.0;
    overlayView.frame = contentView.frame;
    [self addSubview:overlayView];
    
    [UIView animateWithDuration:.4 animations:^{
        overlayView.alpha = 1.0;
    }];
    
	[[captureManager captureSession] startRunning];
}

- (void)destroyPreview
{
    [[captureManager captureSession] stopRunning];
    [captureManager.previewLayer removeFromSuperlayer];
    

    [UIView animateWithDuration:.4 animations:^{
        overlayView.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished)
            [overlayView removeFromSuperview];
    }];
}

#pragma mark - Bar Button Handlers

- (void)clear
{
    [self setImage:nil];
    if ([self.delegate respondsToSelector:@selector(pictureBox:imageWasChanged:)])
        [self.delegate pictureBox:self imageWasChanged:nil];
    [captureManager setStillImage:nil];
}

- (void)change
{
    [self setState:DVPictureBoxStateActive];
}

- (void)done
{
    //[self setState:DVPictureBoxStateDisabled];
    if ([self.delegate respondsToSelector:@selector(pictureBoxDoneEditing:)])
        [self.delegate pictureBoxDoneEditing:self];
    NSURL *jsonURL =[NSURL URLWithString:@"http://173.15.239.213/screen/count.php"];
    NSData *jsonData = [NSData dataWithContentsOfURL:jsonURL];
    //   self.jsonArray =[jsonData JSONValue];
    NSError *error;
     jsonCount = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
     numberFlag = [jsonCount objectAtIndex:0];
    flagNumber = [[numberFlag objectForKey:@"number"] intValue];
    if (flagNumber == 0) {
        actionSheet = [[UIActionSheet alloc]
                       initWithTitle:@"save to..."
                       delegate:self
                       cancelButtonTitle:@"Cancel"
                       destructiveButtonTitle:nil
                       otherButtonTitles:@"New Document",nil];
    }else{
        actionSheet = [[UIActionSheet alloc]
                       initWithTitle:@"save to..."
                       delegate:self
                       cancelButtonTitle:@"Cancel"
                       destructiveButtonTitle:nil
                       otherButtonTitles:@"Existing Document",@"New Document",nil];
    }
    
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showInView:self];

    
}

- (void)cancel
{
    [self setState:DVPictureBoxStateDisabled];
}

- (void)take
{
    [captureManager captureStillImage:^(UIImage *image) {
        

        
        CGRect cropBounds = contentView.bounds;
        //cropBounds.origin.y -= contentView.frame.origin.y;
        
        CGRect windowFrame = [[UIApplication sharedApplication] keyWindow].frame;
        
        CGSize imageSize;
        imageSize.height = CGImageGetHeight(image.CGImage);
        imageSize.width = CGImageGetWidth(image.CGImage);
    
        CGFloat scale = imageSize.width / windowFrame.size.width;
        //// The image data is actually landscape.
        scale = imageSize.height / windowFrame.size.width;
        
        
        // Set this to the area of the image you want to have cropped.
        CGRect bounds = cropBounds;
        
        bounds = [contentView convertRect:bounds fromView:self];
        
        
        bounds.size.height *= scale;
        bounds.size.width *= scale;
        
        CGFloat diff = (contentView.bounds.size.height / 2 - cropBounds.origin.y);
        bounds.origin.y = (imageSize.width / 2) - diff * scale;
       
        bounds.origin.x *= scale;
        
        CGRect b2 = CGRectMake(bounds.origin.y, bounds.origin.x, bounds.size.height, bounds.size.width);
    
        image = [image crop:b2];
        
        image = [UIImage imageWithCGImage:image.CGImage scale:image.scale orientation:UIImageOrientationRight];
        cropper.image = image;
        cropper.unscaledCrop = self.autoSnapRect;
//        self.image = image;
//        
//        if ([self.delegate respondsToSelector:@selector(pictureBox:imageWasChanged:)])
//            [self.delegate pictureBox:self imageWasChanged:image];
        
        //[self setState:DVPictureBoxStateDisabled];
        [self setState:DVPictureBoxStateCropping];
        
//        NSData *data = UIImageJPEGRepresentation(image, 1.0);
//        NSFileManager *fileManager = [NSFileManager defaultManager];
//        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,  YES);
//        NSString *documentsDirectory = [paths objectAtIndex:0];
//        NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:@"Image.jpg"];
//        [fileManager createFileAtPath:fullPath contents:data attributes:nil];
    }];
}

- (void)crop
{
    CGFloat duration = .6;
    
    UIImage *newimage = [cropper getCroppedImage];
    
    imageView.frame = cropper.unscaledCrop;
    
    [self.toolbar setItems:disabledButtons animated:YES];
    
    [UIView animateWithDuration:duration animations:^{
        self.image = newimage;
        cropper.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished)
        {
            [self setState:DVPictureBoxStateDisabled];
            if ([self.delegate respondsToSelector:@selector(pictureBox:imageWasChanged:)])
                [self.delegate pictureBox:self imageWasChanged:newimage];
        }
    }];
    
    
    
}

#pragma mark - Properties

-(UIToolbar *)toolbar
{
    return _toolbar;
}

- (UIImage *)image
{
    return _image;
}

- (void)setImage:(UIImage *)image
{
    _image = image;
    

    
    if (image == nil)
    {
        [imageView removeFromSuperview];
        [imageView setFrame:contentView.bounds];
        [noImageLabel setFrame:contentView.bounds];
        [contentView addSubview:noImageLabel];
    } else
    {
        [noImageLabel removeFromSuperview];
        [imageView setFrame:contentView.bounds];
        [imageView setImage:image];
        [contentView addSubview:imageView];
    }
}

-(CGRect)autoSnapRect
{
    return _autoSnapRect;
}

-(void)setAutoSnapRect:(CGRect)autoSnapRect
{
    _autoSnapRect = autoSnapRect;
    
    if (autoSnapPreview == nil)
    {
        autoSnapPreview = [[UIView alloc] initWithFrame:autoSnapRect];
        autoSnapPreview.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:0 alpha:.25];
        [overlayView addSubview:autoSnapPreview];
    }
    
    autoSnapPreview.frame = autoSnapRect;
}

-(void)showAlert:(NSString *)msg {
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Action Sheet Option"
                          message:msg
                          delegate:self
                          cancelButtonTitle:@"OK"
                          otherButtonTitles: nil];
    [alert show];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (flagNumber ==0) {
        if (buttonIndex == 0) {
            [self uploadPic:UIImageJPEGRepresentation(self.image, 10)];
            
            
        }else if (buttonIndex == 1) {
            [self showAlert:@"cancel"];
        }
        
    }else{
        if (buttonIndex == 0) {
         //   ExistTableViewController *tab = [[ExistTableViewController alloc]init];//[self.storyboard instantiateInitialViewController];//instantiateViewControllerWithIdentifier:@"TableViewController"];//[TableViewController alloc]init];
            //  [self showListView];
            // ExistTableViewController *abc =[self.navigationController.storyboard instantiateInitialViewController];
         //   tab.dateeee = @"09898987656746";
            //  [self performSegueWithIdentifier: @"selectForm" sender: self];
            //  [[self navigationController]initWithNibName:@"a" bundle:nil];
            // [self.navigationController.presentedViewController.init  ]
            // [self.navigationController tab animated:YES];
          //  [self.navigationController pushViewController:tab animated:YES];
            // [self.navigationController popToRootViewControllerAnimated:YES];
            // [self.navigationController popToViewController:tab animated:YES];
        }else if (buttonIndex == 1) {
            [self uploadPic:UIImageJPEGRepresentation(self.image, 10)];
            NSLog(@"090909=======");
          //  [self.]
            //  TableViewController *tab = [[TableViewController alloc]init];
          //  CustomerTableViewController *customer = [[CustomerTableViewController alloc]init];
            //UIViewController *abc =  s
          //  customer.imagetag =@"1341952404";
            //   [self.navigationController pushViewController:customer animated:YES];
           // [self.navigationController popToRootViewControllerAnimated:YES];
            // [self.navigationController pushViewController:customer animated:YES];
        }else if (buttonIndex == 2) {
            [self showAlert:@"cancel"];
        }
    }
    
}

- (void)actionSheetCancel:(UIActionSheet *)actionSheet{
    
}
-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    
}
-(void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex{
    
}
-(void)uploadPic:(NSData *)imageData{
    
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd-HH:mm:ss"];
    //  NSDate *da =[NSDate date];
    NSString *da = [NSString stringWithString:[formatter stringFromDate:[NSDate date]]];
    NSString *urlString = @"http://173.15.239.213/screen/imagesupload.php";
    urlString = [urlString stringByAppendingFormat:@"?tag=%@&",da];
    // setting up the request object now
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    
    
    NSString *te = [@"Content-Disposition: form-data; name=\"image\"; filename=\"" stringByAppendingString:da];
    te =  [te stringByAppendingString:@"\"\r\n"];
    NSMutableData *body = [NSMutableData data];
    // NSString *da = [NSString stringWithString:[NSDate date]];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:te,index] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:imageData]];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    // setting the body of the post to the reqeust
    [request setHTTPBody:body];
    //NSLog(boundary);
    // now lets make the connection to the web
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@",returnString);
}


@end
