//
//  MyPickerView.h
//  YiTie
//
//  Created by 西安旺豆电子信息有限公司 on 17/2/21.
//  Copyright © 2017年 西安旺豆电子信息有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyPickerView : UIView

@property (nonatomic , strong) UIPickerView *picker;

-(instancetype) initWithView:(UIView *)view;

-(void)show;

-(void)hide;

@end
