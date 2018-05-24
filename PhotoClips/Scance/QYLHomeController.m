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

@property (weak, nonatomic) IBOutlet UITextField *tfLeft;
@property (weak, nonatomic) IBOutlet UITextField *tfRight;

@end

@implementation QYLHomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"图片剪裁";
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenKeyboard)]];
}

- (void)hiddenKeyboard {
    [self.view endEditing:YES];
}

- (IBAction)onClickToClipsImage:(UIButton *)sender {
    QYLPhotoClipType type;
    if (sender.tag == 20) {
    //1920
        type = QYLPhotoClipType9_16;
    }else if (sender.tag == 21) {
    //9:18
        type = QYLPhotoClipType1_2;
    }else {
        type = QYLPhotoClipTypeCustom;
        if (_tfLeft.text.length < 1 || _tfRight.text.length < 1) {
            [QYLToast showWithMessage:@"自定义需要输入自定义的比例!"];
            return;
        }
        double w = [_tfLeft.text doubleValue];
        double h = [_tfRight.text doubleValue];
        if (!w || !h) {
            [QYLToast showWithMessage:@"两个必须为数字并且均不能为零!"];
            return;
        }
        double ratio = w/h;
        [[NSUserDefaults standardUserDefaults] setObject:@(ratio) forKey:QYLPhotoCustomRatio];
        [[NSUserDefaults standardUserDefaults] synchronize];
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
