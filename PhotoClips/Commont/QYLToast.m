//
//  QYLToast.m
//  PersonBike
//
//  Created by Marshal on 2017/8/7.
//  Copyright © 2017年 Marshal. All rights reserved.
//

#import "QYLToast.h"

@implementation QYLToast

+ (void)showWithMessage:(NSString *)message {
    [self showWithMessage:message timeInterval:2];
}

+ (void)showWithMessage:(NSString *)message timeInterval:(CGFloat)interval {
    if (!message || message.length < 1) return;
    __block QYLToast *back = [[QYLToast alloc] init];
    back.backgroundColor = RGBA(0, 0, 0, 0.9);
    back.layer.cornerRadius = 4;
    [[UIApplication sharedApplication].delegate.window.rootViewController.view addSubview:back];//直接添加到rootController上面(navi)
    UILabel *toast = [[UILabel alloc] init];
    toast.textColor = [UIColor whiteColor];
    toast.backgroundColor = [UIColor clearColor];
    toast.textAlignment = NSTextAlignmentCenter;
    toast.font = [UIFont systemFontOfSize:16];
    toast.numberOfLines = 0;
    toast.layer.cornerRadius = 5;
    toast.text = message;
    CGSize size = [toast sizeThatFits:CGSizeMake(SCREEN_WIDTH-80, 32)];
    back.bounds = CGRectMake(0, 0, size.width+30, size.height+20);
    toast.frame = CGRectMake(15, 10, size.width, size.height);
    back.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
    [back addSubview:toast];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(interval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.3 animations:^{
            back.alpha = 0;
        } completion:^(BOOL finished) {
            [back removeFromSuperview];
            back = nil;
        }];
    });
}

QYLDealloc

@end
