//
//  LTSTorrentFile.h
//  LTSBdecoding
//
//  Created by Demian Turner on 07/07/2017.
//  Copyright © 2017 Demian Turner. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LTSTorrentFile : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSNumber *length;
@property (nonatomic, strong) NSString *checksum;

@end
