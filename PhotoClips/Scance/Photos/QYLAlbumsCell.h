//
//  QYLAlbumViewCell.h
//  PhotoClips
//
//  Created by Marshal on 2018/5/12.
//  Copyright © 2018年 Marshal. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QYLAblumModel;

@interface QYLAlbumsCell : UITableViewCell

- (void)updateWithAblumModel:(QYLAblumModel *)albumModel;

@end
