//
//  QYLPhotosSelectController.h
//  PhotoClips
//
//  Created by Marshal on 2018/5/11.
//  Copyright © 2018年 Marshal. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, QYLPhotoClipType) {
    QYLPhotoClipType1080x1920,//1080x1920
    QYLPhotoClipType9_18,     //9:18
};

@interface QYLPhotosSelectController : UIViewController

+ (instancetype)selectWithClipType:(QYLPhotoClipType)clipType;

@end
