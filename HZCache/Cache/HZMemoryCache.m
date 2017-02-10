//
//  HZMemoryCache.m
//  HZCache
//
//  Created by Steven on 17/2/9.
//  Copyright © 2017年 Steven. All rights reserved.
//

#import "HZMemoryCache.h"
#import "HZSpinLock.h"
@interface HZMemoryCache(){
    CFMutableDictionaryRef memoryCahe;
    HZSpinLock *spinLock;
}
@end
@implementation HZMemoryCache
#pragma mark lifeCycle
- (instancetype)init{
    
    self = [super init];
    if(self){
        memoryCahe = CFDictionaryCreateMutable(kCFAllocatorDefault, 0, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
        spinLock = [[HZSpinLock alloc] init];
    }
    return self;
}
- (void)dealloc{
    
    CFRelease(memoryCahe);
    spinLock = nil;
}
#pragma mark public
- (nullable id)objectForKey:(id<NSCopying>)key {
    
    id value = CFDictionaryGetValue(memoryCahe, (__bridge const void *)(key));
    return value;
}

- (void)setObject:(id)obj forKey:(id<NSCopying>)key {
    
    [self setObject:obj forKey:key withCost:0];
}

- (void)setObject:(id)object forKey:(id)key withCost:(NSUInteger)cost {
    
    if(!key) {
        return;
    }
    
    if(!object) {
        [self removeObjectForKey:key];
    }
    [spinLock lock];
    
    CFDictionarySetValue(memoryCahe, (__bridge const void *)(key), (__bridge const void *)(object));
    
    [spinLock unlock];
    
}

- (void)removeObjectForKey:(id<NSCopying>)key {
    
    if(!key) return;
    [spinLock lock];
    
    CFDictionaryRemoveValue(memoryCahe, (__bridge const void *)(key));
    
    [spinLock unlock];
}

- (void)removeAllObjects {
    
    [spinLock lock];
    
    CFDictionaryRemoveAllValues(memoryCahe);
    
    [spinLock unlock];
}

@end
