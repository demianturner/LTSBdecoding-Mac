//
//  LTSTorrent.m
//  LTSBdecoding
//
//  Created by Demian Turner on 07/07/2017.
//  Copyright © 2017 Demian Turner. All rights reserved.
//

#import "LTSTorrent.h"
#import "LTSBdecoder.h"

@interface LTSTorrent ()
@property (nonatomic, strong) LTSBdecoder *decoder;
@end

@implementation LTSTorrent

- (instancetype)initWithFileURL:(NSURL *)url {
    
    self = [super init];
    if (self) {
        
        _decoder = [[LTSBdecoder alloc] init];
        
        NSData *data = [NSData dataWithContentsOfURL:url];
        NSDictionary *dict = [self decodeData:data];
        
        if (![dict isKindOfClass:[NSDictionary class]]) {
            return nil;
        }
        
        self.filename = url.lastPathComponent;
        
        [self parseData:dict];
    }
    
    return self;
}

- (NSDictionary *)decodeData:(NSData *)data
{
    assert(data);
    NSDictionary *dict = [self.decoder decode:data];
    return dict;
}

- (void)parseData:(NSDictionary *)dict
{
    NSNumber *date = dict[@"creation date"];
    if (date) {
        self.dateCreated = [NSDate dateWithTimeIntervalSince1970:[date integerValue]];
    }
    
    NSString *author = dict[@"created by"];
    if (author) {
        self.clientAuthorName = author;
    }
    
    NSString *announce = dict[@"announce"];
    if (announce) {
        self.trackerURL = [NSURL URLWithString:announce];
    }
    
    NSString *comment = dict[@"comment"];
    if (comment) {
        self.comment = comment;
    }
    
    NSDictionary *info = dict[@"info"];
    if (info) {
        NSArray *files = info[@"files"];
        if (files) {
            NSMutableArray *results = [[NSMutableArray alloc] initWithCapacity:files.count];
            
            for (NSDictionary *fileDict in files) {
                LTSTorrentFile *file = [[LTSTorrentFile alloc] init];
                file.length = fileDict[@"length"];
                file.checksum = fileDict[@"md5sum"];
                
                NSArray *path = fileDict[@"path"];
                if (path) {
                    file.name = path.lastObject;
                }
                
                [results addObject:file];
            }
            
            self.files = results;
            
            return;
        }
        
        LTSTorrentFile *file = [[LTSTorrentFile alloc] init];
        file.name = info[@"name"];
        file.length = info[@"length"];
        file.checksum = info[@"md5sum"];
        
        self.files = @[file];
    }
}

- (NSString *)description
{
    NSMutableString *result = [NSMutableString string];
    
    [result appendString:@"[Info]\n\n"];
    
    if (self.dateCreated) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        [result appendString:[NSString stringWithFormat:@"Creation Date: %@\n", [formatter stringFromDate:self.dateCreated]]];
    }
    
    if (self.clientAuthorName) {
        [result appendString:[NSString stringWithFormat:@"Created by: %@\n", self.clientAuthorName]];
    }
    
    if (self.trackerURL) {
        [result appendString:[NSString stringWithFormat:@"Tracker URL: %@\n", self.trackerURL]];
    }
    
    if (self.files) {
        NSString *title = @"\n[File]\n\n";
        if (self.files.count > 1) {
            title = @"\n[Files]\n\n";
        }
        
        [result appendString:title];
    }
    for (LTSTorrentFile *file in self.files) {
        if (file.name) {
            [result appendString:[NSString stringWithFormat:@"Name: %@\n", file.name]];
        }
        if (file.length) {
            NSString *byteCount = [NSByteCountFormatter stringFromByteCount:file.length.integerValue countStyle:NSByteCountFormatterCountStyleFile];
            [result appendString:[NSString stringWithFormat:@"Length: %@\n", byteCount]];
        }
        if (file.checksum) {
            [result appendString:[NSString stringWithFormat:@"Checksum: %@\n", file.checksum]];
        }
        if (file.name || file.length || file.checksum) {
            [result appendString:@"\n"];
        }
    }
    
    return result;
}

@end
