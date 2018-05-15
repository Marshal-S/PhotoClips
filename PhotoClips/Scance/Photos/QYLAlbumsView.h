//
//  QYLAlbumsView.h
//  PhotoClips
//
//  Created by Marshal on 2018/5/12.
//  Copyright © 2018年 Marshal. All rights reserved.
//  相册列表tableView

#import <UIKit/UIKit.h>

@class QYLAblumModel;

@interface QYLAlbumsView : UITableView

@property (nonatomic, copy) void(^onClickToSelectBlock)(NSInteger row);

- (instancetype)initWithFrame:(CGRect)frame albumList:(NSArray<QYLAblumModel *> *)albumList;

@end
