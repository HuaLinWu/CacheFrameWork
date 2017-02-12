//
//  HZMemoryCache.h
//  HZCache／NSCache
//  LRP
//  Created by Steven on 17/2/9.
//  Copyright © 2017年 Steven. All rights reserved.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN
@interface HZMemoryCache : NSObject

/**
 The maximum total cost that the cache can hold before it starts evicting objects.
 
 @discussion The default value is NSUIntegerMax, which means no limit.
 This is not a strict limit—if the cache goes over the limit, some objects in the
 cache could be evicted later in backgound thread.
 */
@property NSUInteger totalCostLimit;

/**
 The maximum number of objects the cache should hold.
 
 @discussion The default value is NSUIntegerMax, which means no limit.
 This is not a strict limit—if the cache goes over the limit, some objects in the
 cache could be evicted later in backgound thread.
 */
@property NSUInteger countLimit;

@property (nonatomic, assign) NSString *name;


- (nullable id)objectForKey:(id<NSCopying>)key;

- (void)setObject:(id)obj forKey:(id<NSCopying>)key;

- (void)setObject:(id)object forKey:(id<NSCopying>)key withCost:(NSUInteger)cost;

- (void)removeObjectForKey:(id<NSCopying>)key;

- (void)removeAllObjects;

@end
NS_ASSUME_NONNULL_END
