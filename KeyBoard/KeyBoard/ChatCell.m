//
//  ChatCell.m
//  KeyBoard
//
//  Created by 杨路文 on 16/5/6.
//  Copyright © 2016年 杨路文. All rights reserved.
//

#import "ChatCell.h"
@implementation ChatCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.chatLabel = [YYLabel new];
        _chatLabel.textVerticalAlignment = YYTextVerticalAlignmentCenter;
        _chatLabel.numberOfLines = 0;
//        _chatLabel.font = [UIFont systemFontOfSize:22];
        [self.contentView addSubview:_chatLabel];
    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}
- (void)setTheTextWithData:(NSMutableAttributedString *)attr
{
    self.chatLabel.attributedText = attr;
    CGSize size = CGSizeMake([UIScreen mainScreen].bounds.size.width, CGFLOAT_MAX);
    YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:size text:attr];
    self.chatLabel.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, layout.textBoundingSize.height);
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
