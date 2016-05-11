//
//  UIButton+buttonName.m
//  KeyBoard
//
//  Created by 杨路文 on 16/5/5.
//  Copyright © 2016年 杨路文. All rights reserved.
//  //  729225316@qq.com

#import "UIButton+buttonName.h"
#import <objc/runtime.h>
#import "YYText.h"
#import "YYImage.h"
#import "SDWebImageManager.h"
#import "Base64.h"
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
- (void)startWithTimeInterval:(double)timeLine
{
    
    // 倒计时时间
    __block NSInteger timeOut = timeLine;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    // 每秒执行一次
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_timer, ^{
        
        // 倒计时结束，关闭
        if (timeOut <= 0) {
            dispatch_source_cancel(_timer);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                self.backgroundColor = [UIColor orangeColor];
                [self setTitle:@"发送" forState:UIControlStateNormal];
                self.userInteractionEnabled = YES;
            });
            
        }else{
            
            int seconds = timeOut % 60;
            NSString * timeStr = [NSString stringWithFormat:@"%d",seconds];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.backgroundColor = [UIColor orangeColor];
                [self setTitle:[NSString stringWithFormat:@"%@s",timeStr] forState:UIControlStateNormal];
                self.userInteractionEnabled = NO;
            });
            
            timeOut--;
        }
    });
    
    dispatch_resume(_timer);
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
//        如果是本地图片 直接从本地取
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
            NSMutableAttributedString *attachemnt = [NSMutableAttributedString
                                                     yy_attachmentStringWithContent:imageview
                                                     contentMode:UIViewContentModeCenter attachmentSize:imageview.frame.size
                                                     alignToFont:[UIFont systemFontOfSize:16]
                                                     alignment:YYTextVerticalAlignmentCenter];
            
            [imageArr insertObject:attachemnt atIndex:0];
            [rangeArr insertObject:result atIndex:0];
        }else{
//            从网上下载
#warning 网络图片网址瞎写的
            NSData *imageData = imageData = [NSData customDataWithContentsOfURL:@"http://www.zhibo9988.com/cssimg/face/0.gif"];
            
            YYImage *image = [YYImage imageWithData:imageData scale:1];
            image.preloadAllAnimatedImageFrames = YES;
            YYAnimatedImageView *imageview = [[YYAnimatedImageView alloc]initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
            imageview.image = image;
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

- (NSString *)getDownloadImagePath
{
    NSString *str = [self base64EncodedString];
    NSString *path = [NSHomeDirectory() stringByAppendingString:[NSString stringWithFormat:@"/Documents/%@",str]];
    return path;
}

@end


@implementation NSData (downloadImage)

+ (NSData *)customDataWithContentsOfURL:(NSString *)urlStr
{
    NSString *path = [urlStr getDownloadImagePath];
    NSData *imageData;
    if ([NSData dataWithContentsOfFile:path])
    {
        imageData = [NSData dataWithContentsOfFile:path];
        NSLog(@"从本地取出来的图片");
    }else
    {
        imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlStr]];
        
        [imageData writeToFile:path atomically:YES];
        NSLog(@"图片存储路径====%@",path);
    }
    return imageData;

}

@end




