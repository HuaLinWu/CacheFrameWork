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

/**
 If `YES`, the cache will remove all objects when the app receives a memory warning.
 The default value is `YES`.
 */
@property BOOL shouldRemoveAllObjectsOnMemberWarning;

/**
 The block  will be executed when app receiveMemoryWarningNotification
 */
@property void (^onMemberWarningBlock)(HZMemoryCache *cache);

/**
 If `YES`, the cache will remove all objects when the app enter background.
 The default value is `NO`.
 */
@property BOOL shouldRemoveAllObjectsWhenEnteringBackground;

/**
 The block  will be executed when app entreBackground
 */
@property void (^enteringBackgroundBlock)(HZMemoryCache *cache);

@property (nonatomic, assign) NSString *name;

- (nullable id)objectForKey:(id)key;

- (void)setObject:(id)obj forKey:(id)key;

- (void)setObject:(id)object forKey:(id)key withCost:(NSUInteger)cost;

- (void)removeObjectForKey:(id)key;

- (void)removeAllObjects;

@end
NS_ASSUME_NONNULL_END
