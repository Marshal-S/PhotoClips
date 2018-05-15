//
//  UIImage+S_QYLImageExtersion.m
//  PersonBike
//
//  Created by Marshal on 2017/7/17.
//  Copyright © 2017年 Marshal. All rights reserved.
//

#import "UIImage+S_QYLImageExtersion.h"

@implementation UIImage (S_QYLImageExtersion)

+ (instancetype)s_generateQrcodeImageWithStr:(NSString *)QcodeStr size:(float)size {
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 滤镜恢复默认设置
    [filter setDefaults];
    //给滤镜添加数据
    NSData *data = [QcodeStr dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKeyPath:@"inputMessage"];
    //返回二维码图片
    return [self s_createHDUIImageFormCIImage:[filter outputImage] withSize:size];
}

//生成高清图片
+ (UIImage *)s_createHDUIImageFormCIImage:(CIImage *)image withSize:(CGFloat)size {
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    //注意这些c的函数，不是使用完了没有变量引用就会释放，malloc后只有主动释放他才会有用
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGColorSpaceRelease(cs);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    UIImage *newImage = [UIImage imageWithCGImage:scaledImage];
    CGImageRelease(scaledImage);
    return newImage;
}

- (UIImage *)s_getNewImage:(CGFloat)size {
    return [self s_getNewImage:size cornerRadius:0];
}

- (UIImage *)s_getNewImage:(CGFloat)size cornerRadius:(BOOL)radius {
    UIImage *drawImage = self;//实际绘制的image
    //下面一个判断是对非正方形图片的处理
    CGFloat mineLine;
    if (self.size.width != self.size.height) {
        mineLine = self.size.width > self.size.height ? self.size.height : self.size.width;
        CGImageRef imageRef = CGImageCreateWithImageInRect(self.CGImage, CGRectMake((self.size.width-mineLine)/2, (self.size.height-mineLine)/2, mineLine, mineLine));
        drawImage = [UIImage imageWithCGImage:imageRef];
        CGImageRelease(imageRef);
    }else {
        mineLine = self.size.width;
    }
    if (size == -1) {
        size = mineLine;
        radius = YES;
    }
    UIGraphicsBeginImageContext(CGSizeMake(size, size));
    //下面是圆角处理
    if (radius) {
        CGContextAddEllipseInRect(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, size, size));
        CGContextClip(UIGraphicsGetCurrentContext());
    }
    [drawImage drawInRect:CGRectMake(0, 0, size, size)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
