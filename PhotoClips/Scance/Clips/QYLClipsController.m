//
//  QYLClipsController.m
//  PhotoClips
//
//  Created by Marshal on 2018/5/16.
//  Copyright © 2018年 Marshal. All rights reserved.
//

#import "QYLClipsController.h"
#import "QYLPhotosManager.h"

@interface QYLClipsController ()

@property (nonatomic, assign) QYLPhotoClipType clipType;
@property (nonatomic, strong) NSArray<QYLPhotoModel *> *clipsList;
@property (nonatomic, strong) UIImageView *ivClipsImage;
@property (nonatomic, assign) double ratio;

@end

@implementation QYLClipsController

+ (instancetype)clipsWithType:(QYLPhotoClipType)clipType clipsList:(NSArray<QYLPhotoModel *> *)clipsList {
    QYLClipsController *instance = [self new];
    if (instance) {
        instance.clipType = clipType;
        instance.clipsList = clipsList;
    }
    return instance;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initWithContentView];
}

- (void)initWithContentView {
    //屏幕宽度
    CGFloat width = SCREEN_WIDTH;
    CGFloat height = SCREEN_HEIGHT;
    //剪裁框的宽和高
    
    CGRect frame;
    switch (_clipType) {
        case QYLPhotoClipType9_16:
            
            break;
        case QYLPhotoClipType1_2:
            
            break;
    }
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





@end
