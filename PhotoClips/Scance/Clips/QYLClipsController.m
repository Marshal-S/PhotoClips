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

@end

@implementation QYLClipsController

+ (instancetype)clipsWithType:(QYLPhotoClipType)clipType {
    QYLClipsController *instance = [self new];
    if (instance) {
        instance.clipType = clipType;
    }
    return instance;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initWithContentView];
}

- (void)initWithContentView {
    CGRect frame;
    switch (_clipType) {
        case <#constant#>:
            <#statements#>
            break;
            
        default:
            break;
    })
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.frame];
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





@end
