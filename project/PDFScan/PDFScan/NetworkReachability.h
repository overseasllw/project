//
//  NetworkReachability.h
//  TakeCaptureViewPic
//
//  Created by Liwei Lin on 10/23/12.
//  Copyright (c) 2012 Ajit Randhawa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"
@class Reachability;
@interface NetworkReachability : NSObject{
    Reachability* wifiReach;
}
- (void) reachabilityChanged: (NSNotification* )note;
-(NetworkStatus )NetworkReachability;
@end
