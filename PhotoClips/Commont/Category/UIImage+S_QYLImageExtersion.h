//
//  UIImage+S_QYLImageExtersion.h
//  PersonBike
//
//  Created by Marshal on 2017/7/17.
//  Copyright © 2017年 Marshal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (S_QYLImageExtersion)

+ (instancetype)s_generateQrcodeImageWithStr:(NSString *)QcodeStr size:(float)size;

//获取一定大小的图片,不是圆角
- (UIImage *)s_getNewImage:(CGFloat)size;

//size为-1的话是按照本身尺寸进行绘制,并且直接绘制成圆形
- (UIImage *)s_getNewImage:(CGFloat)size cornerRadius:(BOOL)radius;

@end
