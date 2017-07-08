//
//  LTSTorrentParser.m
//  LTSBdecoding
//
//  Created by Demian Turner on 07/07/2017.
//  Copyright © 2017 Demian Turner. All rights reserved.
//

#import "LTSTorrentParser.h"

@interface LTSTorrentParser ()

@property (nonatomic, strong) NSData *data;
@property (nonatomic, assign) int *pos;

@end

@implementation LTSTorrentParser

- (instancetype)initWithData:(NSData *)data
{
    self = [super init];
    if (self) {
        _data = data;
    }
    return self;
}

- (NSDictionary *)decode
{
    
}

@end
