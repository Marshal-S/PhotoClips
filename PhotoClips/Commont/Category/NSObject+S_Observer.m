//
//  NSObject+S_Observer.m
//  LSKVO
//
//  Created by Marshal on 2018/1/11.
//  Copyright © 2018年 Marshal. All rights reserved.
//

#import "NSObject+S_Observer.h"
#import <objc/runtime.h>

static char const * kLSObserverTarget = "kLSObserverTarget";

//实际观察者对象
@interface __ObserverTarget : NSObject
{
    @package
    NSMutableDictionary *_observerCollection;
}

@end

@implementation __ObserverTarget

- (instancetype)init {
    if (self = [super init]) {
        _observerCollection = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([change[NSKeyValueChangeNotificationIsPriorKey] boolValue]) return;
    id newValue = change[NSKeyValueChangeNewKey];//注意这里的值其实调用的是get方法
    LSCallBack callback  = _observerCollection[keyPath];
    if (callback) callback(newValue);
}

@end

@implementation NSObject (S_Observer)

//self为被观察者对象
- (void)s_addObserverForKeyPath:(NSString *)path callBack:(void(^)(id x))callback {
    NSAssert(path && callback, @"callback回调不能为空");
    __ObserverTarget *observerTarget = ObserverTarget(self);
    NSMutableDictionary *collection = observerTarget->_observerCollection;
    //不重复添加观察者，但是可以更换回调block
    if (![collection.allKeys containsObject:path]) {
        [self addObserver:observerTarget forKeyPath:path options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
    }
    [collection setValue:callback forKey:path];
}

- (void)s_cancelObserverForKeyPath:(NSString *)path {
    if (!path) return;
    __ObserverTarget *observerTarget = ObserverTarget(self);
    [self removeObserver:observerTarget forKeyPath:path];
    [observerTarget->_observerCollection removeObjectForKey:path];
}

- (void)s_cancelObserver {
    __ObserverTarget *observerTarget = ObserverTarget(self);
    NSMutableDictionary *collection = observerTarget->_observerCollection;
    for (NSString *keyPath in collection) {
        //移除所以观察者,以防万一，加上捕获
        @try {
            [self removeObserver:observerTarget forKeyPath:keyPath];
        } @catch (NSException *exception) {}
    }
    [collection removeAllObjects];
}

static __ObserverTarget * ObserverTarget(id x) {
    __ObserverTarget *target = objc_getAssociatedObject(x, kLSObserverTarget);
    if (!target) {
        target = [[__ObserverTarget alloc] init];
        objc_setAssociatedObject(x, kLSObserverTarget, target, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return target;
}

LSCallBack ObserverCallback(LSCallBack callback) {
    return callback;
}

@end

