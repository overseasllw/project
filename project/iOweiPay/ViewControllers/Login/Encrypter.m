//
//  Encrypter.m
//  loginMain2
//
//  Created by Ajit Randhawa on 7/16/12.
//  Copyright (c) 2012 Ajit Randhawa. All rights reserved.
//

#import "Encrypter.h"
#import <CommonCrypto/CommonDigest.h>

@implementation Encrypter

+(NSString*) sha2:(NSString *)clear{
    if ([clear length] < 1) {
        return nil;
    }
    const char *s=[clear cStringUsingEncoding:NSASCIIStringEncoding];
    NSData *keyData=[NSData dataWithBytes:s length:strlen(s)];
    
    uint8_t digest[CC_SHA256_DIGEST_LENGTH]={0};
    CC_SHA256(keyData.bytes, keyData.length, digest);
    NSData *out=[NSData dataWithBytes:digest length:CC_SHA256_DIGEST_LENGTH];
    NSString *hash=[out description];
    hash = [hash stringByReplacingOccurrencesOfString:@" " withString:@""];
    hash = [hash stringByReplacingOccurrencesOfString:@"<" withString:@""];
    hash = [hash stringByReplacingOccurrencesOfString:@">" withString:@""];
    return hash;
}


@end
