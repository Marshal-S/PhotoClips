//
//  QYLProgressView.h
//  Album
//
//  Created by Marshal on 2017/10/18.
//  Copyright © 2017年 Marshal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QYLProgressView : UIActivityIndicatorView

+ (void)show;

+ (void)showInView:(UIView *)superView;

+ (void)dismiss;

@end
