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
    CGRect _clipLineFrame;//选框frame
    BOOL _widthBigRatio;//图片宽占比比较大
    CGPoint startPoint;
    CGPoint originPoint;
}

@property (weak, nonatomic) IBOutlet UIView *operateBar;

@property (nonatomic, assign) QYLPhotoClipType clipType;
@property (nonatomic, strong) NSMutableArray<QYLPhotoModel *> *clipsList;
@property (nonatomic, strong) UIView *clipsView;//选框
@property (nonatomic, strong) UIImageView *ivClipsImage;
@property (nonatomic, assign) double ratio;//绘制的时候图片或者偏移像素大小要乘上他

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
    _ivClipsImage.image = nil;
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
    CGSize clipLineSize = _clipLineFrame.size;
    if (ratio > needRadio) {
        //这里是宽比较大
        _widthBigRatio = YES;
        _ratio = size.height/clipLineSize.height;
        size = CGSizeMake(clipLineSize.height*ratio, clipLineSize.height);
    }else {
        _widthBigRatio = NO;
        _ratio = size.width/clipLineSize.width;
        size = CGSizeMake(clipLineSize.width, clipLineSize.width/ratio);
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

    _clipLineFrame = CGRectMake((width-size.width)/2, (height-size.height)/2, size.width, size.height);
    //绘制选框
    _clipsView = [[UIView alloc] initWithFrame:_clipLineFrame];
    _clipsView.userInteractionEnabled = NO;
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
    CGPoint point = [sender translationInView:self.view];
    if (sender.state == UIGestureRecognizerStateBegan) {
        startPoint = point;
        originPoint = sender.view.frame.origin;
    }else if (sender.state == UIGestureRecognizerStateChanged) {
        CGFloat cx = point.x-startPoint.x;
        CGFloat cy = point.y-startPoint.y;
        //因为可以上下滑动，所以要根据宽高比来测定
        CGRect frame = sender.view.frame;
        if (_widthBigRatio) {
            //这里会用到cx
            if (cx + sender.view.s_X > _clipLineFrame.origin.x || sender.view.s_right - cx < _clipLineFrame.origin.x + _clipLineFrame.size.width) return;
            frame.origin.x = originPoint.x + cx;
        }else {
            frame.origin.y = originPoint.y + cy;
            //这里会用到cy
            if (cy + sender.view.s_Y > _clipLineFrame.origin.y || sender.view.s_bottom - cy < _clipLineFrame.origin.y + _clipLineFrame.size.height) return;
        }
        sender.view.frame = frame;
    }
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
