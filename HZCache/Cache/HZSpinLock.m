//
//  HZSpinLock.m
//  HZCache
//
//  Created by Steven on 17/2/10.
//  Copyright © 2017年 Steven. All rights reserved.
//

#import "HZSpinLock.h"
#import <os/lock.h>
@interface HZSpinLock()
{
   os_unfair_lock_t spinLock;//10.0以后有效
}
@end
@implementation HZSpinLock
- (instancetype)init {
    self = [super init];
    if(self) {
        spinLock = &(OS_UNFAIR_LOCK_INIT);
    }
    return self;
}

#pragma mark public
- (void)lock {
    
    os_unfair_lock_lock(spinLock);
}
- (BOOL)tryLock {
    
   return os_unfair_lock_trylock(spinLock);
}
- (void)unlock {
    
    os_unfair_lock_unlock(spinLock);
}

@end
