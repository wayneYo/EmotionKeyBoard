//
//  UIButton+buttonName.h
//  KeyBoard
//
//  Created by 杨路文 on 16/5/5.
//  Copyright © 2016年 杨路文. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (buttonName)
@property (nonatomic, copy) NSString *btnBGImageName;//按钮图片名字
@end


@interface UIView (viewHeight)
@property (nonatomic, strong) NSNumber *viewHeight;
@end

@interface NSString (dealMessage)
- (NSMutableAttributedString*)dealTheMessage;
@end