//
//  MyTextView.m
//  YiTie
//
//  Created by 西安旺豆电子信息有限公司 on 17/2/22.
//  Copyright © 2017年 西安旺豆电子信息有限公司. All rights reserved.
//

#import "MyTextView.h"

#define kLayoutTextViewH 60


@interface MyTextView ()
{
    CGRect _upRect;
    CGRect _downRect;
}

@end

@implementation MyTextView

-(instancetype)initWithView:(UIView *)view
{
    if (self = [super initWithFrame:view.frame]) {
        self.backgroundColor = kGetColorRGBA(0, 0, 0, 0.1);
        [view addSubview:self];
        //_downRect  = CGRectMake(0, kGetH(view) , kGetW(view), kLayoutTextViewH);
        _upRect = CGRectMake(0, kGetH(view) - kLayoutTextViewH, kGetW(view), kLayoutTextViewH);
        _layoutTextView = [[LayoutTextView alloc] initWithFrame:_upRect];
        [self addSubview:_layoutTextView];
        
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

    [_layoutTextView.textView becomeFirstResponder];
}
-(void)hide
{
    [_layoutTextView.textView resignFirstResponder];
    [self performSelector:@selector(superHidden) withObject:nil afterDelay:0.25];
}

-(void)superHidden
{
    [super setHidden:YES];

}



@end
