//
//  QYLPhotoManager.m
//  PhotoClips
//
//  Created by Marshal on 2018/5/10.
//  Copyright © 2018年 Marshal. All rights reserved.
//

#import "QYLPhotoManager.h"

static NSString *kPhotoAlbum = @"PhotoDemo";

@implementation QYLPhotoManager

// 是否开启了相册权限
+ (BOOL)isPhotoAlbumPermit
{
    __block BOOL isPermit = YES;
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusRestricted || status == PHAuthorizationStatusDenied) {
        isPermit = NO;
    }
    return isPermit;
}

// 保存图片到自定义相册
+ (void)writeImageToPhotoAlbum:(UIImage *)image
{
    PHAuthorizationStatus oldStatus = [PHPhotoLibrary authorizationStatus];
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        dispatch_async(dispatch_get_main_queue(), ^{
            switch (status)
            {
                case PHAuthorizationStatusAuthorized: //权限打开
                {
                    // 获取所有自定义相册
                    PHFetchResult *collections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
                    // 筛选[如果已经存在，则无需再创建]
                    __block PHAssetCollection *createCollection = nil;
                    __block NSString *collectionID = nil;
                    for (PHAssetCollection *collection in collections)  {
                        if ([collection.localizedTitle isEqualToString:kPhotoAlbum]) {
                            createCollection = collection;
                            break;
                        }
                    }
                    if (!createCollection) {
                        // 创建相册
                        [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
                            collectionID = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:kPhotoAlbum].placeholderForCreatedAssetCollection.localIdentifier;
                        } error:nil];
                        // 取出
                        createCollection = [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[collectionID] options:nil].firstObject;
                    }
                    // 保存图片
                    __block NSString *assetId = nil;
                    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                        assetId = [PHAssetCreationRequest creationRequestForAssetFromImage:image].placeholderForCreatedAsset.localIdentifier;
                    } completionHandler:^(BOOL success, NSError * _Nullable error) {
                        if (error) {
                            NSLog(@"保存至'所有图片'失败");
                            return ;
                        }
                        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                            PHAssetCollectionChangeRequest *request = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:createCollection];
                            PHAsset *asset = [PHAsset fetchAssetsWithLocalIdentifiers:@[assetId] options:nil].firstObject;
                            // 添加图片到相册中
                            [request addAssets:@[asset]];
                            
                        } completionHandler:^(BOOL success, NSError * _Nullable error) {
                            if (error) {
                                NSLog(@"保存'自定义相册'失败");
                            }
                        }];
                    }];
                    break;
                }
                case PHAuthorizationStatusDenied:
                case PHAuthorizationStatusRestricted:
                {
                    if (oldStatus == PHAuthorizationStatusNotDetermined) {
                        return;
                    }
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                    message:@"请在设置>隐私>照片中开启权限"
                                                                   delegate:nil
                                                          cancelButtonTitle:@"知道了"
                                                          otherButtonTitles:nil, nil];
                    [alert show];
                    break;
                }
                default:
                    break;
            }
        });
    }];
}

// 保存视频到自定义相册
+ (void)writeVideoToPhotoAlbum:(NSURL *)videoURL
{
    PHAuthorizationStatus oldStatus = [PHPhotoLibrary authorizationStatus];
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        dispatch_async(dispatch_get_main_queue(), ^{
            switch (status)
            {
                case PHAuthorizationStatusAuthorized://权限打开
                {
                    // 获取所有自定义相册
                    PHFetchResult *collections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum
                                                                                          subtype:PHAssetCollectionSubtypeAlbumRegular
                                                                                          options:nil];
                    
                    // 筛选[如果已经存在，则无需再创建]
                    __block PHAssetCollection *createCollection = nil;
                    __block NSString *collectionID = nil;
                    for (PHAssetCollection *collection in collections)  {
                        if ([collection.localizedTitle isEqualToString:kPhotoAlbum]) {
                            createCollection = collection;
                            break;
                        }
                    }
                    if (!createCollection) {
                        // 创建相册
                        [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
                            collectionID = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:kPhotoAlbum].placeholderForCreatedAssetCollection.localIdentifier;
                        } error:nil];
                        // 取出
                        createCollection = [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[collectionID] options:nil].firstObject;
                    }
                    // 保存视频
                    __block NSString *assetId = nil;
                    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                        assetId = [PHAssetCreationRequest creationRequestForAssetFromVideoAtFileURL:videoURL].placeholderForCreatedAsset.localIdentifier;
                    } completionHandler:^(BOOL success, NSError * _Nullable error) {
                        if (error) {
                            NSLog(@"保存至'所有图片'失败");
                            return ;
                        }
                        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                            PHAssetCollectionChangeRequest *request = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:createCollection];
                            PHAsset *asset = [PHAsset fetchAssetsWithLocalIdentifiers:@[assetId] options:nil].firstObject;
                            // 添加视频到相册中
                            [request addAssets:@[asset]];
                            
                        } completionHandler:^(BOOL success, NSError * _Nullable error) {
                            if (error) {
                                NSLog(@"保存'自定义相册'失败");
                            }
                        }];
                    }];
                    
                    break;
                }
                case PHAuthorizationStatusDenied:
                case PHAuthorizationStatusRestricted:
                {
                    if (oldStatus == PHAuthorizationStatusNotDetermined) {
                        return;
                    }
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                    message:@"请在设置>隐私>照片中开启权限"
                                                                   delegate:nil
                                                          cancelButtonTitle:@"知道了"
                                                          otherButtonTitles:nil, nil];
                    [alert show];
                    break;
                }
                default:
                    break;
            }
        });
    }];
}

// 获取指定相册中照片
+ (NSArray<PHAsset *> *)getAllAssetWithAssetCollection:(PHAssetCollection *)assetCollection ascending:(BOOL)ascending
{
    // ascending:按照片创建时间排序 >> YES:升序 NO:降序
    NSMutableArray<PHAsset *> *assets = [NSMutableArray array];
    PHFetchOptions *option = [[PHFetchOptions alloc] init];
    option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:ascending]];
    PHFetchResult *result = [PHAsset fetchAssetsInAssetCollection:assetCollection options:option];
    [result enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (((PHAsset *)obj).mediaType == PHAssetMediaTypeImage) {
            [assets addObject:obj];
        }
    }];
    return assets;
}

// 获取asset对应的图片
+ (void)getImageWithAsset:(PHAsset *)asset size:(CGSize)size completion:(void (^)(UIImage *image))completion
{
    PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
    option.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic;
    option.networkAccessAllowed = YES;
    [[PHCachingImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeDefault options:option resultHandler:^(UIImage * _Nullable image, NSDictionary * _Nullable info) {
        if (completion)  completion(image);
    }];
}

// 获取asset对应的图片
+ (void)getImageWithAsset:(PHAsset *)asset completion:(void (^)(UIImage *image))completion
{
    PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
    option.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic;
    option.networkAccessAllowed = YES;
    [[PHCachingImageManager defaultManager] requestImageDataForAsset:asset options:option resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
        UIImage *image = [UIImage imageWithData:imageData];
        if (completion)  completion(image);
    }];
}

@end
