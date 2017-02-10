//
//  MemoryCacheTests.m
//  HZCache
//
//  Created by Steven on 17/2/10.
//  Copyright © 2017年 Steven. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "HZMemoryCache.h"
@interface MemoryCacheTests : XCTestCase
{
    HZMemoryCache *cache;
}
@end

@implementation MemoryCacheTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    cache = [[HZMemoryCache alloc] init];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    cache = nil;
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}
/*
 测试放入变量需要花费的时间
 *[MemoryCacheTests testSetObjectSpendTime]' passed (0.275 seconds)
 */
- (void)testSetObjectSpendTime {
    
    UIImage *image = [UIImage imageNamed:@"04.jpg"];
    [self measureBlock:^{
        [cache setObject:image forKey:@"image"];
    }];
    
}
- (void)testSetObjectOfMutableThreed {
    
 NSThread *thread1 =  [[NSThread alloc] initWithBlock:^{
     [cache setObject:@"1" forKey:@"str"];

 }];
 NSThread *thread2 =  [[NSThread alloc] initWithBlock:^{
        [cache setObject:@"2" forKey:@"str"];
    }];
 NSThread *thread3 =  [[NSThread alloc] initWithBlock:^{
        [cache setObject:@"3" forKey:@"str"];
 }];
    [thread1 start];
    [thread2 start];
    [thread3 start];
    NSLog(@"---->%@",[cache objectForKey:@"str"]);
}
@end
