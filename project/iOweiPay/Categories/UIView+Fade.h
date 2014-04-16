//
//  UIView+Fade.h
//  cdsPayment
//
//  Created by Ajit Randhawa on 8/6/12.
//  Copyright (c) 2012 Ajit Randhawa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Fade)

- (void)addSubviewWithFade:(UIView *)view;
- (void)addSubviewWithFade:(UIView *)view
                  duration:(float)duration;
- (void)addSubviewWithFade:(UIView *)view
                  duration:(float)duration
                  newFrame:(CGRect)frame;
- (void)addSubviewWithFade:(UIView *)view
                  duration:(float)duration
                  newFrame:(CGRect)frame
                completion:(void (^)(void))completion;

- (void)removeFromSuperviewWithFade;
- (void)removeFromSuperviewWithFadeDuration:(float)duration;
- (void)removeFromSuperviewWithFadeDuration:(float)duration
                                   newFrame:(CGRect)frame;
- (void)removeFromSuperviewWithFadeDuration:(float)duration
                                   newFrame:(CGRect)frame
                                 completion:(void (^)(void))completion;

@end
