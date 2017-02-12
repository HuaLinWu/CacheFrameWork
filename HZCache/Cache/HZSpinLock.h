//
//  HZSpinLock.h
//  HZCache
//
//  Created by Steven on 17/2/10.
//  Copyright © 2017年 Steven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HZSpinLock : NSObject
- (void)lock;
- (BOOL)tryLock;
- (void)unlock;
@end
