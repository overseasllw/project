//
//  DVPictureBox.h
//  cdsPayment
//
//  Created by Ajit Randhawa on 7/24/12.
//  Copyright (c) 2012 Ajit Randhawa. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CaptureSessionManager.h"

typedef enum
{
    DVPictureBoxStateDisabled, // The camera is not active, the view shows a static picture.
    DVPictureBoxStateActive,    // The camera is active, a "cancel" button is shown
    DVPictureBoxStateCropping
} DVPictureBoxState;

@class DVPictureBox;

@protocol DVPictureBoxDelegate <NSObject>

- (void)pictureBox:(DVPictureBox *)box
   imageWasChanged:(UIImage *)newImage;
- (void)pictureBoxDoneEditing:(DVPictureBox *)box;

@end

@interface DVPictureBox : UIView<UIActionSheetDelegate>
{
    DVPictureBoxState _state;
    
    UIImage *_image;
    
    id<DVPictureBoxDelegate> _delegate;
    
    CaptureSessionManager *captureManager;
    
    UIActionSheet *actionSheet;
    
    NSMutableArray *jsonCount;
    NSInteger flagNumber;
    NSMutableDictionary *numberFlag;
}

- (void)clear;
- (void)change;
- (void)done;
- (void)cancel;
- (void)take;
- (void)crop;



@property DVPictureBoxState state;
@property (readonly) UIToolbar *toolbar;
@property UIImage *image;
@property id<DVPictureBoxDelegate> delegate;

@property CGRect autoSnapRect;

-(void)createPreview;
-(void)destroyPreview;

@end
