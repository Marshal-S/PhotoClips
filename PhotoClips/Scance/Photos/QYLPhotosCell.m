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
{
    PHImageRequestID _irID;
}

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
    _ivPreview.contentMode = UIViewContentModeScaleAspectFill;
    _ivPreview.clipsToBounds = YES;
    [self.contentView addSubview:_ivPreview];
    
    _btnSelect = [[UIButton alloc] initWithFrame:CGRectMake(_ivPreview.s_right-60, 0, 60, 60)];
    _btnSelect.contentMode = UIViewContentModeScaleAspectFit;
    _btnSelect.imageEdgeInsets = UIEdgeInsetsMake(-20, 0, 0, -20);//图片向上偏移，但是大小足够摁住
    [_btnSelect setImage:[UIImage imageNamed:@"checkbox_n"] forState:UIControlStateNormal];
    [_btnSelect setImage:[UIImage imageNamed:@"checkbox_s"] forState:UIControlStateSelected];
    [_btnSelect addTarget:self action:@selector(onClickToSelect:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_btnSelect];
}

- (void)updateWithPhotoModel:(QYLPhotoModel *)photoModel {
    [[PHImageManager defaultManager] cancelImageRequest:_irID];
    _irID = [[QYLPhotosManager sharedInstance] getFastImageWithAsset:photoModel.asset targetSize:CGSizeMake(240, 240) resultHandler:^(UIImage *image) {
        self.ivPreview.image = image;
    }];
}

- (void)onClickToSelect:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (_selectBlock) _selectBlock(sender.selected);
}



@end
