//
//  QYLNaviView.h
//  ChargingPile
//
//  Created by Marshal on 2017/12/29.
//  Copyright © 2017年 Marshal. All rights reserved.
//  注意他一定要加入到视图的最外层，因为在底部会被挡住，并且底部没有视图不会有阴影

#import <UIKit/UIKit.h>

@interface QYLNaviView : UIView

@property (nonatomic, assign) BOOL animated;//返回按钮是否带动画效果，默认为YES
@property (nonatomic, assign) BOOL noShadow;//是否不要阴影，默认为NO,即有阴影

/// @brief 左侧按钮回调事件为点击事件,前面的参数为在返回键后面追加的字符串，不填写默认为返回按钮
@property (nonatomic, strong, readonly) UIButton *btnLeft;
@property (nonatomic, copy) void (^leftBlock)(void);
- (instancetype)setLeftImage:(UIImage *)image;//设置图片
- (instancetype)setLeftTitle:(NSString *)title image:(UIImage *)image;//均不能为空

/// @brief 导航标题
@property (nonatomic, strong, readonly) UILabel *lblTitle;
- (instancetype)setTitle:(NSString *)lblTitle;
- (instancetype)setTitleImage:(UIImage *)image;

/// @brief 右侧按钮回调事件为点击事件,前面的参数为在返回键后面追加的字符串
@property (nonatomic, strong, readonly) UIButton *btnRight;
@property (nonatomic, copy) void (^rightBlock)(void);
- (instancetype)setRightImage:(UIImage *)image;//默认没有图片
- (instancetype)setRightTitle:(NSString *)title;//默认没有标题
- (instancetype)setRightTitle:(NSString *)title image:(UIImage *)image;//参数均不能为空，否则可能会抛出异常或者显示不正常

//用于直接从父视图上获取NaviView，如果不存在会返回为空,不需要直接从xib上拉取
+ (instancetype)viewWithSuperView:(UIView *)superView;
+ (instancetype)viewWithSuperView:(UIView *)superView makeContents:(void(^)(QYLNaviView *make))makeContents;
/*修改属性较多的话可以这么写，上面也一样
 [self.view addSubview:[[QYLNaviView alloc] initWithFrame:CGRectMake(0, statusBarHeight, SCREEN_WIDTH, 44) makeContents:^(QYLNaviView *make) {
    [make setTitle:@"扫码充电"];
    [make setLeftImage:[UIImage imageNamed:@"back_white"]];
    [make.lblTitle setTextColor:[UIColor whiteColor]];
    [make setBackgroundColor:[UIColor clearColor]];
 }]];
 */
- (instancetype)initWithFrame:(CGRect)frame makeContents:(void(^)(QYLNaviView *make))makeContents;

@end
