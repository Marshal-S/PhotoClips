//
//  QYLPhotosView.h
//  PhotoClips
//
//  Created by Marshal on 2018/5/12.
//  Copyright © 2018年 Marshal. All rights reserved.
//  图片列表collectionView

#import <UIKit/UIKit.h>

@class QYLPhotoModel;

@interface QYLPhotosView : UICollectionView

- (instancetype)initWithFrame:(CGRect)frame photoList:(NSArray<QYLPhotoModel *> *)photoList;

@end
