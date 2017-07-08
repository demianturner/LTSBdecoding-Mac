//
//  LTSBdecoder.h
//  LTSBdecoding
//
//  Created by Demian Turner on 07/07/2017.
//  Copyright © 2017 Demian Turner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OrderedDictionary.h"

@interface LTSBdecoder : NSObject

- (NSDictionary *)decode:(NSData *)data;

+ (id)decodePrimitiveWithData:(NSData *)inputData;


@end
