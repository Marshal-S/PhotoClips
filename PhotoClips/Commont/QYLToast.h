//
//  QYLToast.h
//  PersonBike
//
//  Created by Marshal on 2017/8/7.
//  Copyright © 2017年 Marshal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QYLToast : UIView

//默认1.5秒
+ (void)showWithMessage:(NSString *)message;

//这个可以设置时间
+ (void)showWithMessage:(NSString *)message timeInterval:(CGFloat)interval;

@end
