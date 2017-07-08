//
//  LTSTorrentParser.h
//  LTSBdecoding
//
//  Created by Demian Turner on 07/07/2017.
//  Copyright © 2017 Demian Turner. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LTSTorrentParser : NSObject

- (instancetype)initWithData:(NSData *)data;
- (NSDictionary *)decode;

@end
