//
//  NSString+URLEncoding.m
//  cdsPayment
//
//  Created by Ajit Randhawa on 7/2/12.
//  Copyright (c) 2012 Ajit Randhawa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSString+URLEncoding.h"


@implementation NSString (URLEncoding)
-(NSString *)urlEncodeUsingEncoding:(NSStringEncoding)encoding {
    
    CFStringRef cfstring = CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                   (__bridge CFStringRef)self,
                                                                   NULL,
                                                                   (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",
                                                                   CFStringConvertNSStringEncodingToEncoding(encoding));
    NSString *nsstring = [NSString stringWithString:(__bridge NSString *)cfstring];
    CFRelease(cfstring);
	return nsstring;
}
@end