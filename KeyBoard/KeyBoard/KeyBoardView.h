//
//  KeyBoardView.h
//  KeyBoard
//
//  Created by 杨路文 on 16/5/5.
//  Copyright © 2016年 杨路文. All rights reserved.
//  //  729225316@qq.com

#import <UIKit/UIKit.h>
#import "FaceBoard.h"
#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height
@interface KeyBoardView : UIView<UITextViewDelegate>
@property (nonatomic, strong) FaceBoard *faceBoard;//表情view
@property (nonatomic, strong) UIView *toolBar;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UIButton *keyboardButton;
@property (nonatomic, strong) UIButton *sendButton;
@property (nonatomic, strong) UIImageView *keyboardImage;
@property (nonatomic, assign) id delegate;
@property (nonatomic, assign) BOOL isKeyBoardShow;
- (instancetype)initWithTheBGView:(UIView *)bgview;
//结束编辑 调用这个方法
- (void)keyboardResignFirstResponder;

@end


@protocol sendMessageDelegate <NSObject>

- (void)getTheMessage:(NSString *)text;

@optional
- (void)theKeyBoardWillShowWithKeyBoardHeight:(CGFloat)boardHeight;
- (void)theKeyBoardDidHiden;

@end