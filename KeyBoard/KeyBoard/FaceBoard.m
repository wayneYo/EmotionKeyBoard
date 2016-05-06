//
//  FaceBoard.m
//
//  Created by blue on 12-9-26.
//  Copyright (c) 2012年 blue. All rights reserved.
//  Email - 360511404@qq.com
//  http://github.com/bluemood

#import "FaceBoard.h"
#import "UIButton+buttonName.h"
#define screenWidth [UIScreen mainScreen].bounds.size.width

#define FACE_COUNT_ALL  54
#define LTFACE_COUNT_ALL  56
#define HZFACE_COUNT_ALL  47

#define PBFACE_COUNT_ALL  54
#define XFACE_COUNT_ALL  43

#define FACE_COUNT_ROW  4

#define FACE_COUNT_CLU  7

#define FACE_COUNT_PAGE ( FACE_COUNT_ROW * FACE_COUNT_CLU )

#define FACE_ICON_SIZE  44*(screenWidth/320.0)

#define FACESize 30*(screenWidth/320.0)

@implementation FaceBoard

@synthesize delegate;

@synthesize inputTextField = _inputTextField;
@synthesize inputTextView = _inputTextView;
-(void)whichScrollOfFourBtn:(int)tag howManySmallPicture:(int)many whichMap:(NSDictionary*)dic
{
    
    _scroll.tag = tag;
    _scroll.contentSize = CGSizeMake((many / FACE_COUNT_PAGE+1 ) * screenWidth, 190);
    _scroll.contentOffset = CGPointMake(0, 0);
    
    for (int i = 1; i <= many; i++) {
        
        
        UIButton *faceButton = [UIButton buttonWithType:UIButtonTypeCustom];
        //彩条
        if(tag==20000)
        {
            faceButton.tag = i+tag+1000;
            [faceButton addTarget:self
                           action:@selector(sendCaiTiao:)
                 forControlEvents:UIControlEventTouchUpInside];
            CGFloat x = screenWidth/2.0;
            faceButton.frame = CGRectMake(((i+1)%2)*x+10, (20+20)*((i-1)/2)+20, x-20, 20);
            [faceButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d.gif",i]] forState:UIControlStateNormal];
            
            faceButton.btnBGImageName = _caiTiaoArray[i-1];
            
        }else
        {
            faceButton.tag = i+tag+1000;
            
            [faceButton addTarget:self
                           action:@selector(faceButton:)
                 forControlEvents:UIControlEventTouchUpInside];
            
            //计算每一个表情按钮的坐标和在哪一屏
            CGFloat x = (((i - 1) % FACE_COUNT_PAGE) % FACE_COUNT_CLU) * FACE_ICON_SIZE + 6 + ((i - 1) / FACE_COUNT_PAGE * screenWidth);
            CGFloat y = (((i - 1) % FACE_COUNT_PAGE) / FACE_COUNT_CLU) * 44 + 8;
            faceButton.frame = CGRectMake( x+(FACE_ICON_SIZE-FACESize)/2.0, y+(FACE_ICON_SIZE-FACESize)/2.0, FACESize, FACESize);
            
            NSArray *array = [dic allKeys];
            NSArray *nameArr = [dic allValues];
            
            [faceButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@", array[i-1]]]
                        forState:UIControlStateNormal];
            faceButton.btnBGImageName = nameArr[i-1];
            
            
        }
        
        
        [_scroll addSubview:faceButton];
    }
    
}

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        
        _menuArray = [[NSMutableArray alloc]init];
        _caiTiaoArray = [[NSMutableArray alloc]initWithObjects:@"[pt顶一个]",@"[pt赞一个]",@"[pt掌声]",@"[pt鲜花]",@"[pt看多]",@"[pt看空]",@"[pt盘整]", nil];
        
        _faceMap1 = [NSDictionary dictionaryWithContentsOfFile:
                      [[NSBundle mainBundle] pathForResource:@"_expression_cn1"
                                                      ofType:@"plist"]];
        
        _pbFaceMap = [NSDictionary dictionaryWithContentsOfFile:
                       [[NSBundle mainBundle] pathForResource:@"_expression_cn5"
                                                       ofType:@"plist"]];
        _xFaceMap = [NSDictionary dictionaryWithContentsOfFile:
                          [[NSBundle mainBundle] pathForResource:@"_expression_cn6"
                                                          ofType:@"plist"]];
        double btnWidth = screenWidth/4.0;
        
        for (int i = 0; i < 4; i++)
        {
            
            
            UIButton *menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [menuBtn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"btn%d",i]] forState:UIControlStateNormal];
            [menuBtn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"select%d",i]] forState:UIControlStateSelected];
            if (i == 0)
            {
                menuBtn.selected = YES;
            }
            [menuBtn addTarget:self action:@selector(fourBtnSwitch:) forControlEvents:UIControlEventTouchUpInside];
            menuBtn.tag = 3000+i;
            menuBtn.frame = CGRectMake(i * btnWidth, 210, btnWidth, 40);
            [self addSubview:menuBtn];
            [_menuArray addObject:menuBtn];
        }
        if (!_scroll) {
            _scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 190)];
            _scroll.pagingEnabled = YES;
            _scroll.showsHorizontalScrollIndicator = NO;
            _scroll.showsVerticalScrollIndicator = NO;
            _scroll.delegate = self;
            [self addSubview:_scroll];
        }
        
        
        //添加PageControl
        facePageControl = [[GrayPageControl alloc]initWithFrame:CGRectMake((screenWidth-100)/2.0, 190, 100, 20)];
        [facePageControl addTarget:self
                            action:@selector(pageChange:)
                  forControlEvents:UIControlEventValueChanged];
        
        facePageControl.numberOfPages = FACE_COUNT_ALL / FACE_COUNT_PAGE+1;
        facePageControl.currentPage = 0;
        [self addSubview:facePageControl];
        //删除键
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [backBtn setImage:[UIImage imageNamed:@"del_emoji_normal"] forState:UIControlStateNormal];
        [backBtn setImage:[UIImage imageNamed:@"del_emoji_select"] forState:UIControlStateSelected];
        [backBtn addTarget:self action:@selector(backFace) forControlEvents:UIControlEventTouchUpInside];
        backBtn.frame = CGRectMake(screenWidth-48, 182, 38, 28);//320-272
        [self addSubview:backBtn];
        
//        创建键盘
        [self whichScrollOfFourBtn:10000 howManySmallPicture:FACE_COUNT_ALL whichMap:_faceMap1];
        
        
    }
    
    return self;
}
- (void)sendCaiTiao:(UIButton *)btn

{

    _sendCaiTiaoPicture(btn.btnBGImageName);

}


- (void)fourBtnSwitch:(UIButton *)btn
{
    for (UIButton *menuBtn in _menuArray)
    {
        menuBtn.selected = NO;
    }
    btn.selected = YES;
    for (UIButton *btn in _scroll.subviews) {
        [btn removeFromSuperview];

    }
    
    
    switch (btn.tag-3000)
    {
        case 0:
            [self whichScrollOfFourBtn:10000 howManySmallPicture:XFACE_COUNT_ALL whichMap:_faceMap1];
            facePageControl.numberOfPages = FACE_COUNT_ALL / FACE_COUNT_PAGE+1 ;
            break;
        case 1:
            [self whichScrollOfFourBtn:20000 howManySmallPicture:7 whichMap:nil];
            
            facePageControl.numberOfPages = 7 / FACE_COUNT_PAGE +1;
            break;
        case 2:
            
            [self whichScrollOfFourBtn:10001 howManySmallPicture:XFACE_COUNT_ALL whichMap:_xFaceMap];
            
            facePageControl.numberOfPages = XFACE_COUNT_ALL / FACE_COUNT_PAGE+1 ;
            break;
        case 3:
            
            [self whichScrollOfFourBtn:10002 howManySmallPicture:PBFACE_COUNT_ALL whichMap:_pbFaceMap];
            facePageControl.numberOfPages = PBFACE_COUNT_ALL / FACE_COUNT_PAGE +1;
            break;
        default:
            break;
            
    }
    [facePageControl setCurrentPage:0];
    
}
//停止滚动的时候
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    NSLog(@"----%ld",(long)scrollView.tag);
    
    [facePageControl setCurrentPage:_scroll.contentOffset.x / screenWidth];
    
    
    [facePageControl updateCurrentPageDisplay];
    
}

- (void)pageChange:(id)sender {
    
    [expressionScroll setContentOffset:CGPointMake(facePageControl.currentPage * 320, 0) animated:YES];
    [facePageControl setCurrentPage:facePageControl.currentPage];
}

- (void)faceButton:(UIButton*)btn {
    NSLog(@"%@",btn.btnBGImageName);
    if (self.inputTextView) {
        
        
        NSMutableString *faceString = [[NSMutableString alloc]initWithString:self.inputTextView.text];
        

        [faceString appendString:btn.btnBGImageName];

        self.inputTextView.text = faceString;
        
    }
}

- (void)backFace{
    
    NSString *inputString;
    inputString = self.inputTextField.text;
    if ( self.inputTextView ) {
        
        inputString = self.inputTextView.text;
    }
    
    if ( inputString.length ) {
        
        NSString *string = nil;
        NSInteger stringLength = inputString.length;
        //        if ( stringLength >= FACE_NAME_LEN ) {
        
        //            string = [inputString substringFromIndex:stringLength - FACE_NAME_LEN];
        NSRange range = [string rangeOfString:FACE_NAME_HEAD];
        if ( range.location == 0 ) {
            
            NSArray *array = [inputString componentsSeparatedByString:@"["];
            if (array.count >= 2)
            {
                string = [inputString substringToIndex:stringLength-[array[array.count-1] length]-1];
            }else
            {
                string = [inputString substringToIndex:stringLength - 1];
            }
            //                string = [inputString substringToIndex:
            //                          [inputString rangeOfString:FACE_NAME_HEAD
            //                                             options:NSBackwardsSearch].location];
        }
        else {
            
            string = [inputString substringToIndex:stringLength - 1];
        }

        
        if ( self.inputTextField ) {
            
            self.inputTextField.text = string;
        }
        
        if ( self.inputTextView ) {
            
            self.inputTextView.text = string;
            
            [delegate textViewDidChange:self.inputTextView];
        }
    }
}



@end
