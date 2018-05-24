//
//  QYLPhotosSelectCell.m
//  PhotoClips
//
//  Created by Marshal on 2018/5/11.
//  Copyright © 2018年 Marshal. All rights reserved.
//

#import "QYLPhotosCell.h"
#import "QYLPhotosManager.h"
#import "NSObject+S_Observer.h"

@interface QYLPhotosCell ()
{
    PHImageRequestID _irID;
    QYLPhotoModel *_photoModel;
}

@property (nonatomic, strong) UIImageView *ivPreview; //预览图
@property (nonatomic, strong) UIButton *btnSelect;
@property (nonatomic, strong) UIImageView *ivDownload;//下载视图，不在本地的需要


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
    
    _ivDownload = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 20, 20)];
    _ivDownload.contentMode = UIViewContentModeScaleAspectFit;
    _ivDownload.image = [UIImage imageNamed:@"download"];
    _ivDownload.hidden = YES;
    [self.contentView addSubview:_ivDownload];
}

- (void)updateWithPhotoModel:(QYLPhotoModel *)photoModel {
    _btnSelect.selected = photoModel.isSelect;
    [[PHImageManager defaultManager] cancelImageRequest:_irID];
    _irID = [[QYLPhotosManager sharedInstance] getFastImageWithAsset:photoModel.asset targetSize:CGSizeMake(240, 240) resultHandler:^(UIImage *image) {
        self.ivPreview.image = image;
    }];
    
    Weakify(self);
    LSObserver(photoModel, isUserLibrary, ObserverCallback(^(id x) {
        wself.ivDownload.hidden = [x boolValue];
    }));
    
    if (photoModel.isUserLibrary == -1) {
        [[QYLPhotosManager sharedInstance] verifyPhotoInUserLibraryWithAsset:photoModel.asset completed:^(BOOL isUserLibrary) {
            photoModel.isUserLibrary = isUserLibrary;
        } synchronized:NO];
    }else {
        _ivDownload.hidden = photoModel.isUserLibrary;
    }
    _photoModel = photoModel;
}

- (void)onClickToSelect:(UIButton *)sender {
    BOOL selected = !sender.selected;
    if (!_selectBlock(selected)) return;
    _photoModel.isSelect = sender.selected = selected;
}



@end
