//
//  UIButton+buttonName.h
//  KeyBoard
//
//  Created by 杨路文 on 16/5/5.
//  Copyright © 2016年 杨路文. All rights reserved.
//  //  729225316@qq.com

#import <UIKit/UIKit.h>

@interface UIButton (buttonName)
@property (nonatomic, copy) NSString *btnBGImageName;//按钮图片名字
/**
 *  发送按钮 增加发言间隔
 *
 *  @param timeLine 间隔时间
 */
- (void)startWithTimeInterval:(double)timeLine;

@end


@interface UIView (viewHeight)
@property (nonatomic, strong) NSNumber *viewHeight;
@end

@interface NSString (dealMessage)
/**
 *  处理单条聊天数据
 *
 *  @return 处理好的信息
 */
- (NSMutableAttributedString*)dealTheMessage;

/**
 *  根据url字符串 转化为图片的本地的路径
 *
 *  @return 图片的本地路径
 */
- (NSString *)getDownloadImagePath;
@end

@interface NSData (downloadImage)
/**
 *  模仿sd原理 如果本地有 从本地取
 *
 *  @param urlStr 图片地址
 *
 *  @return 返回image的data类型
 */
+ (NSData *)customDataWithContentsOfURL:(NSString *)urlStr;
@end

