//
//  QYLPhotosSelectController.m
//  PhotoClips
//
//  Created by Marshal on 2018/5/11.
//  Copyright © 2018年 Marshal. All rights reserved.
//

#import "QYLPhotosSelectController.h"
#import "QYLPhotosManager.h"
#import "QYLAlbumsView.h"
#import "QYLPhotosView.h"

@interface QYLPhotosSelectController ()

@property (nonatomic, assign) QYLPhotoClipType clipType;

@property (nonatomic, strong) QYLAlbumsView *albumsView;
@property (nonatomic, strong) QYLPhotosView *photosView;

@end

@implementation QYLPhotosSelectController

+ (instancetype)selectWithClipType:(QYLPhotoClipType)clipType {
    QYLPhotosSelectController *instance = [self new];
    if (instance) {
        instance.clipType = clipType;
    }
    return instance;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initAlbumsView];
}

- (void)initAlbumsView {
    NSArray *albums = [[QYLPhotosManager sharedInstance] getAllSmartAlbums];
    _albumsView = [[QYLAlbumsView alloc] initWithFrame:CGRectMake(10, topHeight + 10, SCREEN_WIDTH-20, SCREEN_HEIGHT-topHeight-10) albumList:albums];
    [self.view addSubview:_albumsView];
}

- (void)initPhotosView {
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
