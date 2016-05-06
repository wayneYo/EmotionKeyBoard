//
//  FaceBoard.h
//
//  Created by blue on 12-9-26.
//  Copyright (c) 2012年 blue. All rights reserved.
//  Email - 360511404@qq.com
//  http://github.com/bluemood

#import <UIKit/UIKit.h>

//#import "FaceButton.h"

#import "GrayPageControl.h"


#define FACE_NAME_HEAD  @"["

// 表情转义字符的长度（ /s占2个长度，xxx占3个长度，共5个长度 ）
#define FACE_NAME_LEN   5


@protocol FaceBoardDelegate <NSObject>

@optional

- (void)textViewDidChange:(UITextView *)textView;

@end


@interface FaceBoard : UIView<UIScrollViewDelegate>{
    UIScrollView*_scroll;
    NSMutableArray*_caiTiaoArray;
    
    UIScrollView *expressionScroll;
    

    GrayPageControl *facePageControl;
    
    int _whichPage;
    NSDictionary *_faceMap1;
    NSDictionary *_pbFaceMap;
    NSDictionary *_xFaceMap;
    NSDictionary *_ctFaceMap;
}


@property (nonatomic, assign) id<FaceBoardDelegate> delegate;

@property (nonatomic, retain) UITextField *inputTextField;

@property (nonatomic, retain) UITextView *inputTextView;
@property(nonatomic,copy)void(^sendCaiTiaoPicture)(NSString *str);

@property (nonatomic, retain) NSMutableArray *menuArray;
- (void)backFace;


@end
