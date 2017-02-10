//
//  DictionaryTests.m
//  HZCache
//
//  Created by Steven on 17/2/10.
//  Copyright © 2017年 Steven. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface DictionaryTests : XCTestCase

@end

@implementation DictionaryTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

/*
 * 0.275 (0.276) seconds
 */
- (void)testPerformanceExample {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    UIImage *image = [UIImage imageNamed:@"04.jpg"];
    [self measureBlock:^{
        [dict setObject:image forKey:@"image"];
    }];
}

@end
