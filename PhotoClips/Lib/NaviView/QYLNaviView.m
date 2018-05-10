//
//  QYLNaviView.m
//  ChargingPile
//
//  Created by Marshal on 2017/12/29.
//  Copyright © 2017年 Marshal. All rights reserved.
//

#import "QYLNaviView.h"

CGFloat nvHeight = 44;

@interface QYLNaviView ()

@property (nonatomic, strong) UIButton *btnLeft;
@property (nonatomic, strong) UILabel *lblTitle;
@property (nonatomic, strong) UIButton *btnRight;

@end

@implementation QYLNaviView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame makeContents:(void(^)(QYLNaviView *make))makeContents {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        makeContents(self);
    }
    return self;
}

+ (instancetype)viewWithSuperView:(UIView *)superView {
    return [superView viewWithTag:111111];
}

+ (instancetype)viewWithSuperView:(UIView *)superView makeContents:(void(^)(QYLNaviView *make))makeContents {
    QYLNaviView *navi = [superView viewWithTag:111111];
    if (navi && makeContents) makeContents(navi);
    return navi;
}

- (UILabel *)lblTitle {
    if (!_lblTitle) {
        _lblTitle = [[UILabel alloc] init];
        _lblTitle.textAlignment = NSTextAlignmentCenter;
        _lblTitle.font = [UIFont boldSystemFontOfSize:17];
        _lblTitle.backgroundColor = [UIColor clearColor];
        [self addSubview:_lblTitle];
    }
    return _lblTitle;
}

- (UIButton *)btnLeft {
    if (!_btnLeft) {
        _btnLeft = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, nvHeight)];
        [_btnLeft setImage:[UIImage imageNamed:@"back_gray"] forState:UIControlStateNormal];
        [_btnLeft setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _btnLeft.tag = 1001;
        [_btnLeft addTarget:self action:@selector(onClickToOperate:) forControlEvents:UIControlEventTouchUpInside];
        _btnLeft.backgroundColor = [UIColor clearColor];
        [self addSubview:_btnLeft];
    }
    return _btnLeft;
}

- (UIButton *)btnRight {
    if (!_btnRight) {
        _btnRight = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-60, 0, 60, nvHeight)];
        _btnRight.tag = 1002;
        _btnRight.titleLabel.font = [UIFont systemFontOfSize:16];
        [_btnRight setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_btnRight addTarget:self action:@selector(onClickToOperate:) forControlEvents:UIControlEventTouchUpInside];
        _btnRight.backgroundColor = [UIColor clearColor];
        [self addSubview:_btnRight];
    }
    return _btnRight;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    if (newSuperview) {
        _animated = YES;
        CGFloat width = SCREEN_WIDTH;
        self.tag = 111111;
        self.bounds = CGRectMake(0, 0, width, nvHeight);
        [self btnLeft];
        if (_noShadow) return;
        //下面给自己底部添加阴影,不会离屏渲染
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowRadius = 3;
        self.layer.shadowOpacity = 0.6;
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 44, width, 4)];
        self.layer.shadowPath = path.CGPath;
    }
}

- (instancetype)setTitle:(NSString *)title {
    self.lblTitle.text = title;
    CGFloat width = [_lblTitle sizeThatFits:CGSizeMake(0, 30)].width+2;
    _lblTitle.frame = CGRectMake((SCREEN_WIDTH-width)/2, 0, width, nvHeight);
    return self;
}

- (instancetype)setTitleImage:(UIImage *)image {
    CGSize size = image.size;
    CGFloat width = 0;
    CGFloat height = nvHeight;
    if (size.height > nvHeight) {
        width = nvHeight/size.height*size.width;
    }else {
        width = size.width;
        height = size.height;
    }
    CALayer *lTitle = [CALayer layer];
    lTitle.frame = CGRectMake((self.frame.size.width-width)/2, (nvHeight-height)/2, width, height);
    lTitle.contentsGravity = kCAGravityResizeAspect;
    lTitle.contents = (__bridge id _Nullable)(image.CGImage);
    [self.layer addSublayer:lTitle];
    return self;
}

- (void)setLeftBlock:(void(^)(void))leftBlock {
    [self btnLeft];
    _leftBlock = leftBlock;
}

- (instancetype)setLeftImage:(UIImage *)image {
    [self.btnLeft setImage:image forState:UIControlStateNormal];
    return self;
}

- (instancetype)setLeftTitle:(NSString *)title image:(UIImage *)image {
    [self.btnLeft setImage:image forState:UIControlStateNormal];
    _btnLeft.titleLabel.font = [UIFont systemFontOfSize:16];
    [_btnLeft setTitle:title forState:UIControlStateNormal];
    _btnLeft.titleEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 0);
    CGFloat width = [_btnLeft.titleLabel sizeThatFits:CGSizeMake(0, nvHeight)].width+image.size.width+28;
    _btnLeft.frame = CGRectMake(0, 0, width, nvHeight);
    return self;
}

- (void)setRightBlock:(void(^)(void))rightBlock {
    [self btnRight];
    _rightBlock = rightBlock;
}

- (instancetype)setRightImage:(UIImage *)image {
    [self.btnRight setImage:image forState:UIControlStateNormal];
    return self;
}

- (instancetype)setRightTitle:(NSString *)title {
    [self.btnRight setTitle:title forState:UIControlStateNormal];
    _btnRight.titleLabel.font = [UIFont systemFontOfSize:15];
    CGFloat width = [_btnRight.titleLabel sizeThatFits:CGSizeMake(0, nvHeight)].width+28;
    _btnRight.frame = CGRectMake(SCREEN_WIDTH-width, 0, width, nvHeight);
    return self;
}

- (instancetype)setRightTitle:(NSString *)title image:(UIImage *)image {
    [self.btnRight setTitle:title forState:UIControlStateNormal];
    [_btnRight setImage:image forState:UIControlStateNormal];
    _btnRight.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 8);
    CGFloat width = [_btnRight.titleLabel sizeThatFits:CGSizeMake(0, nvHeight)].width+image.size.width+28;
    _btnRight.frame = CGRectMake(SCREEN_WIDTH-width, 0, width, nvHeight);
    return self;
}

- (void)onClickToOperate:(UIButton *)sender {
    //到这李一般都会有block
    if (sender.tag == 1002) {
        if (_rightBlock) _rightBlock();
    }else {
        if (_leftBlock) _leftBlock();
        else [((UINavigationController *)([UIApplication sharedApplication].delegate.window.rootViewController)) popViewControllerAnimated:_animated];
    }
}

QYLDealloc

@end
