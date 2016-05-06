//
//  ChatCell.h
//  KeyBoard
//
//  Created by 杨路文 on 16/5/6.
//  Copyright © 2016年 杨路文. All rights reserved.
//  //  729225316@qq.com

#import <UIKit/UIKit.h>
#import "YYText.h"
#import "YYLabel.h"

@interface ChatCell : UITableViewCell
@property (strong, nonatomic) YYLabel *chatLabel;
- (void)setTheTextWithData:(NSMutableAttributedString *)attr;
@end
