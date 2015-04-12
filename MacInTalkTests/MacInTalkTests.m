//
//  MacInTalkTests.m
//  MacInTalkTests
//
//  Created by Liam Westby on 10/4/14.
//  Copyright (c) 2014 ACM. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <XCTest/XCTest.h>
#import "AppDelegate.h"

@interface MacInTalkTests : XCTestCase
@property (nonatomic, retain) AppDelegate *ad;
@end

@implementation MacInTalkTests
@synthesize ad;
- (void)setUp {
    [super setUp];
    ad = (AppDelegate *)[[NSApplication sharedApplication] delegate];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    NSInteger tableCount = ad.voiceTable.numberOfRows;
    NSInteger voiceCount = ad.voiceNames.count;
    
    XCTAssertTrue(tableCount == voiceCount, @"table rows (%ld) and voice counts (%ld) not equal", (long)tableCount, (long)voiceCount);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
