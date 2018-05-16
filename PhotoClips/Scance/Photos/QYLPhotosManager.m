//
//  QYLPhotosManager.m
//  PhotoClips
//
//  Created by Marshal on 2018/5/11.
//  Copyright © 2018年 Marshal. All rights reserved.
//

#import "QYLPhotosManager.h"
#import "QYLCommonUtil.h"

@implementation QYLPhotosManager

+ (instancetype)sharedInstance {
    static QYLPhotosManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

//获取所有智能相册
- (NSArray<QYLAblumModel *> *)getAllSmartAlbums {
    NSMutableArray *albums = [NSMutableArray array];
    PHFetchResult *smartAblums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    [smartAblums enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        QYLAblumModel *albumModel = createAblumModel(obj);
        if (albumModel) [albums addObject:albumModel];
    }];
    return albums;
}

//获取所有用户创建过的相册
- (NSArray<NSArray<QYLAblumModel *> *> *)getAllUserCreateAblums {
    NSMutableArray *albums = [NSMutableArray array];
    PHFetchResult *userAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil];
    [userAlbums enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        QYLAblumModel *albumModel = createAblumModel(obj);
        if (albumModel) [albums addObject:albumModel];
    }];
    return albums;
}

QYLAblumModel *createAblumModel(PHAssetCollection *assetCollection) {
    NSArray *assets = [[QYLPhotosManager sharedInstance] getAssetsInAssetCollection:assetCollection ascending:NO];
    NSMutableArray *coverAssets = [NSMutableArray array];//用于获取封面,默认3张
    [assets enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [coverAssets addObject:obj];
        if (idx >= 2) *stop = YES;
    }];
    if (assets.count < 1) return nil;
    QYLAblumModel *album = [QYLAblumModel new];
    album.title = assetCollection.localizedTitle;
    album.assets = coverAssets;
    album.assetCollection = assetCollection;
    album.count = assets.count;
    return album;
}

//获取所有图片,ascending YES为升序
- (NSArray<QYLPhotoModel *> *)getAllAssetPhotosAblumWithAscending:(BOOL)ascending {
    NSMutableArray *assets = [NSMutableArray array];
    PHFetchOptions *option = [PHFetchOptions new];
    option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:ascending]];
    PHFetchResult *result = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:option];
    [result enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        QYLPhotoModel *photoModel = createPhotoModel(obj);
        if (photoModel) [assets addObject:photoModel];
    }];
    return assets;
}

//获取每个相册下的所有照片对象,ascending YES为升序
- (NSArray<QYLPhotoModel *> *)getAssetsInAssetCollection:(PHAssetCollection *)assetCollection ascending:(BOOL)ascending {
    NSMutableArray *assets = [NSMutableArray array];
    PHFetchOptions *option = [PHFetchOptions new];
    option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:ascending]];
    PHFetchResult *result = [PHAsset fetchAssetsInAssetCollection:assetCollection options:option];
    [result enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        QYLPhotoModel *photoModel = createPhotoModel(obj);
        if (photoModel) [assets addObject:photoModel];
    }];
    return assets;
}

//根据asset生成单张图片的model
QYLPhotoModel *createPhotoModel(PHAsset *asset) {
    if (asset.mediaType != PHAssetMediaTypeImage) return nil;//不是图片的直接过滤掉
    QYLPhotoModel *photo = [QYLPhotoModel new];
    photo.isUserLibrary = (asset.sourceType == PHAssetSourceTypeUserLibrary);
    photo.asset = asset;
    return photo;
}

//如果在tableView等复用视图上注意调用这个方法[[PHImageManager defaultManager] cancelImageRequest:_irID];
//获取快速图片，用于获取图片列表
- (PHImageRequestID)getFastImageWithAsset:(PHAsset *)asset targetSize:(CGSize)size resultHandler:(void(^)(UIImage *image))handler {
    return requestByAsset(asset, PHImageRequestOptionsResizeModeFast, size, handler);
}

//获取精确图片
- (PHImageRequestID)getExactImageWithAsset:(PHAsset *)asset resultHandler:(void(^)(UIImage *image))handler {
    return requestByAsset(asset, PHImageRequestOptionsResizeModeExact, PHImageManagerMaximumSize, handler);
}

//获取图片
PHImageRequestID requestByAsset(PHAsset *asset, PHImageRequestOptionsResizeMode resizeMode, CGSize size, void(^handler)(UIImage *image)) {
    PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
    option.resizeMode = resizeMode;
    option.networkAccessAllowed = YES;//是否允许从网络上下载，一部分图片不在本地，可能存放到iCloud里面了
    PHImageRequestID imageID = [[PHCachingImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeAspectFit options:option resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        //回到主线程
        handler(result);
    }];
    return imageID;
}

- (void)savePhotoToAlbum:(UIImage *)image {
    // 保存图片到自定义相册
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        switch (status) {
            case PHAuthorizationStatusNotDetermined:
                break;
            case PHAuthorizationStatusAuthorized:
                [self saveImageAndCreateAlbum:image];
                break;
            case PHAuthorizationStatusDenied:
            case PHAuthorizationStatusRestricted:{
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"权限警报" message:@"检测到您尚未打开相册权限，将无法使用与相册相关的操作" preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    //下面是打开权限跳转的相关操作
                    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                    UIApplication *application = [UIApplication sharedApplication];
                    if (![application canOpenURL:url]) return;
                    if (@available(iOS 10.0, *)) {
                        [application openURL:url options:@{} completionHandler:^(BOOL success) {}];
                    }else {
                        [application openURL:url];
                    }
                }]];
                [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:nil]];
            }break;
        }
    }];
}

//创建相册并保存图片
- (void)saveImageAndCreateAlbum:(UIImage *)image {
    NSString *KQYLAlbumName = @"PhotoClips";
    // 获取所有自定义相册
    PHFetchResult *albums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    // 筛选[如果已经存在，则无需再创建]
    PHAssetCollection *collection = nil;
    for (PHAssetCollection *album in albums)  {
        if ([album.localizedTitle isEqualToString:KQYLAlbumName]) {
            collection = album;
            break;
        }
    }
    if (!collection) {
        __block NSString *collectionID = nil;
        //如果不存在则创建相册,并获取到他的id
        [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
            collectionID = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:KQYLAlbumName].placeholderForCreatedAssetCollection.localIdentifier;
        } error:nil];
        //通过ID来获取完成后的相册
        collection = [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[collectionID] options:nil].firstObject;
    }
    //开始保存图片
    NSError *error = nil;
    __block NSString *assetId = nil;
    //这个方法为同步，需要等待
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        assetId = [PHAssetCreationRequest creationRequestForAssetFromImage:image].placeholderForCreatedAsset.localIdentifier;
    } error:&error];
    if (error) {
        [QYLToast showWithMessage:@"保存图片失败!"];
        return;
    }
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        PHAssetCollectionChangeRequest *request = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:collection];
        PHAsset *asset = [PHAsset fetchAssetsWithLocalIdentifiers:@[assetId] options:nil].firstObject;
        // 添加图片到相册中,如果是add就不能显示到封面了，用insert能在封面显示
        [request insertAssets:@[asset] atIndexes:[NSIndexSet indexSetWithIndex:0]];
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        if (error) {
            [QYLToast showWithMessage:@"保存图片失败!"];
        }else {
            [QYLToast showWithMessage:@"保存图片成功!"];
        }
    }];
}

@end


@implementation QYLAblumModel

@end

@implementation QYLPhotoModel

@end

