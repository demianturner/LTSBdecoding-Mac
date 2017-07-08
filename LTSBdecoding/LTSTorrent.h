//
//  LTSTorrent.h
//  LTSBdecoding
//
//  Created by Demian Turner on 07/07/2017.
//  Copyright © 2017 Demian Turner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LTSTorrentFile.h"

@interface LTSTorrent : NSObject

@property (nonatomic, strong) NSString *filename;
@property (nonatomic, strong) NSDate *dateCreated;
@property (nonatomic, strong) NSString *clientAuthorName;
@property (nonatomic, strong) NSString *comment;
@property (nonatomic, strong) NSURL *trackerURL;
@property (nonatomic, strong) NSArray<LTSTorrentFile *> *files;

- (instancetype)initWithFileURL:(NSURL *)url;

@end
