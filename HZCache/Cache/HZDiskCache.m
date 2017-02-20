//
//  HZDiskCache.m
//  HZCache
//
//  Created by Steven on 17/2/13.
//  Copyright © 2017年 Steven. All rights reserved.
//

#import "HZDiskCache.h"
#include <CommonCrypto/CommonCrypto.h>
#import <objc/runtime.h>
#import <UIKit/UIKit.h>
@interface HZDiskCache()
@property(nonatomic, copy) NSString *filePath;

@end

@implementation HZDiskCache
#pragma mark lifeCycle 
- (instancetype)init {
    
    self = [super init];
    if(self) {
        NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
       NSString *path = [rootPath stringByAppendingPathComponent:@"hzCache"];
       _filePath = path;
        [self createDirectoryAtPath:path];
        [self initIvar];
    }
    return self;
}

- (instancetype)initWithFilePath:(NSString *)path {
    
    self = [super init];
    if(self) {
        if(!path){
            NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
            path = [rootPath stringByAppendingPathComponent:@"hzCache"];
        }
        self.filePath = path;
        [self createDirectoryAtPath:path];
        [self initIvar];
    }
    return self;
}
#pragma mark public
- (void)setObject:(id<NSCoding>)obj forKey:(NSString *)key {
    if(!key) {
        return;
    }
    if(!obj){
        [self removeObjectForKey:key];
        return;
    }
    NSString *filePath = [self getFilePathForKey:key];
    if([self createFileAtPath:filePath]) {
        
        id<NSCoding>tagertObject = [self machiningObject:obj];
        if([NSKeyedArchiver archiveRootObject:tagertObject toFile:filePath]) {
            NSLog(@"---保存数据成功到文件-->%@",filePath);
        } else {
            NSLog(@"----保存失败-->value = %@,key =%@",obj,key);
        }
    }
    
}
- (id<NSCoding>)objectForKey:(NSString *)key {
    
    if(!key){
        return nil;
    }
    NSString *filePath = [self getFilePathForKey:key];
    id value = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    return value;
}
- (void)removeObjectForKey:(NSString *)key {
    NSString *filePath = [self getFilePathForKey:key];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:filePath]) {
        [fileManager removeItemAtPath:filePath error:nil];
    }
}
#pragma mark private

- (void)initIvar {
    
    //初始化缓存时间
    _ageLimit = DBL_MAX;
    _autoTrimInterval = 60;
}

- (id<NSCoding>)machiningObject:(id<NSCoding>)object {
    Class objectClass = object_getClass(object);
    id<NSCoding>machinedObject = object;
    //当为图片的时候需要加工
    if([objectClass isSubclassOfClass:NSClassFromString(@"UIImage")]) {
        UIImage *tempImage = (UIImage *)object;
        if(![tempImage.imageAsset isMemberOfClass:[UIImage class]]) {
            machinedObject = [UIImage imageWithCGImage:tempImage.CGImage];
        }
    }
    return machinedObject;
}

- (BOOL)createFileAtPath:(NSString *)filePath {
    
    if(!filePath || ![filePath isKindOfClass:[NSString class]] || filePath.length == 0){
        return NO;
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL  fileExists = [fileManager fileExistsAtPath:filePath];
    if(!fileExists){
       return  [fileManager createFileAtPath:filePath contents:nil attributes:nil];
    }
    return YES ;
}
- (BOOL)createDirectoryAtPath:(NSString *)filePath{
    
    if(!filePath || ![filePath isKindOfClass:[NSString class]] || filePath.length == 0){
        return NO;
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL  fileExists = [fileManager fileExistsAtPath:filePath];
    if(!fileExists){
        return  [fileManager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return YES ;

}
- (NSString *)getFilePathForKey:(NSString *)key {
    
    if(!key) {
        return nil;
    }
    NSData *data = [key dataUsingEncoding:NSUTF8StringEncoding];
    NSString *fileName = [self md5StringForData:data];
    NSString *filePath = [self.filePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.data",fileName]];
    return filePath;
}

- (NSString *)md5StringForData:(NSData *)data{
    
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(data.bytes, (CC_LONG)data.length, result);
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

@end
