//
//  NSString+URLEncoding.h
//  cdsPayment
//
//  Created by Ajit Randhawa on 7/2/12.
//  Copyright (c) 2012 Ajit Randhawa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (URLEncoding)
-(NSString *)urlEncodeUsingEncoding:(NSStringEncoding)encoding;
@end