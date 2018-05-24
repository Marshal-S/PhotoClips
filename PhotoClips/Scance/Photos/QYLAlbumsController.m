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
#import "QYLCommonUtil.h"

@interface QYLAlbumsController ()

@property (nonatomic, assign) QYLPhotoClipType clipType;
@property (nonatomic, strong) QYLAlbumsView *albumsView;

@end

@implementation QYLAlbumsController

+ (instancetype)clipWithType:(QYLPhotoClipType)clipType {
    QYLAlbumsController *instance = [self new];
    if (instance) {
        instance.clipType = clipType;
    }
    return instance;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"相册";
    [self authorizationed];
}

//授权
- (void)authorizationed {
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusAuthorized) {
        [self initAlbumsView];
        return;
    }
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        switch (status) {
            case PHAuthorizationStatusNotDetermined:
                break;
            case PHAuthorizationStatusDenied:
            case PHAuthorizationStatusRestricted:{
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"权限警告" message:@"检测到您尚未打开相册权限，将无法使用相册相关功能!" preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:nil]];
                [alert addAction:[UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [QYLCommonUtil openUrl:UIApplicationOpenSettingsURLString];
                }]];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self presentViewController:alert animated:YES completion:nil];
                });
            }break;
            case PHAuthorizationStatusAuthorized:{
                [self initAlbumsView];
            }break;
        }
    }];
}

- (void)initAlbumsView {
    NSArray<QYLAblumModel *> *albums = [[QYLPhotosManager sharedInstance] getAllSmartAlbums];
    _albumsView = [[QYLAlbumsView alloc] initWithFrame:CGRectMake(0, topHeight, SCREEN_WIDTH, SCREEN_HEIGHT-topHeight) albumList:albums];
    if (@available(iOS 11.0, *)) {
        _albumsView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    Weakify(self);
    [_albumsView setOnClickToSelectBlock:^(NSInteger row) {
        QYLPhotoSelectController *select = [QYLPhotoSelectController selectWithAssetCollection:albums[row].assetCollection clipType:wself.clipType];
        [wself.navigationController pushViewController:select animated:YES];
    }];
    [self.view addSubview:_albumsView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
