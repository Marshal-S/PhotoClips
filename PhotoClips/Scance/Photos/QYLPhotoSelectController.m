//
//  QYLPhotoSelectController.m
//  PhotoClips
//
//  Created by Marshal on 2018/5/16.
//  Copyright © 2018年 Marshal. All rights reserved.
//

#import "QYLPhotoSelectController.h"
#import "QYLPhotosView.h"
#import "QYLLargeImageController.h"

@interface QYLPhotoSelectController ()
{
    PHAssetCollection *_assetCollection;
}

@property (nonatomic, strong) QYLPhotosView *photosView;

@end

@implementation QYLPhotoSelectController

+ (instancetype)selectWithAssetCollection:(PHAssetCollection *)assetCollection {
    QYLPhotoSelectController *select = [self new];
    if (select) {
        select->_assetCollection = assetCollection;
    }
    return select;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initPhotoView];
}

- (void)initPhotoView {
    NSArray<QYLPhotoModel *> *photoList = [[QYLPhotosManager sharedInstance] getAssetsInAssetCollection:_assetCollection ascending:NO];
    _photosView = [[QYLPhotosView alloc] initWithFrame:CGRectMake(10, topHeight, SCREEN_WIDTH-20, SCREEN_HEIGHT-topHeight) photoList:photoList];
    if (@available(iOS 11.0, *)) {
        _photosView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    Weakify(self);
    [_photosView setOnClickToCheckLargeBlock:^(NSInteger row) {
        QYLLargeImageController *large = [[QYLLargeImageController alloc] initWithAsset:photoList[row].asset];
        [wself presentViewController:large animated:YES completion:nil];
    }];
    [self.view addSubview:_photosView];
}

- (void)onClickToSelect {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
