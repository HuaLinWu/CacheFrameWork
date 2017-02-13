//
//  HZMemoryCache.m
//  HZCache
//  @protected 该类和所有子类中的方法可以直接访问这样的变量。
//  @private 该类中的方法可以访问，子类不可以访问。
//  @public   可以被所有的类访问
//  @package 本包内使用，跨包不可以
//  Created by Steven on 17/2/9.
//  Copyright © 2017年 Steven. All rights reserved.
//

#import "HZMemoryCache.h"
#import "HZSpinLock.h"
#import <UIKit/UIApplication.h>


@interface _HZNode : NSObject
{
    @package
   __unsafe_unretained _HZNode *_prevNode;
   __unsafe_unretained _HZNode *_nextNode;
    id value;
    id key;
    NSUInteger cost;
}
@end
@implementation _HZNode

@end

//
@interface _HZMemoryCacheQueue : NSObject
{
    @package
    NSUInteger _totalCost;
    NSUInteger _count;
    
    @private
    CFMutableDictionaryRef _dic;
    _HZNode *_headNode;
    _HZNode *_tailNode;
}
- (void)bringNodeToHeader:(_HZNode *)node;
- (void)insertNodeAtHeader:(_HZNode *)node;
- (void)removeAllNode;
- (void)removeNode:(_HZNode *)node;
- (void)removeTailNode;
- (BOOL)containsNode:(_HZNode *)node;
- (_HZNode *)nodeForKey:(id)key;
@end

@implementation _HZMemoryCacheQueue
#pragma mark lifeCycle
- (instancetype)init {
    
    self = [super init];
    if(self) {
        _dic = CFDictionaryCreateMutable(kCFAllocatorDefault, 0, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
    }
    return self;
}
- (void)dealloc {
    
     CFRelease(_dic);
}
#pragma mark public

- (void)bringNodeToHeader:(_HZNode *)node {
    
    if(_headNode == node) {
        return;
    } else if (_tailNode == node) {
        
        _tailNode->_prevNode->_nextNode = nil;
        _tailNode = _tailNode->_prevNode;
        
        _headNode->_prevNode = node;
        node->_prevNode = nil;
        node->_nextNode = _headNode;
        _headNode = node;
        
    } else {
        
        node->_prevNode->_nextNode = node->_nextNode;
        node->_nextNode->_prevNode = node->_prevNode;
        _headNode->_prevNode = node;
        node->_prevNode = nil;
        node->_nextNode = _headNode;
        _headNode = node;
        
    }
    
}
- (void)insertNodeAtHeader:(_HZNode *)node {
    
    CFDictionarySetValue(_dic, (__bridge const void *)(node->key), (__bridge const void *)(node));
    _count++;
    _totalCost += node->cost;
    
    if(_headNode) {
        
        node->_nextNode = _headNode;
        _headNode->_prevNode = node;
        _headNode = node;
        
    } else {
        
        _headNode = _tailNode = node;
        
    }
}
- (void)removeAllNode {
    _headNode = nil;
    _tailNode = nil;
    _count = 0;
    _totalCost = 0;
    CFDictionaryRemoveAllValues(_dic);
}
- (void)removeNode:(_HZNode *)node {
    
    _count--;
    _totalCost -= node->cost;
    
    if(node == _headNode) {
        
        _headNode->_nextNode->_prevNode = nil;
        _headNode = _headNode->_nextNode;
        
    } else if (node == _tailNode) {
        
        _tailNode->_prevNode->_nextNode = nil;
        _tailNode = _tailNode->_prevNode;
    } else {
        
        node->_prevNode->_nextNode = node->_nextNode;
        node->_nextNode->_prevNode = node->_prevNode;
    }
    CFDictionaryRemoveValue(_dic, (__bridge const void *)(node->key));
    node = nil;
}
- (void)removeTailNode {
    
    _count--;
    _totalCost -= _tailNode->cost;
    CFDictionaryRemoveValue(_dic, (__bridge const void *)(_tailNode->key));
    
    _tailNode->_prevNode->_nextNode = nil;
    _tailNode = _tailNode->_prevNode;
    
}
- (BOOL)containsNode:(_HZNode *)node {
    
    if(!node) {
        return NO;
    }
   return  CFDictionaryContainsKey(_dic, (__bridge const void *)(node->key));
}
- (_HZNode *)nodeForKey:(id)key {
    
  return  CFDictionaryGetValue(_dic, (__bridge const void *)key);
    
}
@end

@interface HZMemoryCache(){
    
    HZSpinLock *_spinLock;
    _HZMemoryCacheQueue *_cacheQueue;
}
@end
@implementation HZMemoryCache
#pragma mark lifeCycle
- (instancetype)init{
    
    self = [super init];
    if(self){
        _spinLock = [[HZSpinLock alloc] init];
        _cacheQueue = [[_HZMemoryCacheQueue alloc] init];
        self.countLimit = NSUIntegerMax;
        self.totalCostLimit = NSUIntegerMax;
        self.shouldRemoveAllObjectsOnMemberWarning = YES;
        self.shouldRemoveAllObjectsWhenEnteringBackground = NO;
        //添加监听内存警告
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveMemoryWarningNotification) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
    }
    return self;
}
- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
}
#pragma mark public
- (nullable id)objectForKey:(id)key {
    if(!key) {
        return nil;
    }
    [_spinLock lock];
    
    _HZNode *node = [_cacheQueue nodeForKey:key];
    id value = nil;
    if(node) {
        value = node->value;
        //将访问过后的节点放到第一个节点上
        [_cacheQueue bringNodeToHeader:node];
    }
    
    [_spinLock unlock];
    return value;
}

- (void)setObject:(id)obj forKey:(id)key {
    
    [self setObject:obj forKey:key withCost:0];
}

- (void)setObject:(id)object forKey:(id)key withCost:(NSUInteger)cost {
    
    if(!key) {
        return;
    }
    if(!object) {
        [self removeObjectForKey:key];
        return;
    }
    [_spinLock lock];
    while (cost+_cacheQueue->_totalCost > self.totalCostLimit) {
        //如果内存达到上限时候移除最后一个，知道没有超过为止
        [_cacheQueue removeTailNode];
    }
    _HZNode *node = [_cacheQueue nodeForKey:key];
    if(node) {
        
        node->value = object;
        node->cost = cost;
        [_cacheQueue bringNodeToHeader:node];
        
    } else {
        
        node = [[_HZNode alloc] init];
        node->cost = cost;
        node->value = object;
        node->key = key;
        if(_cacheQueue->_count+1 > self.countLimit){
            //数量超过了上限移除最后一个
            [_cacheQueue removeTailNode];
        }
        [_cacheQueue insertNodeAtHeader:node];
    }
    [_spinLock unlock];
    
}

- (void)removeObjectForKey:(id)key {
    
    if(!key) return;
    [_spinLock lock];
    
    _HZNode *node = [_cacheQueue nodeForKey:key];
    if(node) {
        [_cacheQueue removeNode:node];
    }
    
    [_spinLock unlock];
}

- (void)removeAllObjects {
    
    [_spinLock lock];
    
    [_cacheQueue removeAllNode];
    
    [_spinLock unlock];
}

#pragma mark private
- (void)didReceiveMemoryWarningNotification{
    
    if(self.shouldRemoveAllObjectsOnMemberWarning) {
        
        [self removeAllObjects];
    }
    if(self.onMemberWarningBlock) {
        
        self.onMemberWarningBlock(self);
    }
}
- (void)appDidEnterBackground{
    
    if(self.shouldRemoveAllObjectsWhenEnteringBackground) {
        
        [self removeAllObjects];
    }
    if(self.enteringBackgroundBlock) {
        
        self.enteringBackgroundBlock(self);
    }
}
@end
