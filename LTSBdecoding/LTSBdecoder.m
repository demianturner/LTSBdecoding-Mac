//
//  LTSBdecoder.m
//  LTSBdecoding
//
//  Created by Demian Turner on 07/07/2017.
//  Copyright © 2017 Demian Turner. All rights reserved.
//

#import "LTSBdecoder.h"
#import "LTSEncodingData.h"

@implementation LTSBdecoder

#pragma mark - Decoding

- (NSDictionary *)decode:(NSData *)data
{
    id res = [LTSBdecoder decodePrimitiveWithData:data];
    NSDictionary *dict = (NSDictionary *)res;
    return dict;
}

+ (NSNumber *)decodeNumberWithData:(LTSEncodingData *)data
{
	NSMutableString *numberString = [NSMutableString string];
	long long int number;
	
	assert(data.bytes[data.offset] == 'i');
	
	data.offset++;
	
	while (data.offset < data.length && data.bytes[data.offset] != 'e') {
		[numberString appendFormat:@"%c", data.bytes[data.offset++]];
	}
	
    if (![[NSScanner scannerWithString:numberString] scanLongLong:&number]) {
        return nil;
    }
		
	
	data.offset++;
	
	return [NSNumber numberWithLongLong:number];
}

+ (NSString *)decodeStringWithData:(LTSEncodingData *)data
{
    id decodedData = [self decodeWithData:data];
    
    if (decodedData == nil) {
        return nil;
    }
    
    if ([decodedData isKindOfClass:[NSString class]]) {
        return decodedData;
    }
    
    return [NSString stringWithCString:[decodedData bytes] encoding:NSUTF8StringEncoding];
}

+ (id)decodeWithData:(LTSEncodingData *)data
{
    NSMutableString *dataLength = [NSMutableString string];
    NSMutableData *decodedValue = [NSMutableData data];
    
    if (data.bytes[data.offset] < '0' | data.bytes[data.offset] > '9') {
        return nil;
    }
    
    while (data.offset < data.length && data.bytes[data.offset] != ':') {
        [dataLength appendFormat:@"%c", data.bytes[data.offset++]];
    }
    
    if (data.bytes[data.offset] != ':') {
        return nil;
    }
    
    data.offset++;
    
    [decodedValue appendBytes:data.bytes + data.offset length:[dataLength integerValue]];
    [decodedValue increaseLengthBy:1];
    data.offset += [dataLength integerValue];
    
    return [NSString stringWithCString:[decodedValue bytes] encoding:NSUTF8StringEncoding];
}

+ (NSArray *)decodeListWithData:(LTSEncodingData *)data
{
    NSMutableArray *array = [NSMutableArray array];
    
    assert(data.bytes[data.offset] == 'l');
    
    data.offset++;
    
    while (data.bytes[data.offset] != 'e') {
        [array addObject:[LTSBdecoder primitiveFromData:data]];
    }
    
    data.offset++;
    
    return array;
}

+ (OrderedDictionary *)decodeDictionaryWithData:(LTSEncodingData *)data
{
	OrderedDictionary *dictionary = [OrderedDictionary dictionary];
	NSString *key = nil;
	id value = nil;
	
	assert(data.bytes[data.offset] == 'd');
	
	data.offset++;
	
	while (data.bytes[data.offset] != 'e') {
		if (data.bytes[data.offset] >= '0' && data.bytes[data.offset] <= '9') {

			key = [LTSBdecoder decodeStringWithData:data];
            if (key) {
                [data.keyStack addObject:key];
            }
			
			value = [LTSBdecoder primitiveFromData:data];
            if (key != nil && value != nil) {
                [dictionary setValue:value forKey:key];
            }
			
            if (key) {
                [data.keyStack removeLastObject];
            }
		}
	}

	data.offset++;
	
	return dictionary;
}

+ (id)decodePrimitiveWithData:(NSData *)inputData
{
    LTSEncodingData *data = [[LTSEncodingData alloc] init];
    data.bytes = [inputData bytes];
    data.length = [inputData length];
    data.offset = 0;
    data.keyStack = [NSMutableArray array];
    
    return [LTSBdecoder primitiveFromData:data];
}

+ (id)primitiveFromData:(LTSEncodingData *)data
{
	switch (data.bytes[data.offset]) {
	case 'l':
		return [LTSBdecoder decodeListWithData:data];
		break;
	case 'd':
		return [LTSBdecoder decodeDictionaryWithData:data];
		break;
	case 'i':
		return [LTSBdecoder decodeNumberWithData:data];
		break;
	default:
		if (data.bytes[data.offset] >= '0' && data.bytes[data.offset] <= '9')
            return [LTSBdecoder decodeWithData:data];
		break;
	}
	
	data.offset++;
	return nil;
}

@end
