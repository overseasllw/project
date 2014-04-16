//
//  TakePictureViewController.h
//  TakeCaptureViewPic
//
//  Created by Ajit Randhawa on 8/22/12.
//  Copyright (c) 2012 Ajit Randhawa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CaptureSessionManager.h"
#import "Database.h"

@protocol ImageProcessDelegate;
@class Reachability;
@interface TakePictureViewController : UIViewController<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    
    UIImage *_image;
    UIActionSheet *actionSheet;
    UIImageView *imageViewPreview;
    NSMutableArray *jsonCount;
    NSInteger flagNumber;
    NSMutableDictionary *numberFlag;
    NSDate *tagTime;
    NSString *addNewPic;
    UIImage *imageViewTemp;
    NSString *imageTag;
    UIImagePickerController *imagePickerCamera;
    Database *dataInsert;
    Reachability *wifiReach;
   // UIImagePickerController *imagePicker;
}

- (void)clear;
- (void)done;
- (void)cancel;
- (void)take:(UIImage *)image;
- (void)crop;


@property (retain) UIImagePickerController *imagePickerCamera;
@property (retain,nonatomic) Database *dataInsert;
@property (retain) id<ImageProcessDelegate>delegate;
@property (readonly) UIToolbar *toolbar;
@property (nonatomic,retain) NSString *addNewPic;
@property (readonly) UINavigationBar *navigationBar;
@property (nonatomic,retain) NSString *imageTag;
@property (nonatomic,retain)UIImage *image;
@property (nonatomic,retain) NSDate *tagTime;
@property (nonatomic,retain)UIImageView *imageViewPreview;
//@property  UIBarButtonItem *doneButton;
@property (nonatomic,retain)UIImage *imageViewTemp;


@property CGRect autoSnapRect;

-(void)createPreview;
-(void)destroyPreview;
//-(void)cacheImage:(NSDate*)filename;
//-(void)takePic:(UIViewController*)parent image:(UIImage *)image delegate:(id<ImageProcessDelegate>)delegate;
@end
