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

@property (nonatomic, copy) NSString *name;

@property (nonatomic, assign) NSTimeInterval ageLimit;

@property (nonatomic, copy, readonly) NSString *filePath;



@property (nonatomic, assign) NSTimeInterval autoTrimInterval;

- (instancetype)initWithFilePath:(NSString *)path;

- (void)setObject:(id<NSCoding>)obj forKey:(NSString *)key;

- (void)setObject:(id)object customArchiveBlock:(NSData *(^)(id object))customArchiveBlock  forKey:(NSString *)key;

- (id<NSCoding>)objectForKey:(NSString *)key;

- (id)objectWithCustomUnArchiveBlock:(id(^)(NSData* data))customUnArchiveBlock forKey:(NSString *)key;

- (void)removeObjectForKey:(NSString *)key;

- (BOOL)containsObjectForKey:(NSString *)key;
@end
NS_ASSUME_NONNULL_END
