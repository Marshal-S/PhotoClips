//
//  QYLClipsController.h
//  PhotoClips
//
//  Created by Marshal on 2018/5/16.
//  Copyright © 2018年 Marshal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QYLPhotoEnum.h"

@class QYLPhotoModel;

@interface QYLClipsController : UIViewController

+ (instancetype)clipsWithType:(QYLPhotoClipType)clipType clipsList:(NSArray<QYLPhotoModel *> *)clipsList;

@end
