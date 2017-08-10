//
//  CommonPickerView.m
//  product1
//
//  Created by 西安旺豆电子信息有限公司 on 17/7/3.
//  Copyright © 2017年 西安旺豆电子信息有限公司. All rights reserved.
//

#import "CommonPickerView.h"

@interface CommonPickerView ()
<UIPickerViewDelegate,UIPickerViewDataSource>

@end

@implementation CommonPickerView

-(instancetype)initWithView:(UIView *)view
{
    if (self = [super initWithView:view]) {
        self.picker.delegate = self;
        self.picker.dataSource = self;
    }
    return self;
}


-(void)setDatas:(NSArray *)datas
{
    _datas = [datas copy];
    [self.picker reloadAllComponents];
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _datas.count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return _datas[row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (_didSelectedIndex) {
        _didSelectedIndex(row);
    }
}

-(void)show
{
    [super show];
    
    if (_didSelectedIndex) {
        _didSelectedIndex([self.picker selectedRowInComponent:0]);
    }
}


-(void)hide
{
    if (_viewWillHide) {
        _viewWillHide();
    }
    [super hide];
}


@end
