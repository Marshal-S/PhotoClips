//
//  QYLCoverShowView.m
//  PhotoClips
//
//  Created by Marshal on 2018/5/18.
//  Copyright © 2018年 Marshal. All rights reserved.
//

#import "QYLCoverShowView.h"
#import "QYLPhotosManager.h"

@interface QYLCoverShowView ();

@property (nonatomic, strong) NSMutableArray<UIImageView *> *ivList;
@property (nonatomic, strong) NSMutableArray *ivIDList;

@end

@implementation QYLCoverShowView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUp];
    }
    return self;
}

- (void)setUp {
    _ivIDList = [NSMutableArray array];
    
    CGFloat midleWidth = 30;//中间间隔
    NSAssert(self.frame.size.width > self.frame.size.height + midleWidth*2, @"宽必须大于等于高才可以");
    CGFloat height = self.frame.size.height-20;
    
    _ivList = [NSMutableArray array];
    for (NSInteger idx = 0; idx < 3; idx++) {
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(10+idx*midleWidth, 10, height, height)];
        UIImageView *ivCover = [[UIImageView alloc] initWithFrame:CGRectMake(1, 1, height-2, height-2)];
        ivCover.contentMode = UIViewContentModeScaleAspectFill;
        ivCover.clipsToBounds = YES;
        [backView addSubview:ivCover];
        [_ivList addObject:ivCover];
        backView.backgroundColor = ivCover.backgroundColor = [UIColor clearColor];
        backView.layer.transform = CATransform3DRotate(CATransform3DIdentity, M_PI_4, 0, 0, 1);
        [self addSubview:backView];
    }
}

- (void)updateWithPhotoList:(NSArray<QYLPhotoModel *> *)photoList {
    NSInteger count = photoList.count;
    NSInteger idx = 0;
    for (UIImageView *ivCover in _ivList) {
        
    }
}

@end
