//
//  BaseViewController.m
//  YiTieRAS
//
//  Created by 西安旺豆电子信息有限公司 on 17/3/6.
//  Copyright © 2017年 西安旺豆电子信息有限公司. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()



@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    if (self.navigationController) {
        _mainTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenW *0.4, 30)];
        _mainTitleLabel.textAlignment =NSTextAlignmentCenter;
        [_mainTitleLabel setText:@""];
        _mainTitleLabel.textColor = [UIColor whiteColor];
        _mainTitleLabel.font = [UIFont boldSystemFontOfSize:20];
        self.navigationItem.titleView = _mainTitleLabel;
    }
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    
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
