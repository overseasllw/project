//
//  NetworkReachability.m
//  TakeCaptureViewPic
//
//  Created by Liwei Lin on 10/23/12.
//  Copyright (c) 2012 Ajit Randhawa. All rights reserved.
//

#import "NetworkReachability.h"
#import "Reachability.h"
@implementation NetworkReachability
- (void) reachabilityChanged: (NSNotification* )note
{
	Reachability* curReach = [note object];
	NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    NSLog(@"reachablity");
    //	[self updateInterfaceWithReachability: curReach];
}

-(NetworkStatus )NetworkReachability{
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(reachabilityChanged:) name: kReachabilityChangedNotification object: nil];
    wifiReach = [Reachability reachabilityForLocalWiFi] ;
	[wifiReach startNotifier];
    NetworkStatus netStatus = [wifiReach currentReachabilityStatus];
    [wifiReach connectionRequired];
  //  BOOL connectionRequired= 
    NSLog(@"%u",netStatus);
   // NSLog(@"%d",connectionRequired);
    return netStatus;
}
-(Reachability*) getReachability{
    wifiReach = [Reachability reachabilityForLocalWiFi];
    return wifiReach;
}
@end
