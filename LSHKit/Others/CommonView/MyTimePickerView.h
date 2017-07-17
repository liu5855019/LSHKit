//
//  MyTimePickerView.h
//  YiTie
//
//  Created by 西安旺豆电子信息有限公司 on 17/1/14.
//  Copyright © 2017年 西安旺豆电子信息有限公司. All rights reserved.
//

//
//@property (nonatomic , strong) MyTimePickerView *picker;

//-(MyTimePickerView *)picker
//{
//    if (!_picker) {
//        _picker = [[MyTimePickerView alloc] initWithView:self.view];
//        [_picker.picker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
//    }
//    return _picker;
//}



#import <UIKit/UIKit.h>

@interface MyTimePickerView : UIView

@property (nonatomic , strong) UIDatePicker *picker;

-(instancetype) initWithView:(UIView *)view;

-(void)show;

-(void)hide;

@end
