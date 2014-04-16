//
//  TakePictureViewController.m
//  TakeCaptureViewPic
//
//  Created by Ajit Randhawa on 8/22/12.
//  Copyright (c) 2012 Ajit Randhawa. All rights reserved.
//

#import "TakePictureViewController.h"
#import "BJImageCropper.h"

#import "UIImage+Crop.h"
//#import "CustomerTableViewController.h"
#import "SVProgressHUD.h"
//#import "ExistingCollectionViewController.h"
//#import "CollectionViewController.h"
#import "SVProgressHUD.h"
#import "ImageCompress.h"
#import "Database.h"
#import "Reachability.h"
#import "FMDatabase.h"
#import "PDFImageConverter.h"
#import "UIImageView+WebCache.h"
#import "SDImageCache.h"
#import "RetrievePDFData.h"
#import "UploadPDF.h"
#import "PDFCollectionViewController.h"
#import "PDFImageConverter.h"
#define ANIMATION_DURATION .3

@interface TakePictureViewController ()

@end


@implementation TakePictureViewController{
    UIToolbar *_toolbar;
    
    UIToolbar *toolBarCamera;
    
    UINavigationBar *_navigationBar;
    UIBarButtonItem *clearButton;
  
    UIBarButtonItem *doneButton;
    UIBarButtonItem *cancelButton;
    UIBarButtonItem *takeButton;
    UIBarButtonItem *cropButton;
    UIBarButtonItem *photoAlbum;
    UIBarButtonItem *useButton;
    UIBarButtonItem *editButton;
    UIBarButtonItem *useButton2;
    
    UIBarButtonItem *spacer;
    
    NSArray *disabledButtons;
    NSArray *activeButtons;
    NSArray *croppingButtons;
    NSArray *useButtons;
    
    UILabel *noImageLabel;
    
    UIImageView *imageView;
    
    UIImageView *overlayView;
    
    
    CGRect imageRect;
    CGRect _autoSnapRect;
    
    UIView *autoSnapPreview;
    
    UIView *contentView;

    BJImageCropper *cropper;

}
@synthesize navigationBar=_navigationBar,imageTag=imageTag,dataInsert=dataInsert,image=_image;
@synthesize autoSnapRect=_autoSnapRect,toolbar=_toolbar,tagTime=tagTime,addNewPic=addNewPic,imageViewPreview=imageViewPreview,imageViewTemp=imageViewTemp;
@synthesize imagePickerCamera = imagePickerCamera;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       // [imagePickerCamera initWithRootViewController:t];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [SVProgressHUD dismiss];

    self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.85];
    self.navigationController.toolbarHidden = YES;
    self.navigationController.navigationBarHidden = YES;
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Document" style:UIBarButtonItemStyleBordered target:self action:@selector(backRoot)];
    self.navigationItem.backBarButtonItem = backButtonItem;
    [self.navigationItem.backBarButtonItem setAction:@selector(backRoot)];
    
    
    _toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0,416, 320, 44)];
    _toolbar.barStyle = UIBarStyleDefault;
    [self.view addSubview:_toolbar];
    
    
    _navigationBar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    _navigationBar.barStyle = UIBarStyleBlackTranslucent;
    
    clearButton = [[UIBarButtonItem alloc] initWithTitle:@"cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(clear)];
    doneButton = [[UIBarButtonItem alloc] initWithTitle:@"save" style:UIBarButtonItemStyleDone target:self action:@selector(done)];
    cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"retake" style:UIBarButtonItemStyleBordered target:self action:@selector(cancel)];
    takeButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(shootPicture)];//take
    cropButton = [[UIBarButtonItem alloc] initWithTitle:@"crop" style:UIBarButtonItemStyleDone target:self action:@selector(crop)];
    useButton = [[UIBarButtonItem alloc] initWithTitle:@"use" style:UIBarButtonItemStyleBordered target:self action:@selector(usePic)];
    editButton = [[UIBarButtonItem alloc]initWithTitle:@"Edit" style:UIBarButtonItemStyleBordered target:self action:@selector(editPic)];
    photoAlbum = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(photoAlbum)];
    //useButton2 = [UIBarButtonItem alloc]initWithTitle:@"use" style:UIBarButtonItemStyleBordered target:self action:c
    spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    disabledButtons = [NSArray arrayWithObjects:clearButton, spacer, doneButton, nil];
    activeButtons = [NSArray arrayWithObjects:clearButton, spacer, takeButton, spacer,photoAlbum,nil];
    useButtons = [NSArray arrayWithObjects:cancelButton, spacer, editButton, spacer,useButton,nil];
    croppingButtons = [NSArray arrayWithObjects:cancelButton, spacer, cropButton, nil];
    
    imageRect = CGRectMake(0, 0, 320, 416);
    imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];

    imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    
    self.image = nil;
    
    overlayView = [[UIImageView alloc] initWithFrame:imageRect];
    overlayView.image = [UIImage imageNamed:@"ScanFrame"];
    overlayView.contentMode = UIViewContentModeTop;
    
    self.autoSnapRect = CGRectMake(60, 80, 200, 300);
    
    contentView = [[UIView alloc] initWithFrame:imageRect];
    [self.view addSubview:contentView];
    
    
    cropper = [[BJImageCropper alloc] initWithFrame:imageRect];
   // [self.toolbar  setItems:activeButtons animated:YES];
    self.toolbar.hidden = YES;
    [self createPreview];
    [UIView animateWithDuration:ANIMATION_DURATION delay:5 options:UIViewAnimationOptionAllowUserInteraction   animations:^{
        imageView.alpha = 0.0;
        
    } completion:^(BOOL finished) {
        if (finished)
            [imageView removeFromSuperview];
    }];

}

-(void)viewDidUnload{
    [super viewDidUnload];
}

- (void)createPreview
{
    /* imageRect = self.view.layer.bounds;
     // [self addSubview:segmentLight];
     imageRect.size.height -= _toolbar.bounds.size.height;
     [[captureManager previewLayer] setBounds:imageRect];
     [[captureManager previewLayer] setPosition:CGPointMake(CGRectGetMidX(imageRect),
     CGRectGetMidY(imageRect))];
     [self.view.layer addSublayer:[captureManager previewLayer]];
     
     // overlayView.alpha = 1.0;
     // overlayView.frame = contentView.frame;
     // [self.view addSubview:overlayView];
     
     [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
     // overlayView.alpha = 1.0;
     CATransition *animation = [CATransition animation];
     animation.delegate = self;
     animation.duration = 0.5;
     
     animation.timingFunction = UIViewAnimationCurveEaseInOut;
     animation.type = @"cameraIrisHollowOpen";
     // animation.type = @"cube";
     // UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
     // self.navigationController.view.layer setani];
     //[self.navigationController.view.layer a]
     [self.view.superview.layer  addAnimation:animation forKey:@"animation"];
     } completion:^(BOOL finished) {
     //[overlayView removeFromSuperview];
     }];
     
     
     [[captureManager captureSession] startRunning];*/
    // UIImagePickerController *imagePickerCamera=[[UIImagePickerController alloc]init];
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        
        imagePickerCamera = [[UIImagePickerController alloc] init];
        imagePickerCamera.sourceType = UIImagePickerControllerSourceTypeCamera;
        toolBarCamera=[[UIToolbar alloc] initWithFrame:CGRectMake(0, 426, 320, 54)];
        //  imagePickerCamera.videoQuality = UIImagePickerControllerQualityTypeMedium;
        toolBarCamera.barStyle =  UIBarStyleBlackOpaque;
        toolBarCamera.hidden = NO;
        NSArray *items=[NSArray arrayWithObjects:
                        [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel  target:self action:@selector(clear)],
                        [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace  target:nil action:nil] ,
                        [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera  target:self action:@selector(shootPicture:)],
                        [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace  target:nil action:nil] ,
                        // [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace  target:nil action:nil] ,
                        [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(photoAlbum)],
                        nil];
        [toolBarCamera setItems:items];
        [imagePickerCamera.view addSubview:toolBarCamera];
        
        imagePickerCamera.delegate = self;
        
      //  imagePicker = imagePickerCamera;
        
        [self presentViewController:imagePickerCamera animated:YES completion:nil];
    }/*else if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
        imagePickerCamera.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imagePickerCamera animated:YES completion:nil];
    }*/
    
    
}


-(void)photoAlbum{
    
    if (imagePickerCamera.sourceType == UIImagePickerControllerSourceTypeCamera) {
            
            [toolBarCamera removeFromSuperview];       
    }
        imagePickerCamera.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
       [imagePickerCamera.navigationController presentViewController:imagePickerCamera animated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        [picker dismissViewControllerAnimated:YES completion:^{}];
        [self.navigationController popViewControllerAnimated:YES];
    }else
    [picker dismissViewControllerAnimated:YES completion:^{
         [self createPreview];
    }]; 
}


-(void)editPic{
    cropper.image = imageViewPreview.image;
    cropper.unscaledCrop = self.autoSnapRect;
    self.toolbar.hidden = NO;
    [self.toolbar setItems:croppingButtons animated:YES];
    [contentView addSubview:cropper];

    [UIView animateWithDuration:ANIMATION_DURATION animations:^{
        cropper.frame = contentView.bounds;
        cropper.alpha = 1.0;
    }];
    [self.imageViewPreview removeFromSuperview];
    [self destroyPreview];
}

-(void)usePic{
    CGFloat duration = .6;
    self.toolbar.hidden = NO;
    UIImage *newimage = [imageViewPreview image];

  //  newimage = [newimage rotateImage:newimage :1440];
    NSLog(@"rotate width %f  : height   %f",newimage.size.width,newimage.size.height) ;
    NSLog(@"rotate orientation:    %d",newimage.imageOrientation) ;

 //   newimage = [UIImage imageWithData:[[NSData alloc] initWithData:UIImageJPEGRepresentation(newimage, 80)]];

    imageView.frame = imageViewPreview.frame;
    
    [self.toolbar setItems:disabledButtons animated:YES];
    
    [UIView animateWithDuration:duration animations:^{
        self.image = newimage;
        
        //  NSLog(@"new original orientation: %d",newimage.imageOrientation);
    } completion:^(BOOL finished) {
        if (finished)
        {
            [self.toolbar setItems:disabledButtons animated:YES];
            
            [contentView addSubview:imageView];
            [UIView animateWithDuration:ANIMATION_DURATION animations:^{
                imageView.alpha = 1.0;
               
            } completion:^(BOOL finished) {
                if (finished)
                    [imageViewPreview removeFromSuperview];
            }];
            
            
            [self destroyPreview];
            
        }
    }];
}
- (void)destroyPreview
{
    [UIView animateWithDuration:.4 animations:^{
        overlayView.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished)
            [overlayView removeFromSuperview];
    }];
}

-(void)shootPicture:(id)sender{
    
    imagePickerCamera.showsCameraControls = NO;
    [imagePickerCamera takePicture];
  //  NSLog(@"take image!!");
    
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{ 
  //  NSLog(@"get image!!");
   UIImage *image = (UIImage*)[info objectForKey:UIImagePickerControllerOriginalImage];
    NSLog(@"---------Current image orientation: %d ---------",image.imageOrientation);
    image = [UIImage imageWithCGImage:image.CGImage scale:image.scale orientation:image.imageOrientation];
    NSLog(@"=====width: %f height: %f=====",image.size.width,image.size.height);
    NSLog(@"==========================UIImageOrientation===========================");
    NSLog(@"UIImageOrientationUp     %d",UIImageOrientationUp);
    NSLog(@"UIImageOrientationDown   %d",UIImageOrientationDown);
    NSLog(@"UIImageOrientationRight  %d",UIImageOrientationRight);
    NSLog(@"UIImageOrientationLeft   %d",UIImageOrientationLeft);
    NSLog(@"==========================UIImageOrientation===========================");
    NSLog(@"original orientation:    %d",image.imageOrientation) ;
    [imagePickerCamera dismissViewControllerAnimated:YES completion:^{
        [self take:image];
    }];
}


- (void)cancel
{
  /*  [self.toolbar  setItems:activeButtons animated:YES];
    [self destroyPreview];
    [imageView removeFromSuperview];
    [self createPreview];
        */
  //  [self respondsToSelector:@selector(scanDoc:)];
   // [self didRetake:self];
      //  [self.navigationController popViewControllerAnimated:YES];
    //[[self parentViewController] respondsToSelector:@selector(scanDoc:)];
    //[self.navigationController.nextResponder ];
  /*  [UIView animateWithDuration:ANIMATION_DURATION animations:^{
        imageView.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished){
            
            [imageView removeFromSuperview];
        }
    }];*/
    [imageViewPreview removeFromSuperview];

    [self createPreview];
    
    [self destroyPreview];
    
}


- (void)clear
{
  
   // CATransition *animation = [CATransition animation];
  //  animation.delegate = self;
  //  animation.duration = 0.3;
    
  //  animation.timingFunction = UIViewAnimationCurveEaseInOut;
   // animation.type = @"cameraIrisHollowClose";
   // [self.navigationController popToRootViewControllerAnimated:YES];
   // [imagePickerCamera.view.layer addAnimation:animation forKey:@"animation" ];
    
    [SVProgressHUD showWithStatus:@"please waiting..."];
    
  //  [self.navigationController removeFromParentViewController];
 
    
    [imagePickerCamera dismissViewControllerAnimated:YES completion:^{
        
    }];
    [self.navigationController popViewControllerAnimated:YES];
    
    [SVProgressHUD dismiss];
       //
  //  UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
  //  [self.navigationController.view.layer  addAnimation:animation forKey:@"animation"];
   // [storyboard instantiateViewControllerWithIdentifier:@"FirstScreen"];
   // [self.navigationController popViewControllerAnimated:YES];
  
}

- (void)take:(UIImage *)image
{
   self.toolbar.hidden = NO;
    
    //[captureManager captureStillImage:^(UIImage *image) {
        
        CGRect cropBounds = contentView.bounds;
        //cropBounds.origin.y -= contentView.frame.origin.y;
  //  NSLog(@"contentView bounds width %f---height %f",cropBounds.size.width,cropBounds.size.height);
  //  NSLog(@"contentView Frame width %f---height %f",contentView.frame.size.width,contentView.frame.size.height);

        CGRect windowFrame = [[UIApplication sharedApplication] keyWindow].frame;
        
        CGSize imageSize;
        imageSize.height = CGImageGetHeight(image.CGImage);
        imageSize.width = CGImageGetWidth(image.CGImage);
        
        CGFloat scale = imageSize.width / windowFrame.size.width;
        //// The image data is actually landscape.
        scale = imageSize.height / windowFrame.size.width;
        
        
        // Set this to the area of the image you want to have cropped.
        CGRect bounds = cropBounds;
        
        bounds = [contentView convertRect:bounds fromView:self.view];
        
        
        bounds.size.height *= scale;
        bounds.size.width *= scale;
        
        CGFloat diff = (contentView.bounds.size.height / 2 - cropBounds.origin.y);
        bounds.origin.y = (imageSize.width / 2) - diff * scale;
        
        bounds.origin.x *= scale;
        
        CGRect b2 = CGRectMake(bounds.origin.y, bounds.origin.x, bounds.size.height, bounds.size.width);
       // NSLog(@"width %f ----- height: %f",image.size.width,image.size.height);
        image = [image crop:b2];
       // NSLog(@"%d",image.imageOrientation);
    if (image.imageOrientation != UIImageOrientationRight) {

        if (image.size.height<image.size.width) {
           // NSLog(@"turn left");
            image = [UIImage imageWithCGImage:image.CGImage scale:image.scale orientation:UIImageOrientationRight];
        }
    }else{
           // NSLog(@"turn right");
            image = [UIImage imageWithCGImage:image.CGImage scale:image.scale orientation:image.imageOrientation];
            
       }
   // [image ro]
       image =[image rotateImage:image :1024];
        //[imageViewPreview removeFromSuperview];
        imageViewPreview = [[UIImageView alloc]initWithImage:image];
        imageViewPreview.frame = CGRectMake(0, 0, 320, 416) ;
        [self.toolbar setItems:useButtons animated:YES];
        [contentView addSubview:imageViewPreview];
        [self destroyPreview];
        
   // }];
   
    
}

-(void)viewWillAppear:(BOOL)animated{
    if (self.navigationController.navigationBarHidden == NO) {
     
        self.navigationController.navigationBarHidden = NO;
        self.navigationItem.rightBarButtonItem = doneButton;
        UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Document" style:UIBarButtonItemStyleBordered target:self action:@selector(backRoot)];
        backButtonItem.title = @"Document";
        self.navigationItem.backBarButtonItem = backButtonItem;
       
        [self.navigationItem.backBarButtonItem setAction:@selector(backRoot)];
    }
}
-(void)backRoot{
   
    [self.navigationController popToRootViewControllerAnimated:YES];
}



- (void)crop
{
    CGFloat duration = .6;
    self.toolbar.hidden = NO;
    UIImage *newimage = [cropper getCroppedImage];
   // NSLog(@"crop image orientation %d:",newimage.imageOrientation);
    imageView.frame = cropper.unscaledCrop;
 //   NSLog(@"%f--%f",imageView.frame.origin.x,imageView.frame.origin.y);
    [self.toolbar setItems:disabledButtons animated:YES];
     if (newimage.size.height < newimage.size.width) {
         if (newimage.imageOrientation == UIImageOrientationUp) 
            newimage = [UIImage imageWithCGImage:newimage.CGImage scale:newimage.scale orientation:UIImageOrientationLeft];
        }
    
    [UIView animateWithDuration:duration animations:^{
       
        self.image = newimage;
        cropper.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished)
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
            
           
                [self destroyPreview];
            
        }
    }];
    
    
    
}

#pragma mark - Properties

-(UIToolbar *)toolbar
{
    return _toolbar;
}

-(UINavigationBar *)navigationBar{
    return _navigationBar;
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
      //  NSLog(@"no image");
        [imageView removeFromSuperview];
        [imageView setFrame:contentView.bounds];
        [noImageLabel setFrame:contentView.bounds];
        [contentView addSubview:noImageLabel];
    } else
    {
        [noImageLabel removeFromSuperview];
        [imageView setFrame:contentView.bounds];
        [imageView setImage:image];
         //NSLog(@"image %f ------ %f",image.size.width,image.size.height);
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



- (void)done
{

    
  /*  NSURL *jsonURL =[NSURL URLWithString:@"http://173.15.239.213/screen/count.php"];
    NSData *jsonData = [NSData dataWithContentsOfURL:jsonURL];
    
    NSError *error;
    jsonCount = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];*/
    Database *countNum  = [[Database alloc]init];
    flagNumber = [countNum numberOfData];
   // flagNumber = [[numberFlag objectForKey:@"number"] intValue];
    if (flagNumber == 0) {
        actionSheet = [[UIActionSheet alloc]
                       initWithTitle:@"save to..."
                       delegate:self
                       cancelButtonTitle:@"Cancel"
                       destructiveButtonTitle:nil
                       otherButtonTitles:@"New Document",nil];
    }else{
        if ([addNewPic isEqualToString:@"isNotAddNewPic"]) {      
        actionSheet = [[UIActionSheet alloc]
                       initWithTitle:@"save to..."
                       delegate:self
                       cancelButtonTitle:@"Cancel"
                       destructiveButtonTitle:nil
                       otherButtonTitles:@"Existing Document",@"New Document",nil];
        }else if ([addNewPic isEqualToString:@"isAddNewPic"]){
            actionSheet = [[UIActionSheet alloc]
                           initWithTitle:@"save to..."
                           delegate:self
                           cancelButtonTitle:@"Cancel"
                           destructiveButtonTitle:nil
                           otherButtonTitles:@"Current Document",@"Existing Document",@"New Document",nil];
        }
    }
    
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showInView:self.view];
    
    
}






-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (flagNumber ==0) {
        if (buttonIndex == 0) {
            [SVProgressHUD showWithStatus:@"Please wait.."];
        }else if (buttonIndex == 1) {
            //[self showAlert:@"cancel"];
        }
        
    }else{
         if ([addNewPic isEqualToString:@"isNotAddNewPic"]) { 
        if (buttonIndex == 0) {
            [SVProgressHUD showWithStatus:@"Please wait.."];
                 }else if (buttonIndex == 1) {
             [SVProgressHUD showWithStatus:@"Please wait.."];
                }else if (buttonIndex == 2) {
          
                }
         }else if ([addNewPic isEqualToString:@"isAddNewPic"]){
             if (buttonIndex == 0) {
                 [SVProgressHUD showWithStatus:@"Please wait.."];
             }else if (buttonIndex == 1) {
                 [SVProgressHUD showWithStatus:@"Please wait.."];
             }else if (buttonIndex == 2) {
                 [SVProgressHUD showWithStatus:@"Please wait.."];
             }else if (buttonIndex == 3) {
             }

         }
    }
    
}


- (void)actionSheetCancel:(UIActionSheet *)actionSheet{
    
}
-(IBAction)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (flagNumber == 0) {
        if (buttonIndex == 0) {
            NSDate *filenametag = [NSDate date];
            tagTime = filenametag;
            dataInsert =[[Database alloc]init];
            [dataInsert insertData:filenametag:filenametag:@"1"];
            wifiReach=[Reachability reachabilityForInternetConnection];
            [wifiReach startNotifier];
            if ([wifiReach currentReachabilityStatus]!= NotReachable) {
            [self uploadImageInfo:filenametag :@"imagesupload"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"new" object:self];
            dispatch_queue_t queue;
            queue =  dispatch_queue_create("ocm", NULL);
            dispatch_async(queue, ^{
              /*  [self uploadPic:UIImagePNGRepresentation([[UIImage alloc] imageWithImage:self.image scaledToSizeWithSameAspectRatio:CGSizeMake(120, 160) ]) :filenametag:YES];*/
                [UploadPDF uploadPic:[PDFImageConverter convertImageToPDF:self.image]:filenametag];
                dispatch_async(dispatch_get_main_queue(), ^{
                 //  [[NSNotificationCenter defaultCenter] postNotificationName:@"UPLOAD_DOWN"  object:self];
                });
            });
                
               
            }else{
                [self cachePDF:filenametag];
            }
            [wifiReach stopNotifier];
            
            [SVProgressHUD dismiss];

             [self.navigationController popViewControllerAnimated:YES];
        }else if (buttonIndex == 1) {
            //[self showAlert:@"cancel"];
        }

    }else{
        if ([addNewPic isEqualToString:@"isNotAddNewPic"]) { 
        if (buttonIndex == 0) {
  
            [self performSegueWithIdentifier:@"merge" sender:self];
            [SVProgressHUD dismiss];
        
        }else  if (buttonIndex == 1) {
            
            NSDate *filenametag = [NSDate date];
            tagTime = filenametag;
            dataInsert =[[Database alloc]init];
            [dataInsert insertData:filenametag:filenametag:@"1"];
             
            wifiReach=[Reachability reachabilityForInternetConnection];
            [wifiReach startNotifier];
            if ([wifiReach currentReachabilityStatus]!= NotReachable) {
                [self uploadImageInfo:filenametag :@"imagesupload"];
                
                
                dispatch_queue_t queue;
                queue =  dispatch_queue_create("o1cm", NULL);
                dispatch_async(queue, ^{
                    /*  [self uploadPic:UIImagePNGRepresentation([[UIImage alloc] imageWithImage:self.image scaledToSizeWithSameAspectRatio:CGSizeMake(120, 160) ]) :filenametag:YES];*/
                    [UploadPDF uploadPic:[PDFImageConverter convertImageToPDF:self.image]:filenametag];
                    
                    //    [self uploadPic:UIImagePNGRepresentation(self.image) :filenametag];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //  [[NSNotificationCenter defaultCenter] postNotificationName:@"UPLOAD_DOWN"  object:self];
                    });
                });
                
                
            }else{
                [self cachePDF:filenametag];
            }
            
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"new" object:self];
            [wifiReach stopNotifier];
            
           
            [SVProgressHUD dismiss];
             [self.navigationController popViewControllerAnimated:YES];

        }else if (buttonIndex == 2) {
           
        }
    }else if ([addNewPic isEqualToString:@"isAddNewPic"]){
             if (buttonIndex == 0) {
                 NSDate *filenametag = [NSDate date];
                 tagTime = filenametag;
                 dataInsert =[[Database alloc]init];
                 [dataInsert insertData:filenametag:imageTag:@"1"];
                 
                 dispatch_queue_t queue1;
                 queue1 =  dispatch_queue_create("o1cm", NULL);
                 dispatch_async(queue1, ^{
                    
                     dispatch_async(dispatch_get_main_queue(), ^{
                                                 
                         [[NSNotificationCenter defaultCenter] postNotificationName:@"UPDATE_CURRENT"  object:self];
                         
                     });
                 });
                 
                 wifiReach=[Reachability reachabilityForLocalWiFi];
                 [wifiReach startNotifier];
                 if ([wifiReach currentReachabilityStatus] != NotReachable) {
                
                  
 
                
                  [self uploadImageInfo:imageTag:filenametag:@"imagesuploadexist":NO];
                 dispatch_queue_t queue;
                 queue =  dispatch_queue_create("ocm", NULL);
                 dispatch_async(queue, ^{
                   //  [self uploadPic:UIImagePNGRepresentation([[UIImage alloc] imageWithImage:self.image scaledToSizeWithSameAspectRatio:CGSizeMake(120, 160) ]) :filenametag:YES];
                    // [self uploadPic:UIImagePNGRepresentation(self.image):filenametag:NO];
                     dispatch_async(dispatch_get_main_queue(), ^{
                          //[self uploadImageInfo:imageTag:filenametag:@"imagesuploadexist"];
                     //  [[NSNotificationCenter defaultCenter] postNotificationName:@"UPLOAD_DOWN" object:self];
                     });
                 });
                 }else{
                     [self cachePDF:filenametag];
                 }
                 [wifiReach stopNotifier];
               
                 
                // [imagePickerCamera dismissViewControllerAnimated:NO completion:nil];
                // [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                 [self.navigationController popViewControllerAnimated:YES];
                 [SVProgressHUD dismiss];
                 
             }else  if (buttonIndex == 1) {
                  
                 [self performSegueWithIdentifier:@"chooseFile" sender:self];
                 [SVProgressHUD dismiss];
                                 
             }else if (buttonIndex == 2) {
                 NSDate *filenametag = [NSDate date];
                 tagTime = filenametag;
               //  NSLog(@"add new pic from folder : %@",tagTime);
                 dataInsert =[[Database alloc]init];
                 [dataInsert insertData:filenametag:filenametag:@"1"];
                 dispatch_queue_t queue1;
                 queue1 =  dispatch_queue_create("o1cm", NULL);
                 dispatch_async(queue1, ^{
                    
                     dispatch_async(dispatch_get_main_queue(), ^{
                        
                         
                         [[NSNotificationCenter defaultCenter] postNotificationName:@"UPDATE_CURRENT"  object:self];
                         
                     });
                 });
                 
                 wifiReach=[Reachability reachabilityForLocalWiFi];
                 [wifiReach startNotifier];
                 if ([wifiReach currentReachabilityStatus] != NotReachable) {
                 
                
                 [self uploadImageInfo:filenametag:@"imagesupload"];
                 dispatch_queue_t queue;
                 queue =  dispatch_queue_create("ocm", NULL);
                 dispatch_async(queue, ^{
                 //    [self uploadPic:UIImagePNGRepresentation(self.image) :filenametag:NO];
                   //  [self uploadPic:UIImagePNGRepresentation([[UIImage alloc] imageWithImage:self.image scaledToSizeWithSameAspectRatio:CGSizeMake(120, 160) ]) :filenametag:YES];
                     dispatch_async(dispatch_get_main_queue(), ^{
                          
                         [[NSNotificationCenter defaultCenter] postNotificationName:@"UPLOAD_DOWN" object:self];
                     });
                 });
                 }else{
                     [self cachePDF:filenametag];
                 }
                 [wifiReach stopNotifier];
               ///  NSLog(@"saveNewFile2");
                // [self performSegueWithIdentifier:@"saveNewFile" sender:self];
                 [self.navigationController popViewControllerAnimated:YES];
                 [SVProgressHUD dismiss];

             }
         }
    }
}

-(void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex{
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([[segue identifier] isEqualToString:@"chooseFile"]){
    //   ExistingCollectionViewController *destCollectionView = [segue destinationViewController];
       // destCollectionView.existOrMove = @"fromExistFile";
      //  destCollectionView.imageDataForSave = UIImagePNGRepresentation(self.image);
    }else if([[segue identifier]isEqualToString:@"saveNewFile"]){
      //  CustomerTableViewController *customer = (CustomerTableViewController *)[segue destinationViewController];
     //   customer.isMoveFile = @"FromNewTackPic";
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd-HH:mm:ss"];
        
       // customer.imagetag =[[NSString alloc]initWithString:[dateFormatter stringFromDate:tagTime]];
        
        [dateFormatter setDateFormat:@"yyyyMMddhhmmss"];
      //  customer.headLabelText = [[NSString alloc]initWithString:[dateFormatter stringFromDate:tagTime]];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
      //  customer.subHeadLabelText = [[NSString alloc]initWithString:[dateFormatter stringFromDate:tagTime]];
    }else if ([[segue identifier] isEqualToString:@"merge"]){
      PDFCollectionViewController *pdfCollectionView  =  [segue destinationViewController];
        pdfCollectionView.existFile=@"exist";
        pdfCollectionView.pdfData=[PDFImageConverter convertImageToPDF:self.image];
    }
}


-(void)uploadImageInfo:(NSDate *)filenametag:(NSString *)phplink{
    NSDateFormatter *formatter1 =[[NSDateFormatter alloc] init] ;
    [formatter1 setDateFormat:@"yyyyMMddHHmmss"];
    NSString *imagePath =@"http://173.15.239.213/PDF/PDFS/";
    imagePath =[imagePath stringByAppendingFormat:@"%@.PDF",[formatter1 stringFromDate:filenametag]];
   // NSLog(@"upload info%@",imagePath);
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd-HH:mm:ss"];
    NSString *urlString2 = @"http://173.15.239.213/PDF/";
    urlString2 = [urlString2 stringByAppendingFormat:@"%@.php?tag=%@&filename=%@&page=1",phplink,[formatter stringFromDate:filenametag],[formatter1 stringFromDate:filenametag]];
   // NSLog(@"%@",urlString2);
    NSURL *moveImageURL = [NSURL URLWithString:urlString2];
    NSMutableURLRequest *updateimageinfo = [[NSMutableURLRequest alloc]initWithURL:moveImageURL];
        
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:updateimageinfo delegate:self startImmediately:NO];
    [connection start];
    
    [PDFImageConverter WriteToLocal:[PDFImageConverter convertImageToPDF:self.image] withPDFName:imagePath];
  //  NSLog(@"upload info %@",imagePath);
    [[SDImageCache sharedImageCache] storeImage:[RetrievePDFData Scaleimage:self.image TargetSize:CGSizeMake(77, 106)]  forKey:imagePath toDisk:YES];
  }

-(void)cachePDF:(NSDate*)filename{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString *imagePath;
   
        imagePath =@"http://173.15.239.213/PDF/PDFS/";
        imagePath =[imagePath stringByAppendingFormat:@"%@.PDF",[dateFormatter stringFromDate:filename]];
        dataInsert = [[Database alloc]init];
        FMDatabase *updateinfo =[FMDatabase databaseWithPath:[dataInsert getPath]];
        if (![updateinfo open]) {
            NSLog(@"no available database!");
        }
        [updateinfo executeUpdate:@"update pdfData set uploaded='NO' where filepath=?",imagePath];
     
        [dateFormatter setDateFormat:@"yyyy-MM-dd-HH:mm:ss"];
        [PDFImageConverter WriteToLocal:[PDFImageConverter convertImageToPDF:self.image] withPDFName:imagePath];
}

-(void)uploadImageInfo:(NSString*)tagTimeq:(NSDate *)filenametag:(NSString *)phplink:(BOOL)thumbnail{
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString *imagePath =@"http://173.15.239.213/PDF/PDFS/";
    if (thumbnail==NO) {
        imagePath =[imagePath stringByAppendingFormat:@"%@.PDF",[formatter stringFromDate:filenametag]];
        NSString *urlString2 = @"http://173.15.239.213/PDF/";
        urlString2 = [urlString2 stringByAppendingFormat:@"%@.php?tag=%@&filename=%@",phplink,tagTimeq,[formatter stringFromDate:filenametag]];
        //   NSLog(@"%@",urlString2);
        NSURL *moveImageURL = [NSURL URLWithString:urlString2];
        NSMutableURLRequest *updateimageinfo = [[NSMutableURLRequest alloc]initWithURL:moveImageURL];
        
        NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:updateimageinfo delegate:self startImmediately:NO];
        [connection start];
    }
    
   // [[SDImageCache sharedImageCache] storeImage:self.image  forKey:imagePath toDisk:YES];
}

-(void)uploadPic:(NSData *)imageData:(NSDate *)filenametag{
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd-HH:mm:ss"];
    NSString *urlString = @"http://173.15.239.213/PDF/upload.php";    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    NSDateFormatter *formatter1 =[[NSDateFormatter alloc] init] ;
    [formatter1 setDateFormat:@"yyyyMMddHHmmss"];
     NSString *te = [@"Content-Disposition: form-data; name=\"pdf\"; filename=\"" stringByAppendingString:[formatter1 stringFromDate:filenametag]];
    te =  [te stringByAppendingString:@"\"\r\n"];
    NSMutableData *body = [NSMutableData data];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:te,index] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: application/pdf\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:imageData]];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
      [request setHTTPBody:body];
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    NSLog(@"%@",returnString);
}


- (void)didReceiveMemoryWarning
{
    [self.navigationController removeFromParentViewController];
  //  [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    [super didReceiveMemoryWarning ];

    
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


@end
