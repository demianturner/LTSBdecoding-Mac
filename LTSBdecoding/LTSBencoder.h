//
//  LTSBencoder.h
//  LTSBdecoding
//
//  Created by Demian Turner on 07/07/2017.
//  Copyright © 2017 Demian Turner. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LTSBencoder : NSObject

+ (NSData *)encodePrimitive:(id)object;

@end
