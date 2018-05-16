//
//  QYLLargeImageController.m
//  PhotoClips
//
//  Created by Marshal on 2018/5/16.
//  Copyright © 2018年 Marshal. All rights reserved.
//

#import "QYLLargeImageController.h"
#import "QYLPhotosManager.h"

@interface QYLLargeImageController ()
{
    PHAsset *_asset;
}

@end

@implementation QYLLargeImageController

- (instancetype)initWithAsset:(PHAsset *)asset {
    if (self = [super init]) {
        _asset = asset;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initImageView];
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(back)]];
}

- (void)initImageView {
    UIImageView *iv = [[UIImageView alloc] initWithFrame:self.view.bounds];
    iv.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:iv];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [[QYLPhotosManager sharedInstance] getExactImageWithAsset:_asset resultHandler:^(UIImage *image) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        iv.image = image;
    }];
}
     
- (void)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
