//
//  QYLClipsController.m
//  PhotoClips
//
//  Created by Marshal on 2018/5/16.
//  Copyright © 2018年 Marshal. All rights reserved.
//

#import "QYLClipsController.h"
#import "QYLPhotosManager.h"
#import "UIView+S_Extend.h"

@interface QYLClipsController ()
{
    CGSize _clipLineSize;//选框大小
    BOOL _isLargeImageWidthRatio;//图片宽占比比较大么
}

@property (weak, nonatomic) IBOutlet UIView *operateBar;

@property (nonatomic, assign) QYLPhotoClipType clipType;
@property (nonatomic, strong) NSMutableArray<QYLPhotoModel *> *clipsList;
@property (nonatomic, strong) UIView *clipsView;//选框
@property (nonatomic, strong) UIImageView *ivClipsImage;
@property (nonatomic, assign) double ratio;

@property (nonatomic, assign) BOOL operateHidden;//底部选择框是否消失

@end

@implementation QYLClipsController

+ (instancetype)clipsWithType:(QYLPhotoClipType)clipType clipsList:(NSArray<QYLPhotoModel *> *)clipsList {
    QYLClipsController *instance = [self new];
    if (instance) {
        instance.clipType = clipType;
        instance.clipsList = [NSMutableArray array];
        instance.clipsList.array = clipsList;
    }
    return instance;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initClipsView];
    [self initImageView];
    [self requestImage];
    [self initGes];
}

- (void)initImageView {
    _ivClipsImage = [[UIImageView alloc] init];
    _ivClipsImage.contentMode = UIViewContentModeScaleAspectFit;
    _ivClipsImage.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
    _ivClipsImage.userInteractionEnabled = YES;
    [self.view insertSubview:_ivClipsImage belowSubview:_clipsView];
}

- (void)requestImage {
    if (_clipsList.count < 1) return;
    [[QYLPhotosManager sharedInstance] getExactImageWithAsset:_clipsList[0].asset resultHandler:^(UIImage *image) {
        [self setUpClipsViewWithImage:image];
    }];
}

- (void)setUpClipsViewWithImage:(UIImage *)image {
    CGSize size = image.size;
    double ratio = size.width/size.height;
    double needRadio = 0;
    switch (_clipType) {
        case QYLPhotoClipType9_16:
            needRadio = 9.0/16;
            break;
        case QYLPhotoClipType1_2:
            needRadio = 0.5;
            break;
    }
    if (ratio > needRadio) {
        //这里是宽比较大
        _isLargeImageWidthRatio = YES;
        size = CGSizeMake(_clipLineSize.height*ratio, _clipLineSize.height);
    }else {
        _isLargeImageWidthRatio = NO;
        size = CGSizeMake(_clipLineSize.width, _clipLineSize.width/ratio);
    }

    _ivClipsImage.bounds = CGRectMake(0, 0, size.width, size.height);
    _ivClipsImage.image = image;
}

- (void)initClipsView {
    //获取选框大小
    CGFloat width = SCREEN_WIDTH;
    CGFloat height = SCREEN_HEIGHT;
    CGFloat ratio = width/height;
    CGSize size;
    switch (_clipType) {
        case QYLPhotoClipType9_16:{
            double needRadio = 9.0/16;
            if (ratio > needRadio) {
                //手机比图片宽度上宽一些,此时按照手机长度加上需要radio来定框
                size = CGSizeMake(needRadio*height, height);
            }else if (ratio < needRadio) {
                //手机比图片长度上要长一些
                size = CGSizeMake(width, width/ratio);
            }else {
                //两方相同
                size = CGSizeMake(width, height);
            }
        }break;
        case QYLPhotoClipType1_2:{
            if (ratio > 0.5) {
                //手机比图片宽度上宽一些
                size = CGSizeMake(0.5*height, height);
            }else if (ratio < 0.5) {
                //手机比图片长度上要长一些
                size = CGSizeMake(width, width/0.5);
            }else {
                //两方相同
                size = CGSizeMake(width, height);
            }
        }break;
    }
    _clipLineSize = size;

    //绘制选框
    _clipsView = [[UIView alloc] init];
    _clipsView.bounds = CGRectMake(0, 0, size.width, size.height);
    _clipsView.center = CGPointMake(width/2, height/2);
    [self.view insertSubview:_clipsView belowSubview:_operateBar];
}

//初始化手势操作
- (void)initGes {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showHiddenOperateBar)];
    [self.view addGestureRecognizer:tap];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(clipImageWillScroll:)];
    [_ivClipsImage addGestureRecognizer:pan];
}

//操作操作框
- (void)showHiddenOperateBar {
    _operateHidden = !_operateHidden;
    [UIView animateWithDuration:0.3 animations:^{
        if (self.operateHidden) {
            self.operateBar.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, 88);
        }else {
            self.operateBar.transform = CGAffineTransformIdentity;
        }
    }];
    
}

//图片移动控制处理
- (void)clipImageWillScroll:(UIPanGestureRecognizer *)sender {
    //因为可以上下滑动，所以要根据宽高比来测定
    
}

- (IBAction)onClickToOperate:(UIButton *)sender {
    NSInteger tag = sender.tag;
    if (tag == 100) {
        //结束
        [self backToHome];
    }else if (tag == 102) {
        //跳过
        [self nextClip];
    }else {
        //剪裁
        [self onClickToClip];
        [self nextClip];
    }
}

//实际剪裁
- (void)onClickToClip {
    
}

//下一张,剪裁的步骤同理
- (void)nextClip {
    [ _clipsList removeObjectAtIndex:0];
    if (_clipsList.count < 1) {
        [self backToHome];
        [QYLToast showWithMessage:@"本次剪裁已结束!"];
    }
}

//返回到主页
- (void)backToHome {
    [self dismissViewControllerAnimated:NO completion:^{
        //结束后，返回到主页
        [(UINavigationController *)([UIApplication sharedApplication].delegate.window.rootViewController) popToRootViewControllerAnimated:YES];
    }];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
