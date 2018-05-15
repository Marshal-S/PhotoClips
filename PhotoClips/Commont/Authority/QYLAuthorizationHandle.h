//
//  QYLAuthorizationHandle.h
//  PersonBike
//
//  Created by Marshal on 2017/8/12.
//  Copyright © 2017年 Marshal. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, QYLAuthorizationType) {
    QYLAuthorizationTypeCamera = 1,             //相机权限
    QYLAuthorizationTypeMediaLibrary = 1 << 1,  //媒体库权限
};

@interface QYLAuthorizationHandle : NSObject

//默认为不延迟片刻就进入，这个方法不能再viewload里面直接使用
+ (BOOL)handleWithAuthorizationType:(QYLAuthorizationType)type;

//最后一个是需要暂停不
+ (BOOL)handleWithAuthorizationType:(QYLAuthorizationType)type isNeedPause:(BOOL)isNeedPause;

//这个是蓝牙才会主动调用的
+ (void)handleSettingWithMessage:(NSString *)message remind:(NSString *)remind isNeedPause:(BOOL)isNeedPause;

@end
