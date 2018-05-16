//
//  QYLPhotosView.m
//  PhotoClips
//
//  Created by Marshal on 2018/5/12.
//  Copyright © 2018年 Marshal. All rights reserved.
//

#import "QYLPhotosView.h"
#import "QYLPhotosCell.h"

static NSInteger lineWidth = 15;
static NSString *kQYLPhotosIdentifier = @"kQYLPhotosIdentifier";

@interface QYLPhotosView ()<UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate>
{
    CGSize _size;
}

@property (nonatomic, strong) NSArray<QYLPhotoModel *> *photoList;

@end

@implementation QYLPhotosView

- (instancetype)initWithFrame:(CGRect)frame photoList:(NSArray<QYLPhotoModel *> *)photoList {
    UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
    flowLayout.minimumLineSpacing = lineWidth;
    flowLayout.minimumInteritemSpacing = lineWidth;
    if (self = [super initWithFrame:frame collectionViewLayout:flowLayout]) {
        _photoList = photoList;
        [self setUp];
    }
    return self;
}

- (void)setUp {
    self.contentInset = UIEdgeInsetsMake(10, 0, 10, 0);
    [self registerClass:NSClassFromString(@"QYLPhotosCell") forCellWithReuseIdentifier:kQYLPhotosIdentifier];
    self.dataSource = self;
    self.delegate = self;
    self.backgroundColor = [UIColor whiteColor];
    
    NSInteger column = 3; //列数
    CGFloat width = (self.frame.size.width - lineWidth*(column-1))/column;
    _size = CGSizeMake(width, width);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _photoList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    QYLPhotosCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kQYLPhotosIdentifier forIndexPath:indexPath];
    [cell updateWithPhotoModel:_photoList[indexPath.row]];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return _size;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    if (_onClickToCheckLargeBlock) _onClickToCheckLargeBlock(indexPath.row);
}




@end
