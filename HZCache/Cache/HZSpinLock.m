//
//  HZSpinLock.m
//  HZCache
//
//  Created by Steven on 17/2/10.
//  Copyright © 2017年 Steven. All rights reserved.
//

#import "HZSpinLock.h"
#ifdef __IPHONE_10_0
#import <os/lock.h>
#else
#import <pthread.h>
#endif
@interface HZSpinLock()
{
  #ifdef __IPHONE_10_0
   os_unfair_lock spinLock;//10.0以后有效
  #else
   pthread_mutex_t lock;
  #endif
}
@end
@implementation HZSpinLock
- (instancetype)init {
    self = [super init];
    if(self) {
       #ifdef __IPHONE_10_0
       spinLock = OS_UNFAIR_LOCK_INIT;
       #else
       pthread_mutex_init(&lock,NULL);
       #endif
    }
    return self;
}
- (void)dealloc{
    #ifndef __IPHONE_10_0
    pthread_mutex_destroy(&_lock);
    #endif
}
#pragma mark public
- (void)lock {
    #ifdef __IPHONE_10_0
    os_unfair_lock_lock(&spinLock);
    #else
    pthread_mutex_lock(&lock);
    #endif
}
- (BOOL)tryLock {
    #ifdef __IPHONE_10_0
    return os_unfair_lock_trylock(&spinLock);
    #else
    return pthread_mutex_trylock(&lock);
    #endif
}
- (void)unlock {
    #ifdef __IPHONE_10_0
    os_unfair_lock_unlock(&spinLock);
    #else
    pthread_mutex_unlock(&lock);
    #endif
}

@end
