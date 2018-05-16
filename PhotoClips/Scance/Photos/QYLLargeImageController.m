//
//  QYLLargeImageController.m
//  PhotoClips
//
//  Created by Marshal on 2018/5/16.
//  Copyright © 2018年 Marshal. All rights reserved.
//

#import "QYLLargeImageController.h"
#import "QYLPhotosManager.h"

@interface QYLLargeImageController ()<UIScrollViewDelegate>
{
    PHAsset *_asset;
}

@property (nonatomic, strong) UIScrollView *scrollView;

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
    self.view.backgroundColor = [UIColor blackColor];
    [self initContentView];
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(back)]];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}
     
- (void)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)initContentView {
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _scrollView.tag = 14;
    self.view.backgroundColor = _scrollView.backgroundColor = [UIColor blackColor];
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.bounces = NO;
    _scrollView.maximumZoomScale = 8;
    _scrollView.minimumZoomScale = 1;
    [_scrollView setZoomScale:1];
    _scrollView.delegate = self;
    _scrollView.contentSize = self.view.frame.size;
    [self.view addSubview:_scrollView];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.frame];
    imageView.tag = 15;
    imageView.center = self.view.center;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [_scrollView addSubview:imageView];
    [[QYLPhotosManager sharedInstance] getExactImageWithAsset:_asset resultHandler:^(UIImage *image) {
        imageView.image = image;
    }];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return [scrollView viewWithTag:15];
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    UIView *iv = [scrollView viewWithTag:15];
    CGRect frame = iv.frame;
    CGFloat subH = scrollView.frame.size.height - iv.frame.size.height;
    frame.origin.y = subH > 0 ? subH * 0.5 : 0;
    CGFloat subW = scrollView.frame.size.width - iv.frame.size.width;
    frame.origin.x = subW > 0 ? subW * 0.5 : 0;
    iv.frame = frame;
    scrollView.contentSize = CGSizeMake(iv.frame.size.width, iv.frame.size.height);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
