//
//  LTSBencoder.m
//  LTSBdecoding
//
//  Created by Demian Turner on 07/07/2017.
//  Copyright © 2017 Demian Turner. All rights reserved.
//

#import "LTSBencoder.h"

@implementation LTSBencoder

#pragma mark - Encoding

+ (NSData *)encodePrimitive:(id)object
{
    NSMutableData *data = [NSMutableData data];
    char buffer[32];
    
    memset(buffer, 0, sizeof(buffer));
    
    if ([object isKindOfClass:[NSData class]])
    {
        snprintf(buffer, 32, "%lu:", (unsigned long)[object length]);
        
        [data appendBytes:buffer length:strlen(buffer)];
        [data appendData:object];
        
        return data;
    }
    if ([object isKindOfClass:[NSString class]])
    {
        NSData *stringData = [object dataUsingEncoding:NSUTF8StringEncoding];
        snprintf(buffer, 32, "%lu:", (unsigned long)[stringData length]);
        
        [data appendBytes:buffer length:strlen(buffer)];
        [data appendData:stringData];
        
        return data;
    }
    else if ([object isKindOfClass:[NSNumber class]])
    {
        snprintf(buffer, 32, "i%llue", [object longLongValue]);
        
        [data appendBytes:buffer length:strlen(buffer)];
        
        return data;
    }
    else if ([object isKindOfClass:[NSArray class]])
    {
        [data appendBytes:"l" length:1];
        
        for (id item in object) {
            [data appendData:[LTSBencoder encodePrimitive:item]];
        }
        
        [data appendBytes:"e" length:1];
        
        return data;
    }
    else if ([object isKindOfClass:[NSDictionary class]])
    {
        [data appendBytes:"d" length:1];
        
        NSArray *sortedKeys = [[object allKeys] sortedArrayUsingComparator:(NSComparator)^(id obj1, id obj2) {
            return [obj1 compare:obj2 options:NSLiteralSearch];
        }];
        
        for (id key in sortedKeys) {
            NSData *stringData = [key dataUsingEncoding:NSUTF8StringEncoding];
            snprintf(buffer, 32, "%lu:", (unsigned long)[stringData length]);
            
            [data appendBytes:buffer length:strlen(buffer)];
            [data appendData:stringData];
            [data appendData:[LTSBencoder encodePrimitive:[object objectForKey:key]]];
        }
        
        [data appendBytes:"e" length:1];
        return data;
    }
    
    return nil;
}

@end
