//
//  ViewController.m
//  KeyBoard
//
//  Created by 杨路文 on 16/5/5.
//  Copyright © 2016年 杨路文. All rights reserved.
//

#import "ViewController.h"
#import "KeyBoardView.h"
#import "UIButton+buttonName.h"
#import "ChatCell.h"
@interface ViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,sendMessageDelegate>
{
    KeyBoardView *_board;
    NSMutableArray *_dataArr;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    
    
    _dataArr = [NSMutableArray array];
    
    
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 20, SCREENWIDTH, SCREENHEIGHT-64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [_tableView registerClass:[ChatCell class] forCellReuseIdentifier:@"cell"];
    
    _board = [[KeyBoardView alloc]initWithTheBGView:self.view];
    _board.delegate = self;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChatCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    [cell setTheTextWithData:_dataArr[indexPath.row]];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size = CGSizeMake(SCREENWIDTH, CGFLOAT_MAX);
    YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:size text:_dataArr[indexPath.row]];
    return layout.textBoundingSize.height;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark-------------sendMessageDelegate----------------
//获取发送消息的代理方法
- (void)getTheMessage:(NSString *)text
{

    [_dataArr addObject:[text dealTheMessage]];
    NSArray *arr = @[[NSIndexPath indexPathForRow:_dataArr.count-1 inSection:0]];
    [_tableView insertRowsAtIndexPaths:arr withRowAnimation:UITableViewRowAnimationNone];
}
- (void)theKeyBoardWillShowWithKeyBoardHeight:(CGFloat)boardHeight
{
    _tableView.frame = CGRectMake(0, 20, SCREENWIDTH, SCREENHEIGHT-boardHeight-44);
}
- (void)theKeyBoardDidHiden
{
    _tableView.frame = CGRectMake(0, 20, SCREENWIDTH, SCREENHEIGHT-44);
}
@end
