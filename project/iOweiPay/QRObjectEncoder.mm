//
//  QRObjectEncoder.m
//  cdsPayment
//
//  Created by Ajit Randhawa on 8/7/12.
//  Copyright (c) 2012 Ajit Randhawa. All rights reserved.
//

#import "QRObjectEncoder.h"
#import "Libraries/QREncoder/QREncoder.h"
#import <Foundation/NSJSONSerialization.h>

@interface QRObject ()
{
    NSString *_type;
    NSDictionary *_dictionary;
}

@end

@implementation QRObject

-(NSString *)type
{
    return _type;
}

-(NSDictionary *)data
{
    return _dictionary;
}

- (id)initWithDatatype:(NSString *)type
              contents:(NSDictionary *)dictionary
{
    self = [super init];
    if (self)
    {
        _type = type;
        _dictionary = dictionary;
    }
    return self;
}

- (NSString *)valueForKey:(NSString *)key
{
    return [self valueForKey:[key uppercaseString] orDefault:nil];
}

-(NSString *)valueForKey:(NSString *)key orDefault:(NSString *)defaultValue
{
    id val = [_dictionary valueForKey:[key uppercaseString]];
    if (val != nil && ([val length] > 0))
        return [val description];
    return defaultValue;
}

-(UIImage *)qrImageOfSize:(int)size
{
    DataMatrix *data = [QREncoder encodeWithECLevel:QR_ECLEVEL_AUTO version:QR_VERSION_AUTO string:[QRObjectEncoder stringForQRObject:self]];
    UIImage *image = [QREncoder renderDataMatrix:data imageDimension:size];
    return image;
}

@end

@implementation QRObjectEncoder

+ (NSString *)stringForObjectOfType:(NSString *)type values:(NSDictionary *)values
{
    if (values == nil)
    {
        return @"";
    }
    
    NSMutableDictionary *d = [values mutableCopy];
    
    for (NSString *key in d.allKeys)
    {
        [d setValue:[[d valueForKey:key] description] forKey:key];
    }
    
    [d setValue:type forKey:@"DATATYPE"];
    
    NSMutableString *output = [[NSMutableString alloc] init];
    
    NSData *outData = [NSJSONSerialization dataWithJSONObject:d options:NSJSONWritingPrettyPrinted error:nil];
    
    [output appendString:[[NSString alloc] initWithData:outData encoding:NSUTF8StringEncoding]];
    
    return [output description];
}

+ (NSString *)stringForQRObject:(QRObject *)object
{
    return [QRObjectEncoder stringForObjectOfType:object.type values:object.data];
}

+ (QRObject *)objectFromString:(NSString *)originalData
{
    // TODO: If reading the json string doesn't work, try interpreting it as normal QR code data (or use ZXing for that?)
    id data = [NSJSONSerialization JSONObjectWithData:[originalData dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
    NSString *type = [data valueForKey:@"DATATYPE"];
    [data removeObjectForKey:@"DATATYPE"];
    
    return [[QRObject alloc] initWithDatatype:type contents:data];
}

@end
