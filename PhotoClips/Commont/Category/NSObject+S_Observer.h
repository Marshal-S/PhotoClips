//
//  NSObject+S_Observer.h
//  LSKVO
//
//  Created by Marshal on 2018/1/11.
//  Copyright © 2018年 Marshal. All rights reserved.
//  观察者模式专用

#import <Foundation/Foundation.h>

typedef void(^LSCallBack)(id x);//callBack返回非空值且不重复的值

//callBack为 ObserverCallback,调用改方法即可获取block
#define LSObserver(target, path, ObserverCallback) [target s_addObserverForKeyPath:NSStringFromSelector(@selector(path)) callBack:ObserverCallback]
#define LSCancelObserver(target, path) [target s_cancelObserverForKeyPath:NSStringFromSelector(@selector(path))]

@interface NSObject (S_Observer)
//用于设置回调的
LSCallBack ObserverCallback(LSCallBack callback);

- (void)s_addObserverForKeyPath:(NSString *)path callBack:(void(^)(id x))callback;

//取消掉某个观察者
- (void)s_cancelObserverForKeyPath:(NSString *)path;

//取消即移除当前对象所有被观察的，复用一定要调用该方法
- (void)s_cancelObserver;

@end
