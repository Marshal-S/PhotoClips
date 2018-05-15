//
//  QYLAlbumViewCell.m
//  PhotoClips
//
//  Created by Marshal on 2018/5/12.
//  Copyright © 2018年 Marshal. All rights reserved.
//

#import "QYLAlbumsCell.h"
#import "QYLPhotosManager.h"

@interface QYLAlbumsCell ()
{
    PHImageRequestID _irID;
}

@property (nonatomic, strong) UIImageView *ivCover;
@property (nonatomic, strong) UILabel *lblTitle;
@property (nonatomic, strong) UILabel *lblCount;

@end

@implementation QYLAlbumsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUp];
    }
    return self;
}

- (void)setUp {
    _ivCover = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 60, 60)];
    _ivCover.contentMode = UIViewContentModeScaleAspectFit;
    _ivCover.clipsToBounds = YES;
    [self.contentView addSubview:_ivCover];
    
    _lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(_ivCover.s_right+10, _ivCover.s_Y, 200, 30)];
    _lblTitle.textColor = [UIColor blackColor];
    _lblTitle.backgroundColor = [UIColor whiteColor];
    _lblTitle.font = [UIFont systemFontOfSize:16];
    _lblTitle.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_lblTitle];
    
    _lblCount = [[UILabel alloc] initWithFrame:CGRectMake(_lblTitle.s_X, _lblTitle.s_bottom+5, 200, 30)];
    _lblCount.textColor = [UIColor grayColor];
    _lblCount.backgroundColor = [UIColor whiteColor];
    _lblCount.font = [UIFont systemFontOfSize:14];
    _lblCount.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_lblCount];
}

- (void)updateWithAblumModel:(QYLAblumModel *)albumModel {
    QYLPhotoModel *coverPhoto = albumModel.assets[0];
    if (coverPhoto) {
        if (_irID) [[PHImageManager defaultManager] cancelImageRequest:_irID];//取消本次请求
        _irID = [[QYLPhotosManager sharedInstance] getFastImageWithAsset:coverPhoto.asset targetSize:CGSizeMake(120, 120) resultHandler:^(UIImage *image) {
            self.ivCover.image = image;
        }];
    }
    _lblTitle.text = albumModel.title;
    _lblCount.text = [NSString stringWithFormat:@"约%ld张",(long)albumModel.count];
}





@end
