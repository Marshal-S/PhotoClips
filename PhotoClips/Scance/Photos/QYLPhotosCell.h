//
//  QYLPhotosSelectCell.h
//  PhotoClips
//
//  Created by Marshal on 2018/5/11.
//  Copyright © 2018年 Marshal. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QYLPhotoModel;

@interface QYLPhotosCell : UICollectionViewCell

@property (nonatomic, copy) BOOL (^selectBlock)(BOOL selected);//返回值表示可不可以选择

- (void)updateWithPhotoModel:(QYLPhotoModel *)photoModel;

- (void)loadImageWithPhotoModel:(QYLPhotoModel *)photoModel;

@end
