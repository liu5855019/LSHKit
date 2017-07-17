//
//  BaseAlertView.m
//  YiTieRAS
//
//  Created by 西安旺豆电子信息有限公司 on 17/3/9.
//  Copyright © 2017年 西安旺豆电子信息有限公司. All rights reserved.
//

#import "BaseAlertView.h"

@interface BaseAlertView ()

@property (nonatomic , strong) UIControl *backgroundView;
@property (nonatomic , strong) UIView *contentView;

@end

@implementation BaseAlertView

-(instancetype)initWithCustomView:(UIView *)aView
{
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
        _isHideWhenTouchBackground = YES;
        
        //backgroundView
        _backgroundView = [[UIControl alloc] init];
        _backgroundView.frame = self.frame;
        _backgroundView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        _backgroundView.alpha = 0;
        [_backgroundView addTarget:self action:@selector(clickBackgroundView) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_backgroundView];
        
        _contentView = aView;
        aView.center = CGPointMake(kScreenW/2, kScreenH/2);
        [self addSubview:aView];
    }
    
    return self;
}

-(void)show
{
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    [window addSubview:self];
    
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = .25;
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.05, 1.05, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.95, 0.95, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [_contentView.layer addAnimation:animation forKey:nil];
    
    [UIView animateWithDuration:.25 animations:^{
        _backgroundView.alpha = 1;
        _contentView.alpha = 1;
    }];

}

-(void)hide
{
    [UIView animateWithDuration:.25 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

-(void)clickBackgroundView
{
    if (_isHideWhenTouchBackground) {
        [self hide];
    }
}

@end
