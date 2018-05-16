//
//  QYLPhotosSelectController.m
//  PhotoClips
//
//  Created by Marshal on 2018/5/11.
//  Copyright © 2018年 Marshal. All rights reserved.
//

#import "QYLAlbumsController.h"
#import "QYLAlbumsView.h"
#import "QYLPhotoSelectController.h"

@interface QYLAlbumsController ()
{
    QYLPhotoClipType _clipType;
}

@property (nonatomic, strong) QYLAlbumsView *albumsView;

@end

@implementation QYLAlbumsController

+ (instancetype)clipWithType:(QYLPhotoClipType)clipType {
    QYLAlbumsController *instance = [self new];
    if (instance) {
        instance->_clipType = clipType;
    }
    return instance;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initAlbumsView];
}

- (void)initAlbumsView {
    NSArray<QYLAblumModel *> *albums = [[QYLPhotosManager sharedInstance] getAllSmartAlbums];
    _albumsView = [[QYLAlbumsView alloc] initWithFrame:CGRectMake(10, topHeight, SCREEN_WIDTH-20, SCREEN_HEIGHT-topHeight) albumList:albums];
    if (@available(iOS 11.0, *)) {
        _albumsView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    Weakify(self);
    [_albumsView setOnClickToSelectBlock:^(NSInteger row) {
        QYLPhotoSelectController *select = [QYLPhotoSelectController selectWithAssetCollection:albums[row].assetCollection];
        [wself.navigationController pushViewController:select animated:YES];
    }];
    [self.view addSubview:_albumsView];
}

- (void)initPhotosView {
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
