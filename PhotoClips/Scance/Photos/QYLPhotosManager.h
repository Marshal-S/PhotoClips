//
//  QYLPhotosManager.h
//  PhotoClips
//
//  Created by Marshal on 2018/5/11.
//  Copyright © 2018年 Marshal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

//相册列表图片模型
@interface QYLAblumModel : NSObject

@property (nonatomic, copy) NSString *title;              //相册标题
@property (nonatomic, assign) NSInteger count;            //相册内部图片熟练
@property (nonatomic, strong) NSArray<PHAsset *> *assets; //内部图片数组(目前只存放三张，可以改数字),封面为第一张

@end

//某一相册内图片模型
@interface QYLPhotoModel : NSObject

@property (nonatomic, strong) PHAsset *asset;       //图片
@property (nonatomic, assign) BOOL isUserLibrary;   //是否是本地图库图片
@property (nonatomic, assign) BOOL isSelect;        //是否被选中了

@end

@interface QYLPhotosManager : NSObject

//单例，避免多次创建
+ (instancetype)sharedInstance;

/**
 获取所有智能相册

 @return 返回的为一个相册数组
 */
- (NSArray<QYLAblumModel *> *)getAllSmartAlbums;

/**
 获取所有用户自己创建的相册

 @return 返回用户自己创建的相册集合
 */
- (NSArray<NSArray<QYLAblumModel *> *> *)getAllUserCreateAblums;

/**
 获取所有图片

 @param ascending YES表示升序，NO表示降序
 @return 所有图片组合成的数组
 */
- (NSArray<QYLPhotoModel *> *)getAllAssetPhotosAblumWithAscending:(BOOL)ascending;

/**
 根据指定相册获取其内部的相片

 @param assetCollection 指定相册
 @param ascending YES表示升序，NO表示降序
 @return 指定相册的图片集合
 */
- (NSArray<QYLPhotoModel *> *)getAssetsInAssetCollection:(PHAssetCollection *)assetCollection ascending:(BOOL)ascending;

/**
 根据指定相册获取其内部指定数量相片

 @param assetCollection 指定相册
 @param count 指定数量
 @param ascending YES表示升序，NO表示降序
 @return 指定相册指定张数的图片集合
 */
- (NSArray<QYLPhotoModel *> *)getAssetsInAssetCollection:(PHAssetCollection *)assetCollection count:(NSInteger)count ascending:(BOOL)ascending;

/**
 快速获取低画质图片(适用于列表)

 @param asset 图片asset
 @param size 大小
 @param handler 获取图片成功后的回调
 */
- (void)getFastImageWithAsset:(PHAsset *)asset targetSize:(CGSize)size resultHandler:(void(^)(UIImage *image))handler;

/**
 获取原图

 @param asset 图片asset
 @param handler 获取原图成功后的回调
 */
- (void)getExactImageWithAsset:(PHAsset *)asset resultHandler:(void(^)(UIImage *image))handler;

/**
 保存图片到相册

 @param image 要保存的图片image
 */
- (void)savePhotoToAlbum:(UIImage *)image;

@end
