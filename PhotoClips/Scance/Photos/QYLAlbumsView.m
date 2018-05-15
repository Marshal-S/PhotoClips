//
//  QYLAlbumsView.m
//  PhotoClips
//
//  Created by Marshal on 2018/5/12.
//  Copyright © 2018年 Marshal. All rights reserved.
//

#import "QYLAlbumsView.h"
#import "QYLPhotosManager.h"
#import "QYLAlbumsCell.h"

static NSString *kQYLAlbumIdentifier = @"kQYLAlbumIdentifier";

@interface QYLAlbumsView ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray<QYLAblumModel *> *albumList;//相册列表

@end

@implementation QYLAlbumsView

- (instancetype)initWithFrame:(CGRect)frame albumList:(NSArray<QYLAblumModel *> *)albumList {
    if (self = [super initWithFrame:frame style:UITableViewStylePlain]) {
        _albumList = albumList;
        [self setUp];
    }
    return self;
}

- (void)setUp {
    [self registerClass:NSClassFromString(@"QYLAlbumsCell") forCellReuseIdentifier:kQYLAlbumIdentifier];
    self.dataSource = self;
    self.delegate = self;
    self.backgroundColor = [UIColor whiteColor];
    self.rowHeight = 80;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _albumList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QYLAlbumsCell *cell = [tableView dequeueReusableCellWithIdentifier:kQYLAlbumIdentifier forIndexPath:indexPath];
    [cell updateWithAblumModel:_albumList[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_onClickToSelectBlock) _onClickToSelectBlock(indexPath.row);
}


@end
