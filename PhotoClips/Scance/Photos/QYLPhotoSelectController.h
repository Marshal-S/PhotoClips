//
//  QYLPhotoSelectController.h
//  PhotoClips
//
//  Created by Marshal on 2018/5/16.
//  Copyright © 2018年 Marshal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QYLPhotosManager.h"
#import "QYLPhotoEnum.h"

@interface QYLPhotoSelectController : UIViewController

+ (instancetype)selectWithAssetCollection:(PHAssetCollection *)assetCollection clipType:(QYLPhotoClipType)clipType;

@end
