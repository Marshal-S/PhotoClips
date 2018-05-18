//
//  QYLHomeController.m
//  PhotoClips
//
//  Created by Marshal on 2018/5/10.
//  Copyright © 2018年 Marshal. All rights reserved.
//

#import "QYLHomeController.h"
#import "QYLAlbumsController.h"

@interface QYLHomeController ()

@end

@implementation QYLHomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"图片剪裁";
}

- (IBAction)onClickToClipsImage:(UIButton *)sender {
    QYLPhotoClipType type;
    if (sender.tag == 20) {
    //1920
        type = QYLPhotoClipType9_16;
    }else {
    //9:18
        type = QYLPhotoClipType1_2;
    }
    QYLAlbumsController *select = [QYLAlbumsController clipWithType:type];
    [self.navigationController pushViewController:select animated:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
