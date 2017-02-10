//
//  HZMemoryCache.h
//  HZCache
//
//  Created by Steven on 17/2/9.
//  Copyright © 2017年 Steven. All rights reserved.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN
@interface HZMemoryCache : NSObject

- (nullable id)objectForKey:(id<NSCopying>)key;

- (void)setObject:(id)obj forKey:(id<NSCopying>)key;

- (void)setObject:(id)object forKey:(id<NSCopying>)key withCost:(NSUInteger)cost;

- (void)removeObjectForKey:(id<NSCopying>)key;

- (void)removeAllObjects;

@end
NS_ASSUME_NONNULL_END
