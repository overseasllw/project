//
//  DVImageInlineCell.m
//  cdsPayment
//
//  Created by Ajit Randhawa on 7/24/12.
//  Copyright (c) 2012 Ajit Randhawa. All rights reserved.
//

#import "DVImageInlineCell.h"
#import "DVPictureBox.h"
#import "../Server/DatabaseService.h"
#import "DVTableViewController.h"

@interface DVImageInlineCell ()
{
    DVPictureBox *box;
    UIImageView *imageView;
    
    NSString *_imageUrl;
}
@end

@implementation DVImageInlineCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        hiddenBounds = CGRectMake(0, 480, 320, 460);
        //visibleBounds = CGRectMake(0, 236, 320, 244);
        visibleBounds = CGRectMake(0, 20, 320, 460);
        //visibleBounds = CGRectMake(0, 20, 320, 380);
        
        float height = 68;
        
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(190, 10, height * 1.612, height)];
        [self addSubview:imageView];
        //imageView.backgroundColor = [UIColor redColor];
        imageView.image = [UIImage imageNamed:@"error"];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        
//        // We don't want to send the picture to the database the same time as everything else.
//        // Uploading the image relies on knowing the ID of the row to determine the directory the image will be uploaded to.
//        representedInDatabase = NO;
        
        self.representedInDatabase = YES;
        
        _scrollsToMakeCellVisible = NO;
    }
    return self;
}

-(UIView *)moveableView
{
    if (box != nil)
    {
//        box.toolbar.tintColor = self.controller.navigationController.navigationBar.tintColor;
        return box;
    }
    
    box = [[DVPictureBox alloc] initWithFrame:hiddenBounds];
    box.delegate = self;
    box.image = [self value];
    box.toolbar.tintColor = [UIColor colorWithIntRed:77 intGreen:77 intBlue:77];
    
    return box;
}

-(void)cellWillDisappear
{
    [box removeFromSuperview];
    box = nil;
    [super cellWillDisappear];
}

- (CGFloat)cellHeight
{
    return 88.0;
}

#pragma mark - Overrides

-(void)applyChangesForce:(BOOL)force
{
    [self.editingObject setValue:_value forKey:self.propertyName];
}

-(void)appendToDatabaseRequest:(DatabaseRequest *)request
{
    if (self.propertyName == nil)
        return;
    if (!self.modified)
        return;
    
    UIImage *image = (UIImage *)_value;
    if (image == nil)
    {
        return;
    }
    
    if (![image isKindOfClass:[UIImage class]])
        return;
    
    NSData *data = UIImageJPEGRepresentation(_value, 1);
    [request.files setValue:data forKey:self.propertyName];
}

-(void)objectWasSentToDatabase:(id)object withResults:(DatabaseAccessResult *)results withId:(int)rowId
{
    [super objectWasSentToDatabase:object withResults:results withId:rowId];
    
    return;
}

-(void)loadValueFromObject:(id)object
{
    // TODO: Load the image from an object being edited.
    imageView.image = nil;
}

- (void)cellWasSelected
{
    if (self.controller.cellForActivePicker != self)
    {
        box.image = imageView.image;
    }
    [super cellWasSelected]; 
}

- (void)hidePicker
{
    //[box setState:DVPictureBoxStateDisabled ];
    [super hidePicker];
}

#pragma mark - DVPictureBoxDelegate Methods

-(void)pictureBox:(DVPictureBox *)box imageWasChanged:(UIImage *)newImage
{
//    imageView.image = newImage;
//    _value = newImage;
    self.value = newImage;
    _value = newImage;
    self.modified = YES;
}
    
-(void)pictureBoxDoneEditing:(DVPictureBox *)box
{
    [self hidePicker];
}

#pragma mark - Overrides

-(void)setValue:(id)value
{
    BOOL isNull = NO;
    if (value == nil)
        isNull = YES;
    if ([value isKindOfClass:[NSString class]])
    {
        if ([value length] == 0)
            isNull = YES;
        else if ([value isEqualToString:@"none"])
            isNull = YES;
    }
    
    if (isNull)
    {
//        if (_value != nil)
//            self.modified = YES;
        _value = nil;
        imageView.image = nil;
        box.image = nil;
        self.detailTextLabel.text = @"(none)";
        self.isInPlaceholderState = YES;
        [self setNeedsDisplay];
        return;
    }
    
    if ([value isKindOfClass:[NSString class]])
    {
//        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:value]];
//        UIImage *img = [UIImage imageWithData:data];
//        if (img != nil && [img isKindOfClass:[UIImage class]])
//            value = img;
        return;
    }
        
    _value = value;
    //self.modified = YES;
    imageView.image = value;
    box.image = value;
    self.detailTextLabel.text = @" ";
    [self setNeedsDisplay];
}

@end
