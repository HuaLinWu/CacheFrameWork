//
//  HZDiskCache.h
//  HZCache
//
//  Created by Steven on 17/2/13.
//  Copyright © 2017年 Steven. All rights reserved.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN
@interface HZDiskCache : NSObject

@property (nonatomic, assign) NSString *name;

- (nullable id)objectForKey:(id)key;

- (void)setObject:(id <NSCoding>)obj forKey:(id)key;

- (void)removeObjectForKey:(id)key;

- (void)removeAllObjects;

@end
NS_ASSUME_NONNULL_END
