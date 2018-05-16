//
//  QYLClipsController.h
//  PhotoClips
//
//  Created by Marshal on 2018/5/16.
//  Copyright © 2018年 Marshal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QYLPhotoEnum.h"

@interface QYLClipsController : UIViewController

+ (instancetype)clipsWithType:(QYLPhotoClipType)clipType;

@end
