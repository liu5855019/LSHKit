//
//  LayoutTextView.m
//  LayoutTextView
//
//  Created by JiaHaiyang on 16/7/6.
//  Copyright © 2016年 PlutusCat. All rights reserved.
//
#import "LayoutTextView.h"
#import "Common.h"

#define textViewFont [UIFont systemFontOfSize:17]

static CGFloat maxHeight = 80.0f;
static CGFloat leftFloat = 5.0f;
static CGFloat textViewHFloat = 40.0f;
static CGFloat sendBtnW = 50.0f;
static CGFloat sendBtnH = 40.0f;

@interface LayoutTextView()<UITextViewDelegate>
@property (assign, nonatomic) CGFloat superHight;
@property (assign, nonatomic) CGFloat textViewY;
@property (assign, nonatomic) CGFloat sendButtonOffset;
@property (assign, nonatomic) CGFloat keyBoardHight;
@property (assign, nonatomic) CGRect originalFrame;
@end

@implementation LayoutTextView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        _originalFrame = frame;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWasShow:)
                                                     name:UIKeyboardWillShowNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillBeHidden:)
                                                     name:UIKeyboardWillHideNotification object:nil];
        self.backgroundColor = [UIColor colorWithRed:240.0/255.0 green:245.0/255.0 blue:248.0/255.0 alpha:1.0];
        
        UITextView *textView = [[UITextView alloc] init];
        textView.delegate    = self;
        textView.textColor   = [UIColor grayColor];
        textView.backgroundColor = [UIColor whiteColor];
        textView.font = textViewFont;
        textView.layer.cornerRadius  = 5;
        textView.layer.masksToBounds = YES;
        textView.layer.borderWidth   = 0.5;
        textView.layer.borderColor   = [kNavigationBarBackGroundColor CGColor];
        textView.layoutManager.allowsNonContiguousLayout = NO;
        [self addSubview:textView];
        self.textView = textView;
        
        UIButton *sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [sendBtn setTitleColor:kNavigationBarBackGroundColor forState:UIControlStateNormal];
        
        [sendBtn setTitle:kLocStr(@"回复") forState:UIControlStateNormal];
        [sendBtn setBackgroundColor:[UIColor whiteColor]];
        sendBtn.layer.cornerRadius  = 5;
        sendBtn.layer.masksToBounds = YES;
        sendBtn.layer.borderWidth   = 0.5;
        sendBtn.layer.borderColor   = [kNavigationBarBackGroundColor CGColor];
        [sendBtn addTarget:self action:@selector(sednBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:sendBtn];
        self.sendBtn =  sendBtn;

        CGFloat textViewX = leftFloat;
        CGFloat textViewW = Main_Screen_Width-(3*textViewX+sendBtnW);
        CGFloat textViewH = textViewHFloat;
        CGFloat textViewY = (self.frame.size.height-textViewH)*0.5;;
        _textView.frame = CGRectMake(textViewX, textViewY, textViewW, textViewH);

        _textViewY = textViewY;
        _sendButtonOffset = (self.frame.size.height-sendBtnH)*0.5;
        _superHight = self.frame.size.height;
    }
    return self;
}

- (void)sednBtnAction{

    if (_sendBlock) {
        _sendBlock(_textView);
    }
    
    [_textView resignFirstResponder];
    _textView.text = _placeholder;
    _textView.textColor = [UIColor grayColor];
}

- (void)setPlaceholder:(NSString *)placeholder{
    _placeholder = placeholder;
    _textView.text = _placeholder;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat sendBtnX = CGRectGetMaxX(_textView.frame)+leftFloat;
    CGFloat sendBtnY = self.frame.size.height-(_sendButtonOffset+sendBtnH);
    _sendBtn.frame = CGRectMake(sendBtnX, sendBtnY, sendBtnW, sendBtnH);

}

#pragma mark - == UITextViewDelegate ==
- (void)textViewDidBeginEditing:(UITextView *)textView{
    if (_textView.text == self.placeholder) {
        _textView.text = @"";
    }
    
    _textView.textColor = [UIColor blackColor];

}
- (void)textViewDidChange:(UITextView *)textView{
    
    CGRect frame = textView.frame;
    CGSize constraintSize = CGSizeMake(frame.size.width, MAXFLOAT);
    CGSize size = [textView sizeThatFits:constraintSize];
    if (size.height<=frame.size.height) {

    }else{
        if (size.height>=maxHeight){
            size.height = maxHeight;
            textView.scrollEnabled = YES;   // 允许滚动
           
        }else{
            textView.scrollEnabled = NO;    // 不允许滚动
        }
    }
    textView.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, size.height);
    
    CGFloat superHeight = CGRectGetMaxY(textView.frame)+_textViewY;
    
    [UIView animateWithDuration:0.15 animations:^{
        [self setFrame:CGRectMake(self.frame.origin.x, Main_Screen_Height-(_keyBoardHight+superHeight), self.frame.size.width, superHeight)];
    }];
    
}

- (void)textViewDidChangeSelection:(UITextView *)textView{

    CGRect r = [textView caretRectForPosition:textView.selectedTextRange.end];
    CGFloat caretY =  MAX(r.origin.y - textView.frame.size.height + r.size.height + 8, 0);
    if (textView.contentOffset.y < caretY && r.origin.y != INFINITY) {
        textView.contentOffset = CGPointMake(0, caretY);
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    if (textView.text.length == 0) {
        textView.text = self.placeholder;
    }
    textView.scrollEnabled = NO;
    CGRect frame = textView.frame;
    textView.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, textViewHFloat);
    [textView layoutIfNeeded];
    
}

#pragma mark - == 键盘弹出事件 ==
- (void)keyboardWasShow:(NSNotification*)notification{
    
    CGRect keyBoardFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    _keyBoardHight = keyBoardFrame.size.height;
    
    [self translationWhenKeyboardDidShow:_keyBoardHight];
    [self textViewDidChange:self.textView];
}

- (void)keyboardWillBeHidden:(NSNotification*)notification{
    
    [self translationWhenKeyBoardDidHidden];
}

- (void)translationWhenKeyboardDidShow:(CGFloat)keyBoardHight{
    [UIView animateWithDuration:0.25 animations:^{
        self.frame = CGRectMake(self.frame.origin.x, Main_Screen_Height-(keyBoardHight+self.frame.size.height), self.frame.size.width, self.frame.size.height);
    }];
}

- (void)translationWhenKeyBoardDidHidden{
    [UIView animateWithDuration:0.25 animations:^{
        self.frame = _originalFrame;
    }];
}

-(void)removeNotifications{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

-(void)dealloc{
    [self removeNotifications];
}

@end
