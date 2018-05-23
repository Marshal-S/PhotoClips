//
//  QYLProgressView.m
//  Album
//
//  Created by Marshal on 2017/10/18.
//  Copyright © 2017年 Marshal. All rights reserved.
//

#import "QYLProgressView.h"

@implementation QYLProgressView

+ (instancetype)sharedInstance {
    static QYLProgressView *progressView = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        progressView = [[self alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        progressView.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
        progressView.bounds = CGRectMake(0, 0, 50, 50);
        progressView.color = [UIColor redColor];
    });
    return progressView;
}

+ (void)show {
    QYLProgressView *progressView = [self sharedInstance];
    if (!progressView.isAnimating) {
        [progressView startAnimating];
        [[UIApplication sharedApplication].delegate.window.rootViewController.view addSubview:progressView];
    }
}

+ (void)showInView:(UIView *)superView {
    QYLProgressView *progressView = [self sharedInstance];
    if (!progressView.isAnimating) {
        [progressView startAnimating];
        [superView addSubview:progressView];
    }
}

+ (void)dismiss {
    QYLProgressView *progress = [self sharedInstance];
    [progress stopAnimating];
    [progress removeFromSuperview];
}

@end
