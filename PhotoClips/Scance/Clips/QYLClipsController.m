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
#import "QYLProgressView.h"

@interface QYLClipsController ()
{
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

@property (nonatomic, assign) CGRect clipLineFrame;//选框frame
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
    _ivClipsImage.userInteractionEnabled = YES;
    [self.view insertSubview:_ivClipsImage belowSubview:_clipsView];
}

- (void)requestImage {
    if (_clipsList.count < 1) return;
    _ivClipsImage.image = nil;
    [QYLProgressView showInView:self.view];
    [[QYLPhotosManager sharedInstance] getExactImageWithAsset:_clipsList[0].asset resultHandler:^(UIImage *image) {
        [self setUpClipsViewWithImage:image];
        [QYLProgressView dismiss];
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
    _ivClipsImage.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
    _ivClipsImage.image = image;
}

- (void)initClipsView {
    //获取选框大小
    CGFloat width = SCREEN_WIDTH-30;
    CGFloat height = SCREEN_HEIGHT-30;
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
                size = CGSizeMake(width, width/needRadio);
            }else {
                //两方相同
                size = CGSizeMake(width, height);
            }
        }break;
        case QYLPhotoClipType1_2:{
            double needRadio = 0.5;
            if (ratio > needRadio) {
                //手机比图片宽度上宽一些
                size = CGSizeMake(needRadio*height, height);
            }else if (ratio < needRadio) {
                //手机比图片长度上要长一些
                size = CGSizeMake(width, width/needRadio);
            }else {
                //两方相同
                size = CGSizeMake(width, height);
            }
        }break;
    }
    
    _clipLineFrame = CGRectMake((SCREEN_WIDTH-size.width)/2, (SCREEN_HEIGHT-size.height)/2, size.width, size.height);
    //绘制选框
    _clipsView = [[UIView alloc] initWithFrame:self.view.frame];
    _clipsView.userInteractionEnabled = NO;
    [self.view insertSubview:_clipsView belowSubview:_operateBar];
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [path appendPath:[[UIBezierPath bezierPathWithRect:_clipLineFrame] bezierPathByReversingPath]];
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.fillColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8].CGColor;
    layer.backgroundColor = [UIColor clearColor].CGColor;
    layer.lineWidth = 0;
    layer.path = path.CGPath;
    [_clipsView.layer addSublayer:layer];
    
    //边界线
    CGFloat x = _clipLineFrame.origin.x;
    CGFloat y = _clipLineFrame.origin.y;
    CGFloat w = _clipLineFrame.size.width;
    CGFloat h = _clipLineFrame.size.height;
    CGFloat right = x+w;
    CGFloat bottom = y+h;
    CGFloat marginWidth = 10;
    
    path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(x-2, y+marginWidth)];
    [path addLineToPoint:CGPointMake(x-2, y-2)];
    [path addLineToPoint:CGPointMake(x+marginWidth, y-2)];
    
    [path moveToPoint:CGPointMake(right-marginWidth, y-2)];
    [path addLineToPoint:CGPointMake(right+2, y-2)];
    [path addLineToPoint:CGPointMake(right+2, y+marginWidth)];
    
    [path moveToPoint:CGPointMake(right+2, bottom-marginWidth)];
    [path addLineToPoint:CGPointMake(right+2, bottom+2)];
    [path addLineToPoint:CGPointMake(right-marginWidth, bottom+2)];
    
    [path moveToPoint:CGPointMake(x-2, bottom-marginWidth)];
    [path addLineToPoint:CGPointMake(x-2, bottom+2)];
    [path addLineToPoint:CGPointMake(x+marginWidth, bottom+2)];
    
    layer = [CAShapeLayer layer];
    layer.path = path.CGPath;
    layer.backgroundColor = [UIColor clearColor].CGColor;
    layer.lineWidth = 2;
    layer.strokeColor = [UIColor whiteColor].CGColor;
    layer.fillColor = [UIColor clearColor].CGColor;
    [_clipsView.layer addSublayer:layer];
    
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
    CGFloat cx = point.x - startPoint.x;
    CGFloat cy = point.y - startPoint.y;
    if (sender.state == UIGestureRecognizerStateBegan) {
        startPoint = point;
        originPoint = sender.view.frame.origin;
    }else if (sender.state == UIGestureRecognizerStateChanged) {
        //因为可以上下滑动，所以要根据宽高比来测定
        CGRect frame = sender.view.frame;
        if (_widthBigRatio) {
            //这里会用到cx
            frame.origin.x = originPoint.x + cx;
        }else {
            //这里会用到cy
            frame.origin.y = originPoint.y + cy;
        }
        sender.view.frame = frame;
    }else if (sender.state == UIGestureRecognizerStateEnded || sender.state == UIGestureRecognizerStateCancelled) {
        if (_widthBigRatio) {
            if (cx + sender.view.s_X > _clipLineFrame.origin.x) {
                [UIView animateWithDuration:0.3 animations:^{
                    sender.view.s_X = self.clipLineFrame.origin.x;
                }];
                
            }else if (sender.view.s_right + cx < _clipLineFrame.origin.x + _clipLineFrame.size.width) {
                [UIView animateWithDuration:0.3 animations:^{
                    sender.view.s_X = self.clipLineFrame.size.width+self.clipLineFrame.origin.x-sender.view.s_width;
                }];
                
            }
        }else {
            if (cy + sender.view.s_Y > _clipLineFrame.origin.y) {
                [UIView animateWithDuration:0.3 animations:^{
                    sender.view.s_Y = self.clipLineFrame.origin.y;
                }];
                
            }else if (sender.view.s_bottom + cy < _clipLineFrame.origin.y + _clipLineFrame.size.height) {
                [UIView animateWithDuration:0.3 animations:^{
                    sender.view.s_Y = self.clipLineFrame.size.height+self.clipLineFrame.origin.y-sender.view.s_height;
                }];
            }
        }
    }
}

- (IBAction)onClickToOperate:(UIButton *)sender {
    NSInteger tag = sender.tag;
    if (tag == 100) {
        //结束
        [self backToHome];
    }else if (tag == 102) {
        //跳过
        if ([self nextClip]) [self requestImage];
    }else {
        //剪裁
        [self onClickToClip];
        if ([self nextClip]) [self requestImage];
    }
    
}

//实际剪裁
- (void)onClickToClip {
    self.view.userInteractionEnabled = NO;
    [QYLProgressView showInView:self.view];
    
    double x = (_clipLineFrame.origin.x - _ivClipsImage.s_X)*_ratio;
    double y = (_clipLineFrame.origin.y - _ivClipsImage.s_Y)*_ratio;
    double fWidth = _clipLineFrame.size.width*_ratio; //图片实际宽度
    double fHeight = _clipLineFrame.size.height*_ratio;//图片实际剪裁的高度
    UIImage *image = _ivClipsImage.image;
    CGRect clipRect = CGRectMake(x, y, fWidth, fHeight);

    CGImageRef imageRef = CGImageCreateWithImageInRect(image.CGImage, clipRect);
    UIImage *newImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    [[QYLPhotosManager sharedInstance] savePhotoToAlbum:newImage completed:^(BOOL isSuccess) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (isSuccess) {
                [QYLToast showWithMessage:@"保存图片成功!"];
            }else {
                [QYLToast showWithMessage:@"保存图片失败!"];
            }
            [QYLProgressView dismiss];
            self.view.userInteractionEnabled = YES;
        });
    }];
}

//下一张,剪裁的步骤同理
- (BOOL)nextClip {
    [ _clipsList removeObjectAtIndex:0];
    if (_clipsList.count < 1) {
        [self backToHome];
        return NO;
    }
    return YES;
}

//返回到主页
- (void)backToHome {
    [self dismissViewControllerAnimated:NO completion:^{
        //结束后，返回到主页
        [(UINavigationController *)([UIApplication sharedApplication].delegate.window.rootViewController) popToRootViewControllerAnimated:YES];
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [QYLProgressView dismiss];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
