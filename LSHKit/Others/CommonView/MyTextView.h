//
//  MyTextView.h
//  YiTie
//
//  Created by 西安旺豆电子信息有限公司 on 17/2/22.
//  Copyright © 2017年 西安旺豆电子信息有限公司. All rights reserved.
//

//@property (nonatomic , strong) MyTextView *myTextView;
//-(MyTextView *)myTextView
//{
//    if (_myTextView == nil) {
//        _myTextView = [[MyTextView alloc] initWithView:self.view];
//        
//        [_myTextView.layoutTextView.sendBtn setTitle:@"确定" forState:UIControlStateNormal];
//        WeakObj(self);
//        _myTextView.layoutTextView.sendBlock = ^(UITextView *textView)
//        {
//            selfWeak.tableHeaderView.errorDescLabel.text = textView.text;
//            [selfWeak.myTextView hide];
//        };
//    }
//    return _myTextView;
//}

//self.myTextView.layoutTextView.textView.text = self.tableHeaderView.errorDescLabel.text;
//[self.myTextView show];


#import <UIKit/UIKit.h>
#import "LayoutTextView.h"

@interface MyTextView : UIView

@property (nonatomic , strong) LayoutTextView *layoutTextView;

-(instancetype) initWithView:(UIView *)view;

-(void)show;

-(void)hide;

@end
