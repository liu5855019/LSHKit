//
//  BaseAlertView.h
//  YiTieRAS
//
//  Created by 西安旺豆电子信息有限公司 on 17/3/9.
//  Copyright © 2017年 西安旺豆电子信息有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseAlertView : UIView

@property (nonatomic , assign) BOOL isHideWhenTouchBackground;

-(instancetype)initWithCustomView:(UIView *)aView;
-(void) show;
-(void) hide;
@end
