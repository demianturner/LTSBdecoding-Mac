//
//  LTSBdecodingTests.m
//  LTSBdecodingTests
//
//  Created by Demian Turner on 07/07/2017.
//  Copyright © 2017 Demian Turner. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "LTSBdecoder.h"
#import "LTSBencoder.h"
#import "LTSTorrent.h"

@interface LTSBdecodingTests : XCTestCase

@end

@implementation LTSBdecodingTests

- (NSNumber *)prepareInt:(long long)inputInt
{
    long long int theInt = inputInt;
    NSNumber *num = [NSNumber numberWithLongLong:theInt];
    return num;
}

- (void)testNumbersWithInt
{
    int theInt = 1234;
    NSNumber *num = [self prepareInt:theInt];
    NSData *encodedData = [LTSBencoder encodePrimitive:num];
    id res = [LTSBdecoder decodePrimitiveWithData:encodedData];
    XCTAssertEqual(num, res);
}

- (void)testNumbersWithZero
{
    int theInt = 0;
    NSNumber *num = [self prepareInt:theInt];
    NSData *encodedData = [LTSBencoder encodePrimitive:num];
    id res = [LTSBdecoder decodePrimitiveWithData:encodedData];
    XCTAssertEqual(num, res);
}

- (void)xtestNumbersWithNegativeInt
{
    int theInt = -87;
    NSNumber *num = [self prepareInt:theInt];
    NSData *encodedData = [LTSBencoder encodePrimitive:num];
    id res = [LTSBdecoder decodePrimitiveWithData:encodedData];
    XCTAssertEqual(num, res);
}

- (void)testNumbersWithLong
{
    long theInt = 34957683495;
    NSNumber *num = [self prepareInt:theInt];
    NSData *encodedData = [LTSBencoder encodePrimitive:num];
    id res = [LTSBdecoder decodePrimitiveWithData:encodedData];
    XCTAssertEqual(num, res);
}

- (void)testWithBencodedTorrentString1
{
    NSDictionary *dict = @{
                           @"announce": @"",
                           @"creation date": @1488124129,
                           @"info": @{
                                   @"length": @59006272,
                                   @"md5sum": @"5861fff0e082cabbfff6ae5532765f57",
                                   @"name" : @"QQ8.7.exe",
                                   @"piece length" : @131072
                                   },
                           };
    NSString *bencodedStr = @"d8:announce0:13:creation datei1488124129e4:infod6:lengthi59006272e6:md5sum32:5861fff0e082cabbfff6ae5532765f574:name9:QQ8.7.exe12:piece lengthi131072eee";
    NSData *data = [bencodedStr dataUsingEncoding:NSUTF8StringEncoding];
    id res = [LTSBdecoder decodePrimitiveWithData:data];
    XCTAssertEqualObjects(dict, res);
}

- (void)testWithBencodedTorrentString2
{
    NSDictionary *dict = @{
                           @"announce" : @"http://bttracker.debian.org:6969/announce",
                           @"creation date": @1484590507,
                           @"comment" : @"\"ADebian CD from cdimage.debian.org\"",
                           @"httpseeds" : @[ @"http://cdimage.debian.org/cdimage/release/8.7.1/iso-cd/debian-8.7.1-arm64-CD-1.iso",
                                             @"http://cdimage.debian.org/cdimage/archive/8.7.1/iso-cd/debian-8.7.1-arm64-CD-1.iso",
                                             ],
                           @"info": @{
                                   @"length": @678428672,
                                   @"name" : @"ABCdebian-8.7.1-arm64-CD-1.iso",
                                   @"piece length" : @524288
                                   },
                           };
    NSString *bencodedStr = @"d8:announce41:http://bttracker.debian.org:6969/announce7:comment36:\"ADebian CD from cdimage.debian.org\"13:creation datei1484590507e9:httpseedsl82:http://cdimage.debian.org/cdimage/release/8.7.1/iso-cd/debian-8.7.1-arm64-CD-1.iso82:http://cdimage.debian.org/cdimage/archive/8.7.1/iso-cd/debian-8.7.1-arm64-CD-1.isoe4:infod6:lengthi678428672e12:piece lengthi524288e4:name30:ABCdebian-8.7.1-arm64-CD-1.isoee";
    NSData *data = [bencodedStr dataUsingEncoding:NSUTF8StringEncoding];
    id res = [LTSBdecoder decodePrimitiveWithData:data];
    XCTAssertEqualObjects(dict, res);
}

- (void)testStrings
{
    NSString *test = @"this is the test string";
    NSData *encodedData = [LTSBencoder encodePrimitive:test];
    id res = [LTSBdecoder decodePrimitiveWithData:encodedData];
    XCTAssertEqualObjects(test, res);
}

- (void)testArrays
{
    NSMutableArray *testArray0 = [NSMutableArray arrayWithObjects:@"this a string", @"thisastringtoo", @"more string!", nil];
    NSMutableArray *testArray1 = [NSMutableArray arrayWithObjects:@"this a string", @"thisastringtoo", @"", @" ", @"more string!", nil];
    NSMutableArray *testArray2 = [NSMutableArray arrayWithObjects:[NSNumber numberWithInt:1], [NSNumber numberWithInt:34], [NSNumber numberWithInt:3495874], [NSNumber numberWithInt:0], [NSNumber numberWithInt:2984], [NSNumber numberWithLong:382340958309458930], nil];
    NSMutableArray *testArray3 = [NSMutableArray arrayWithObjects:@"this is a string", [NSNumber numberWithInt:1], nil];
    NSMutableArray *testArray4 = [NSMutableArray arrayWithObjects:@"this is a string", testArray3, [NSNumber numberWithInt:27], nil];
    
    NSData *encodedData0 = [LTSBencoder encodePrimitive:testArray0];
    id res0 = [LTSBdecoder decodePrimitiveWithData:encodedData0];
    XCTAssertEqualObjects(testArray0, res0);
    
    NSData *encodedData1 = [LTSBencoder encodePrimitive:testArray1];
    id res1 = [LTSBdecoder decodePrimitiveWithData:encodedData1];
    XCTAssertEqualObjects(testArray1, res1);
    
    NSData *encodedData2 = [LTSBencoder encodePrimitive:testArray2];
    id res2 = [LTSBdecoder decodePrimitiveWithData:encodedData2];
    XCTAssertEqualObjects(testArray2, res2);
    
    NSData *encodedData3 = [LTSBencoder encodePrimitive:testArray3];
    id res3 = [LTSBdecoder decodePrimitiveWithData:encodedData3];
    XCTAssertEqualObjects(testArray3, res3);
    
    NSData *encodedData4 = [LTSBencoder encodePrimitive:testArray4];
    id res4 = [LTSBdecoder decodePrimitiveWithData:encodedData4];
    XCTAssertEqualObjects(testArray4, res4);
}

- (void)testTorrentFile1
{
    NSURL *fileURL = [[NSBundle mainBundle] URLForResource: @"Pokemon.Sun.and.Moon" withExtension:@"torrent"];
    LTSTorrent *torrent = [[LTSTorrent alloc] initWithFileURL:fileURL];
    XCTAssert([torrent.filename isEqualToString:@"Pokemon.Sun.and.Moon.torrent"]);
    XCTAssertEqualObjects(torrent.dateCreated, [NSDate dateWithTimeIntervalSince1970:1499483777]);
    XCTAssert([torrent.clientAuthorName isEqualToString:@"RARBG"]);
    XCTAssert([torrent.comment isEqualToString:@"Torrent downloaded from https://rarbg.to"]);
    XCTAssert(torrent.files.count == 2);
}

- (void)testTorrentFile2
{
    NSURL *fileURL = [[NSBundle mainBundle] URLForResource: @"Microsoft Office for Mac 2016 v15.13.3 Multi [TechTools]-[rarbg.to]" withExtension:@"torrent"];
    LTSTorrent *torrent = [[LTSTorrent alloc] initWithFileURL:fileURL];
    XCTAssert([torrent.filename isEqualToString:@"Microsoft Office for Mac 2016 v15.13.3 Multi [TechTools]-[rarbg.to].torrent"]);
    XCTAssertEqualObjects(torrent.dateCreated, [NSDate dateWithTimeIntervalSince1970:1441187038]);
    XCTAssert([torrent.clientAuthorName isEqualToString:@"uTorrent/2210"]);
    XCTAssert([torrent.comment isEqualToString:@"Torrent downloaded from https://rarbg.to"]);
    XCTAssert(torrent.files.count == 3);
}

- (void)testTorrentFile3
{
    NSURL *fileURL = [[NSBundle mainBundle] URLForResource: @"Noise Ninja for Photoshop v2 3 2 MacOSX Incl Keymaker-CORE-[rarbg.to]" withExtension:@"torrent"];
    LTSTorrent *torrent = [[LTSTorrent alloc] initWithFileURL:fileURL];
    XCTAssert([torrent.filename isEqualToString:@"Noise Ninja for Photoshop v2 3 2 MacOSX Incl Keymaker-CORE-[rarbg.to].torrent"]);
    XCTAssert([torrent.comment isEqualToString:@"Torrent downloaded from https://rarbg.to"]);
}



@end
