//
//  QYLPhotosSelectCell.m
//  PhotoClips
//
//  Created by Marshal on 2018/5/11.
//  Copyright © 2018年 Marshal. All rights reserved.
//

#import "QYLPhotosCell.h"
#import "QYLPhotosManager.h"

@interface QYLPhotosCell ()

@property (nonatomic, strong) UIImageView *ivPreview; //预览图
@property (nonatomic, strong) UIButton *btnSelect;


@end

@implementation QYLPhotosCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUp];
    }
    return self;
}

- (void)setUp {
    _ivPreview = [[UIImageView alloc] initWithFrame:self.bounds];
    _ivPreview.contentMode = UIViewContentModeCenter;
    [self.contentView addSubview:_ivPreview];
    
    _btnSelect = [[UIButton alloc] initWithFrame:CGRectMake(_ivPreview.s_right-40, 40, 40, 40)];
    _btnSelect.contentMode = UIViewContentModeScaleAspectFit;
    [_btnSelect setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [_btnSelect setImage:[UIImage imageNamed:@""] forState:UIControlStateSelected];
    [_btnSelect addTarget:self action:@selector(onClickToSelect:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_btnSelect];
}

- (void)updateWithPhotoModel:(QYLPhotoModel *)photoModel {
    id asset = photoModel.asset;
    [[QYLPhotosManager sharedInstance] getFastImageWithAsset:asset targetSize:CGSizeMake(120, 120) resultHandler:^(UIImage *image) {
        self.ivPreview.image = image;
    }];
}

- (void)onClickToSelect:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (_selectBlock) _selectBlock(sender.selected);
}



@end
