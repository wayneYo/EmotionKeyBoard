//
//  UIButton+buttonName.m
//  KeyBoard
//
//  Created by 杨路文 on 16/5/5.
//  Copyright © 2016年 杨路文. All rights reserved.
//

#import "UIButton+buttonName.h"
#import <objc/runtime.h>
#import "YYText.h"
#import "YYImage.h"
@implementation UIButton (buttonName)
- (id)btnBGImageName
{
    id object = objc_getAssociatedObject(self, @"111");
    
    return object;
}

- (void)setBtnBGImageName:(id)name
{
    [self willChangeValueForKey:@"btnBGImageName"];
    objc_setAssociatedObject(self, @"111", name, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:@"btnBGImageName"];
}
@end

@implementation UIView (viewHeight)

- (id)viewHeight
{
    id object = objc_getAssociatedObject(self, @"viewHeight");
    
    return object;
}

- (void)setViewHeight:(id)theHeight
{
    [self willChangeValueForKey:@"viewHeight"];
    objc_setAssociatedObject(self, @"viewHeight", theHeight, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:@"viewHeight"];
}

@end

@implementation NSString (dealMessage)

- (NSMutableAttributedString*)dealTheMessage
{
    NSDictionary *emotionDic = [NSDictionary dictionaryWithContentsOfFile:
                                [[NSBundle mainBundle] pathForResource:@"emotionImage"
                                                                ofType:@"plist"]];
    
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:self];
    attr.yy_font = [UIFont systemFontOfSize:20];
    NSString *pattern = @"\\[[0-9a-zA-Z\\u4e00-\\u9fa5]+\\]";
    NSRegularExpression *regular = [[NSRegularExpression alloc]initWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSArray *arr = [regular matchesInString:attr.string options:NSMatchingReportProgress range:NSMakeRange(0, attr.string.length)];
    NSMutableArray *imageArr = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray *rangeArr = [NSMutableArray arrayWithCapacity:0];
    for (NSTextCheckingResult *result in arr) {
        NSString *matchstring = [attr.string substringWithRange:result.range];
        if ([[emotionDic allKeys] containsObject:matchstring]) {
            NSString *imageName = [emotionDic objectForKey:matchstring];
            
            NSString *path = [[NSBundle mainBundle] pathForResource:[imageName componentsSeparatedByString:@"."][0] ofType:[imageName componentsSeparatedByString:@"."][1]];
            NSData *data = [NSData dataWithContentsOfFile:path];
            YYImage *image = [YYImage imageWithData:data scale:2];
            image.preloadAllAnimatedImageFrames = YES;
             YYAnimatedImageView *imageview = [[YYAnimatedImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
//            判断是否是彩条
            if ([matchstring rangeOfString:@"[pt"].location != NSNotFound) {
                imageview.frame = CGRectMake(0, 0, 200, 30);
            }
            imageview.image = image;
//            imageview.image = [UIImage sd_animatedGIFNamed:imageName];
            NSMutableAttributedString *attachemnt = [NSMutableAttributedString
                                                     yy_attachmentStringWithContent:imageview
                                                     contentMode:UIViewContentModeCenter attachmentSize:imageview.frame.size
                                                     alignToFont:[UIFont systemFontOfSize:16]
                                                     alignment:YYTextVerticalAlignmentCenter];
            
            [imageArr insertObject:attachemnt atIndex:0];
            [rangeArr insertObject:result atIndex:0];
        }
    }
    int i = 0;
    for (NSTextCheckingResult *result in rangeArr) {
        NSMutableAttributedString *attchment = imageArr[i];
        [attr replaceCharactersInRange:result.range withAttributedString:attchment];
        i++;
    }
    
    NSLog(@"%@",attr.string);
    return attr;
}

@end







