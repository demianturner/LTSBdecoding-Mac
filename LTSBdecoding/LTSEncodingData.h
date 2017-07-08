//
//  LTSEncodingData.h
//  LTSBdecoding
//
//  Created by Demian Turner on 07/07/2017.
//  Copyright © 2017 Demian Turner. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LTSEncodingData : NSObject

@property (nonatomic, assign) NSUInteger length;
@property (nonatomic, assign) NSUInteger offset;
@property (nonatomic, assign) const char *bytes;
@property (nonatomic, strong) NSMutableArray *keyStack;

@end
