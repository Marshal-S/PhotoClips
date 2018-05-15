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

@property (nonatomic, copy) void(^selectBlock)(BOOL selected);

- (void)updateWithPhotoModel:(QYLPhotoModel *)photoModel;

@end
