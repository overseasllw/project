//
//  QRObjectEncoder.h
//  cdsPayment
//
//  Created by Ajit Randhawa on 8/7/12.
//  Copyright (c) 2012 Ajit Randhawa. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface QRObject : NSObject

@property (readonly) NSString *type;
@property (readonly) NSDictionary *data;

-(NSString *)valueForKey:(NSString *)key;
-(NSString *)valueForKey:(NSString *)key
               orDefault:(NSString *)defaultValue;

-(UIImage *)qrImageOfSize:(int)size;

- (id)initWithDatatype:(NSString *)type
              contents:(NSDictionary *)dictionary;

@end


@interface QRObjectEncoder : NSObject

+ (NSString *)stringForObjectOfType:(NSString *)type
                             values:(NSDictionary *)values;
+ (NSString *)stringForQRObject:(QRObject *)object;
+ (QRObject *)objectFromString:(NSString *)originalData;

@end
