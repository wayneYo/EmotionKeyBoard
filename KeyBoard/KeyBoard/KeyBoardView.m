//
//  KeyBoardView.m
//  KeyBoard
//
//  Created by 杨路文 on 16/5/5.
//  Copyright © 2016年 杨路文. All rights reserved.
//  729225316@qq.com

#import "KeyBoardView.h"
#import "UIButton+buttonName.h"
@implementation KeyBoardView
- (instancetype)initWithTheBGView:(UIView *)bgview
{
    self = [super init];
    if (self) {
        
        [self loadViewWithView:bgview];
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardDidHide:)
                                                     name:UIKeyboardDidHideNotification
                                                   object:nil];
        
        

        

    }
    return self;
}
- (void)loadViewWithView:(UIView *)bgview
{
    _toolBar = [[UIView alloc]initWithFrame:CGRectMake(0, SCREENHEIGHT-44, SCREENWIDTH, 44)];
    _toolBar.backgroundColor = [UIColor grayColor];
    [bgview addSubview:_toolBar];
    
    
    _textView = [[UITextView alloc]initWithFrame:CGRectMake(41, 6, SCREENWIDTH-126, 32)];
    [_textView.layer setCornerRadius:6];
    _textView.backgroundColor = [UIColor whiteColor];
    _textView.font = [UIFont systemFontOfSize:17];
    [_textView.layer setMasksToBounds:YES];
    _textView.delegate = self;
    
    [_toolBar addSubview:_textView];
    
    _keyboardImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 12, 21, 20)];
    _keyboardImage.image = [UIImage imageNamed:@"icon-biaoqing"];
    [_toolBar addSubview:_keyboardImage];
    
    _keyboardButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _keyboardButton.frame = CGRectMake(0, 0, 40, 44);
    [_keyboardButton addTarget:self action:@selector(faceBoardClick) forControlEvents:UIControlEventTouchUpInside];
    [_toolBar addSubview:_keyboardButton];
    
    
    
    _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _sendButton.frame = CGRectMake(SCREENWIDTH-75, 7, 65, 30);
    _sendButton.clipsToBounds = YES;
    _sendButton.layer.cornerRadius = 5;
    _sendButton.backgroundColor = [UIColor orangeColor];
    [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
    [_sendButton addTarget:self action:@selector(sendTheMessage:) forControlEvents:UIControlEventTouchUpInside];
    [_toolBar addSubview:_sendButton];
    
    
    _faceBoard = [[FaceBoard alloc]initWithFrame:CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, 250)];
    _faceBoard.inputTextView = _textView;
    __weak __typeof__ (self) wself = self;
    
    _faceBoard.sendCaiTiaoPicture = ^(NSString *str){
        if ([wself.delegate respondsToSelector:@selector(getTheMessage:)]) {
            [wself.delegate getTheMessage:str];
        }
    };
    [bgview addSubview:_faceBoard];
    
    _isKeyBoardShow = YES;
    
    
    //        添加手势  当结束编辑状态 按textview 光标移到最后
    UITapGestureRecognizer *tapDescription = [[UITapGestureRecognizer alloc]
                                              initWithTarget:self action:@selector(tapDescription:)];
    [_textView addGestureRecognizer:tapDescription];

}
- (void) tapDescription:(UIGestureRecognizer *)gr {
//    通过手势开启编辑
    [self textviewBegainEdit];
}
- (void)textviewBegainEdit
{
    self.textView.editable = YES;
    [self.textView becomeFirstResponder];
}
- (void) textViewDidEndEditing:(UITextView *)textView {
    //whatever else you need to do
    textView.editable = NO;
}


- (void)keyboardWillShow:(NSNotification *)notification {
    
    
    _isKeyBoardShow = YES;
    
    NSDictionary *userInfo = [notification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGRect keyboardRect = [aValue CGRectValue];
    keyboardRect = [self convertRect:keyboardRect fromView:nil];
    
    _toolBar.viewHeight = [NSNumber numberWithFloat:SCREENHEIGHT-keyboardRect.size.height-44];
    [UIView animateWithDuration:0.25 animations:^{
        _toolBar.frame = CGRectMake(0, SCREENHEIGHT-keyboardRect.size.height-44, SCREENWIDTH, 44);

    }];
    
    if ([_delegate respondsToSelector:@selector(theKeyBoardWillShowWithKeyBoardHeight:)]) {
        [_delegate theKeyBoardWillShowWithKeyBoardHeight:keyboardRect.size.height];
    }
    
}

- (void)keyboardWillHide:(NSNotification *)notification {
    
    
}

- (void)keyboardDidHide:(NSNotification *)notification {
    
//    _isKeyBoardShow = YES;
}

- (void)faceBoardClick
{
    _isKeyBoardShow = !_isKeyBoardShow;
    if (_isKeyBoardShow) {
        [self textviewBegainEdit];
        [UIView animateWithDuration:0.25 animations:^{
            _faceBoard.frame = CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, 250);
            
        }];
    }else{
        [_textView resignFirstResponder];
        
        NSLog(@"resignFirstResponder");
        _toolBar.viewHeight = [NSNumber numberWithFloat:SCREENHEIGHT-250-44];
        [UIView animateWithDuration:0.25 animations:^{
            _toolBar.frame = CGRectMake(0, SCREENHEIGHT-250-44, SCREENWIDTH, 44);
            _faceBoard.frame = CGRectMake(0, SCREENHEIGHT-250, SCREENWIDTH, 250);
            
        }];
        
        if ([_delegate respondsToSelector:@selector(theKeyBoardWillShowWithKeyBoardHeight:)]) {
            [_delegate theKeyBoardWillShowWithKeyBoardHeight:250];
        }
    }
    
    
    
}
- (void) textViewDidBeginEditing:(UITextView *)textView {
    // 光标移到最后
    NSRange insertionPoint = NSMakeRange(textView.text.length, 0);
    textView.selectedRange = insertionPoint;
}


//根据textview改变控件高度
//- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
//{
//    CGRect rect = [textView.text boundingRectWithSize:CGSizeMake(SCREENWIDTH-126, 0) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:17]} context:nil];
//    CGFloat toolBarHeight = rect.size.height>32?rect.size.height+12:44;
//    _toolBar.frame = CGRectMake(0, [_toolBar.viewHeight floatValue]-(toolBarHeight-44), SCREENWIDTH, toolBarHeight);
//    _textView.frame = CGRectMake(41, 6, SCREENWIDTH-126, toolBarHeight-12);
//    return YES;
//}

- (void)sendTheMessage:(UIButton *)btn
{
    if (![_textView.text isEqualToString:@""]) {
        [self keyboardResignFirstResponder];
        
        
        NSLog(@"%@",_textView.text);
        
        if ([_delegate respondsToSelector:@selector(getTheMessage:)]) {
            [_delegate getTheMessage:_textView.text];
        }
        _textView.text = nil;
        [btn startWithTimeInterval:5];
    }
}

- (void)keyboardResignFirstResponder
{
    [_textView resignFirstResponder];
    self.isKeyBoardShow = YES;
    self.toolBar.viewHeight = [NSNumber numberWithFloat:SCREENHEIGHT-44];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.faceBoard.frame = CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, 250);
        self.toolBar.frame = CGRectMake(0, SCREENHEIGHT-44, SCREENWIDTH, 44);
    }];
    
    if ([_delegate respondsToSelector:@selector(theKeyBoardDidHiden)]) {
        [_delegate theKeyBoardDidHiden];
    }
}


@end
