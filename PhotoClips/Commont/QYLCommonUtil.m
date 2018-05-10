//
//  QYLCommonUtil.m
//  gerendanche
//
//  Created by Marshal on 2017/6/20.
//  Copyright © 2017年 Mr.li. All rights reserved.
//

#import "QYLCommonUtil.h"

@implementation QYLCommonUtil

//手机号码验证
+ (BOOL)checkPhonenum:(NSString *)phone {
    //手机号以1开头，11位数字
    NSString *phoneRegex = @"^[1]\\d{10}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:phone];
}

// 判断空字符串
+ (BOOL)isEmpty:(NSString *)string {
    if (string == nil) {
        return YES;
    }
    
    if (string == NULL) {
        return YES;
    }
    
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    
    if ([string isKindOfClass:[NSString class]] && [[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0) {
        return YES;
    } else {
        return NO;
    }
}

+ (BOOL)openUrl:(NSString *)urlstr {
    NSURL *url = [NSURL URLWithString:urlstr];
    if (!url) return NO;
    UIApplication *application = [UIApplication sharedApplication];
    if ([application canOpenURL:url]) {
        if (@available(iOS 10.0, *)) {
            [application openURL:url options:@{} completionHandler:^(BOOL success) {
            }];
        }else {
            [application openURL:url];
        }
        return YES;
    }
    return NO;
}

//NSUserDefaults
+ (id)getObjectFromUD:(NSString *)key {
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

+ (void)saveObjectToUD:(id)value key:(NSString *)key {
    if ([value isKindOfClass:[NSDictionary class]]) {
        NSMutableDictionary *mutaDic = [value mutableCopy];
        NSArray *allkeys = mutaDic.allKeys;
        for (int i=0; i<[allkeys count]; i++) {
            NSString *key = [allkeys objectAtIndex:i];
            
            NSString *value = [mutaDic objectForKey:key];
            if ([self isEmpty:value]) {
                [mutaDic setObject:@"" forKey:key];
            }
        }
        
        [[NSUserDefaults standardUserDefaults] setObject:mutaDic forKey:key];
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)deleteObjectFromUD:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)getPathWithName:(NSString *)fileName {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    ;
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingString:@"/major/"];
    if (![fileManager fileExistsAtPath:path]) {
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return [path stringByAppendingString:fileName];
}

+ (NSString *)getRechargeTimeBySecond:(long)second {
    second = second/60;//先换算成分钟
    if (second < 60) {
        return [NSString stringWithFormat:@"00:%.2ld", second > 0 ? second : 1];
    }else {
        return [NSString stringWithFormat:@"%.2ld:%.2ld", second/60, second%60];
    }
}


@end
