//
//  CommonPickerView.h
//  product1
//
//  Created by 西安旺豆电子信息有限公司 on 17/7/3.
//  Copyright © 2017年 西安旺豆电子信息有限公司. All rights reserved.
//

#import "MyPickerView.h"

@interface CommonPickerView : MyPickerView

@property (nonatomic , copy) NSArray *datas;

@property (nonatomic , copy) void (^didSelectedIndex)(NSInteger index);

@property (nonatomic , copy) void (^viewWillHide)();

@end
