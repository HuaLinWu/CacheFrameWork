//
//  HZDiskCache.m
//  HZCache
//
//  Created by Steven on 17/2/13.
//  Copyright © 2017年 Steven. All rights reserved.
//

#import "HZDiskCache.h"

@implementation HZDiskCache

//- (nullable id)objectForKey:(id)key {
//
//}

- (void)setObject:(id <NSCoding>)obj forKey:(id)key {
    
    NSData *value = nil;
    @try {
        value =[NSKeyedArchiver archivedDataWithRootObject:obj];
    } @catch (NSException *exception) {
        
        
    } @finally {
        
    }
    if(!value){
        return;
    }
}

- (void)removeObjectForKey:(id)key {

}

- (void)removeAllObjects {

}
@end
