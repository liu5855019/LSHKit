//
//  MyTimePickerView.m
//  YiTie
//
//  Created by 西安旺豆电子信息有限公司 on 17/1/14.
//  Copyright © 2017年 西安旺豆电子信息有限公司. All rights reserved.
//

#import "MyTimePickerView.h"

#define kPickerH 216

@interface MyTimePickerView ()
{
    CGRect _upRect;
    CGRect _downRect;
}

@end

@implementation MyTimePickerView

-(instancetype)initWithView:(UIView *)view
{
    if (self = [super initWithFrame:view.frame]) {
        self.backgroundColor = kGetColorRGBA(0, 0, 0, 0.1);
        [view addSubview:self];
        
        _upRect = CGRectMake(0, kGetH(view) - kPickerH, kGetW(view), kPickerH);
        _downRect  = CGRectMake(0, kGetH(view), kGetW(view), kPickerH);
        
        _picker = [[UIDatePicker alloc] initWithFrame:_downRect];
        [self addSubview:_picker];
        _picker.backgroundColor = [UIColor whiteColor];
        
        [super setHidden:YES];
    }
    return self;
}


-(void)setHidden:(BOOL)hidden
{
    if (hidden) {
        [self hide];
    }else{
        [self show];
    }
    
}

-(void)show
{
    [super setHidden:NO];
    WeakObj(self);
    [UIView animateWithDuration:0.3 animations:^{
        selfWeak.picker.frame = _upRect;
    }];
}
-(void)hide
{
    WeakObj(self);
    [UIView animateWithDuration:0.3 animations:^{
        selfWeak.picker.frame = _downRect;
    } completion:^(BOOL finished) {
        [super setHidden:YES];
    }];
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self hide];
}

@end
