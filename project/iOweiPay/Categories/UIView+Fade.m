//
//  UIView+Fade.m
//  cdsPayment
//
//  Created by Ajit Randhawa on 8/6/12.
//  Copyright (c) 2012 Ajit Randhawa. All rights reserved.
//

#import "UIView+Fade.h"

#define DEFAULT_FADE_TIME .4

@implementation UIView (Fade)

-(void)addSubviewWithFade:(UIView *)view
{
    [self addSubviewWithFade:view duration:DEFAULT_FADE_TIME];
}

-(void)addSubviewWithFade:(UIView *)view duration:(float)duration
{
    [self addSubviewWithFade:view duration:duration newFrame:view.frame];
}

-(void)addSubviewWithFade:(UIView *)view duration:(float)duration newFrame:(CGRect)frame
{
    [self addSubviewWithFade:view duration:duration newFrame:frame completion:nil];
}

-(void)addSubviewWithFade:(UIView *)view duration:(float)duration newFrame:(CGRect)frame completion:(void (^)(void))completion
{
    if (view.superview != nil)
        [view removeFromSuperview];
    view.alpha = 0.0;
    
    if (duration <= 0)
        duration = DEFAULT_FADE_TIME;
    
    [self addSubview:view];
    [UIView animateWithDuration:duration animations:^{
        view.alpha = 1.0;
        if (!CGRectEqualToRect(view.frame, frame) && !CGRectIsNull(frame))
        {
            view.frame = frame;
        }
    } completion:^(BOOL finished) {
        if (finished && (completion != nil))
        {
            completion();
        }
    }];
}

-(void)removeFromSuperviewWithFade
{
    [self removeFromSuperviewWithFadeDuration:DEFAULT_FADE_TIME];
}

-(void)removeFromSuperviewWithFadeDuration:(float)duration
{
    [self removeFromSuperviewWithFadeDuration:duration newFrame:self.frame];
}

-(void)removeFromSuperviewWithFadeDuration:(float)duration newFrame:(CGRect)frame
{
    [self removeFromSuperviewWithFadeDuration:duration newFrame:frame completion:nil];
}

-(void)removeFromSuperviewWithFadeDuration:(float)duration newFrame:(CGRect)frame completion:(void (^)(void))completion
{
    if (self.superview == nil)
        return;
    
    if (duration <= 0)
        duration = DEFAULT_FADE_TIME;
    
    [UIView animateWithDuration:duration animations:^{
        self.alpha = 0.0;
        if (!CGRectEqualToRect(self.frame, frame) && !CGRectIsNull(frame))
        {
            self.frame = frame;
        }
    } completion:^(BOOL finished) {
        if (finished)
        {
            [self removeFromSuperview];
            if (completion != nil)
                completion();
        }
    }];
}

@end
