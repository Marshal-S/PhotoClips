//
//  QYLPhotoManager.h
//  PhotoClips
//
//  Created by Marshal on 2018/5/10.
//  Copyright © 2018年 Marshal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

@interface QYLPhotoManager : NSObject

/**
 是否开启了相册权限
 
 @return YES/NO
 */
+ (BOOL)isPhotoAlbumPermit;


/**
 保存图片到自定义相册
 
 @param image 图片
 */
+ (void)writeImageToPhotoAlbum:(UIImage *)image;

/**
 获取指定相册中照片
 
 @param assetCollection 相册
 @param ascending 升序OR降序
 @return 排序后的集合
 */
+ (NSArray<PHAsset *> *)getAllAssetWithAssetCollection:(PHAssetCollection *)assetCollection
                                             ascending:(BOOL)ascending;

/**
 获取asset对应的图片
 
 @param asset asset
 @param size 图片size
 @param completion 图片
 */
+ (void)getImageWithAsset:(PHAsset *)asset
                     size:(CGSize)size
               completion:(void (^)(UIImage *image))completion;


/**
 获取asset对应图片
 
 @param asset asset
 @param completion 图片
 */
+ (void)getImageWithAsset:(PHAsset *)asset
               completion:(void (^)(UIImage *image))completion;

@end
