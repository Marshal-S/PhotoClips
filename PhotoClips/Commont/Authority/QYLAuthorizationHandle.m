//
//  QYLAuthorizationHandle.m
//  PersonBike
//
//  Created by Marshal on 2017/8/12.
//  Copyright © 2017年 Marshal. All rights reserved.
//

#import "QYLAuthorizationHandle.h"
#import <Photos/Photos.h>
#import <AVFoundation/AVFoundation.h>
#import "QYLCommonUtil.h"

@implementation QYLAuthorizationHandle

+ (BOOL)handleWithAuthorizationType:(QYLAuthorizationType)type {
    return [self handleWithAuthorizationType:type isNeedPause:NO];
}

+ (BOOL)handleWithAuthorizationType:(QYLAuthorizationType)type isNeedPause:(BOOL)isNeedPause {
    NSString *authorStr;
    NSString *remindStr;
    switch (type) {
        case QYLAuthorizationTypeCamera:{
            AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
            if (status == AVAuthorizationStatusRestricted || status == AVAuthorizationStatusDenied) {
                authorStr = @"相机";
                remindStr = @"将无法使用拍照功能！";
            }
            break;
        }
        case QYLAuthorizationTypeMediaLibrary: {
            PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
            if (status == PHAuthorizationStatusRestricted || status == PHAuthorizationStatusDenied) {
                authorStr = @"相册";
                remindStr = @"将无法使用相册内图片剪裁功能！";
            }
            break;
        }
    }
    if (!authorStr) return YES;
    [self handleSettingWithMessage:authorStr remind:remindStr isNeedPause:isNeedPause];
    return NO;
}

+ (void)handleSettingWithMessage:(NSString *)message remind:(NSString *)remind isNeedPause:(BOOL)isNeedPause {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"权限警报" message:[NSString stringWithFormat:@"检测到您尚未打开%@权限%@",message,remind?[@"," stringByAppendingString:remind]:@""] preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [QYLCommonUtil openUrl:UIApplicationOpenSettingsURLString];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:nil]];
    
    
    if (isNeedPause) {
        //必须要加上一个延迟，否则会崩溃
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
        });
    }else {
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
    }
}

@end
