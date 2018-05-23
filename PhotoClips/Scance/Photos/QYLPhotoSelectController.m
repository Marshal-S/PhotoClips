//
//  QYLPhotoSelectController.m
//  PhotoClips
//
//  Created by Marshal on 2018/5/16.
//  Copyright © 2018年 Marshal. All rights reserved.
//

#import "QYLPhotoSelectController.h"
#import "QYLPhotosView.h"
#import "QYLClipsController.h"
#import "QYLLargeImageController.h"

@interface QYLPhotoSelectController ()
{
    PHAssetCollection *_assetCollection;
}

@property (nonatomic, strong) UIButton *btnRight;//导航右侧按钮

@property (nonatomic, assign) QYLPhotoClipType clipType;
@property (nonatomic, strong) QYLPhotosView *photosView;
@property (nonatomic, strong) NSMutableArray *selectList;

@end

@implementation QYLPhotoSelectController

+ (instancetype)selectWithAssetCollection:(PHAssetCollection *)assetCollection clipType:(QYLPhotoClipType)clipType {
    QYLPhotoSelectController *select = [self new];
    if (select) {
        select->_assetCollection = assetCollection;
        select.clipType = clipType;
    }
    return select;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"图片选择";
    [self setNavi];
    [self initPhotoView];
}

- (void)setNavi {
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"裁剪" style:UIBarButtonItemStylePlain target:self action:@selector(onClickToSelect)];
    self.navigationItem.rightBarButtonItem = right;
}

- (void)initPhotoView {
    _selectList = [NSMutableArray array];//初始化选中数组
    
    NSArray *photoList = [[QYLPhotosManager sharedInstance] getAssetsInAssetCollection:_assetCollection ascending:NO];
    
    _photosView = [[QYLPhotosView alloc] initWithFrame:CGRectMake(0, topHeight, SCREEN_WIDTH, SCREEN_HEIGHT-topHeight) photoList:photoList];
    if (@available(iOS 11.0, *)) {
        _photosView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    Weakify(self);
    [_photosView setOnClickToSelectBlock:^(QYLPhotoModel *photoModel, BOOL selected) {
        if (selected) {
            if (wself.selectList.count > 10) {
                [QYLToast showWithMessage:@"最多选取10个!"];
                return NO;
            }
            [wself.selectList addObject:photoModel];
        }else {
            [wself.selectList removeObject:photoModel];
        }
        long count = wself.selectList.count;
        [wself.navigationItem.rightBarButtonItem setTitle:[NSString stringWithFormat:@"剪裁%@",count>0?[NSString stringWithFormat:@"(%ld)",count]:@""]];
        return YES;
    }];
    [_photosView setOnClickToCheckLargeBlock:^(NSInteger row) {
        QYLLargeImageController *large = [[QYLLargeImageController alloc] initWithPhotoModel:photoList[row]];
        [wself presentViewController:large animated:YES completion:nil];
    }];
    [self.view addSubview:_photosView];
}

- (void)onClickToSelect {
    if (_selectList.count < 1) return;
    QYLClipsController *clip = [QYLClipsController clipsWithType:_clipType clipsList:_selectList];
    [self presentViewController:clip animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
