//
//  QYLCommonUtil.h
//  gerendanche
//
//  Created by Marshal on 2017/6/20.
//  Copyright © 2017年 Mr.li. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QYLCommonUtil : NSObject

/**
 检查是否是手机号码

 @param phone 手机号
 @return 返回YES是手机号，否则不是
 */
+ (BOOL)checkPhonenum:(NSString *)phone;

/**
 判断是一个字符串是否时空

 @param string 字符串
 @return 为空返回YES,否则NO
 */
+ (BOOL)isEmpty:(NSString *)string;

/**
 从UserDefault中获取信息

 @param key key值
 @return 返回保存的对象
 */
+ (id)getObjectFromUD:(NSString *)key;

/**
 保存对象到UserDefault

 @param value 保存的北荣
 @param key key值
 */
+ (void)saveObjectToUD:(id)value key:(NSString *)key;

/**
 删除信息

 @param key key值
 */
+ (void)deleteObjectFromUD:(NSString *)key;

/**
 获取保存路径

 @param fileName 文件名称
 @return 返回路径名称
 */
+ (NSString *)getPathWithName:(NSString *)fileName;

/**
 打开一个URL(例如打电话之类的)

 @param urlstr url
 @return 返回的表示是否能打开
 */
+ (BOOL)openUrl:(NSString *)urlstr;

/**
 返回的时间

 @param second 到1970年的时间间隔
 @return 返回以分钟为单位的字符串
 */
+ (NSString *)getRechargeTimeBySecond:(long)second;

@end
