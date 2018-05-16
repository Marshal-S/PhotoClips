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

@property (nonatomic, copy) BOOL (^onClickToSelectBlock)(QYLPhotoModel *photoModel, BOOL selected);//返回值表示可不可以选择
@property (nonatomic, copy) void(^onClickToCheckLargeBlock)(NSInteger row);

- (instancetype)initWithFrame:(CGRect)frame photoList:(NSArray<QYLPhotoModel *> *)photoList;

@end
