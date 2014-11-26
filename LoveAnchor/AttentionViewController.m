//
//  AttentionViewController.m
//  LoveAnchor
//
//  Created by zhongqinglongtu on 14-8-11.
//  Copyright (c) 2014年 zhongqinglongtu. All rights reserved.
//

#import "AttentionViewController.h"

@interface AttentionViewController ()<ASIHTTPRequestDelegate,ThirdRowTableViewCellDelegate,FirstRowTableViewCellDelegate,SecondRowTableViewCellDelegate>
{
    LoginModel *model;
    NSMutableArray *_dataArray;
    UITableView *_tableView;
}
@property (nonatomic,strong) HomePageViewController *home;
@end

@implementation AttentionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _dataArray = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    model = [CommonUtil getUserModel];
    self.view.backgroundColor = [UIColor whiteColor];
    [self showUI];
    [self request];
}

#pragma mark - 界面

- (void)showUI
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-49-64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
}

#pragma mark - delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *modelArray = [_dataArray objectAtIndex:indexPath.row];
    if (indexPath.row == 0) {
        FirstRowTableViewCell *firstCellRow = [tableView dequeueReusableCellWithIdentifier:@"firstCellRow"];
        if (firstCellRow == nil) {
            firstCellRow = [[FirstRowTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"firstCellRow"];
        }
        firstCellRow.selectionStyle = UITableViewCellSelectionStyleNone;
        firstCellRow.delegate = self;
        [firstCellRow setCellData:modelArray];
        return firstCellRow;
    } else if (indexPath.row == 1) {
        SecondRowTableViewCell *secondCellRow = [tableView dequeueReusableCellWithIdentifier:@"secondCellRow"];
        if (secondCellRow == nil) {
            secondCellRow = [[SecondRowTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"scondCellRow"];
        }
        secondCellRow.selectionStyle = UITableViewCellSelectionStyleNone;
        secondCellRow.delegate = self;
        [secondCellRow setCellData:modelArray];
        return secondCellRow;
    }else {
        ThirdRowTableViewCell *thirdCellRow = [tableView dequeueReusableCellWithIdentifier:@"thirdCellRow"];
        if (thirdCellRow == nil) {
            thirdCellRow = [[ThirdRowTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"thirdCellRow"];
        }
        thirdCellRow.selectionStyle = UITableViewCellSelectionStyleNone;
        thirdCellRow.selectionStyle = UITableViewCellSelectionStyleNone;
        thirdCellRow.delegate = self;
        return thirdCellRow;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 170;
    } else if (indexPath.row == 1) {
        return 122;
    } else {
        return 83;
    }
}
#pragma mark ThirdRowTableViewCellDelegate
- (void)thirdClick:(AllModel *)allModel {
    
    if (!self.home.rightisVisible && !self.home.leftisVisible) {
        PlayViewController *play = [[PlayViewController alloc]init];
        play.allModel = allModel;
        [self presentViewController:play animated:YES completion:nil];
    }
    
}

-(void)firstClick:(AllModel *)allModel
{
    if (!self.home.rightisVisible && !self.home.leftisVisible) {
        PlayViewController *play = [[PlayViewController alloc]init];
        play.allModel = allModel;
        [self presentViewController:play animated:YES completion:nil];
    }
}

-(void)secondClick:(AllModel *)allModel
{
    if (!self.home.rightisVisible && !self.home.leftisVisible) {
        PlayViewController *play = [[PlayViewController alloc]init];
        play.allModel = allModel;
        [self presentViewController:play animated:YES completion:nil];
    }
}


#pragma mark - 解析
- (void)request
{
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://ttapi.izhubo.com/user/following_list/%@",model.access_token]]];
    request.delegate = self;
    [request setTimeOutSeconds:100];
    [request startAsynchronous];
}

-(void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"关注 == %@",request.responseString);
    id result = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
    if ([result isKindOfClass:[NSDictionary class]]) {
        
        NSDictionary *dict = [result objectForKey:@"data"];
        NSArray *array = [dict objectForKey:@"rooms"];
        NSLog(@"data == %@",array);
        NSMutableArray *allDtJson_mutable = [NSMutableArray array];
        
        for (NSDictionary *dict in array) {
            AllModel *modelData = [[AllModel alloc]init];
            [modelData setValuesForKeysWithDictionary:dict];
            [allDtJson_mutable addObject:modelData];
        }
        NSArray *firstRowData = @[[allDtJson_mutable objectAtIndex:0]];
        [_dataArray addObject:firstRowData];
        
        NSArray *secondRowData = @[[allDtJson_mutable objectAtIndex:1],[allDtJson_mutable objectAtIndex:2]];
        [_dataArray addObject:secondRowData];
        
        NSUInteger count = [allDtJson_mutable count];
        NSMutableArray *thirdRowData = [NSMutableArray array];
        for (int i = 0; i < count-3; i++) {
            if (i%3 == 0 && i != 0) {
                [_dataArray addObject:thirdRowData];
                thirdRowData = [NSMutableArray array];
            }
            [thirdRowData addObject:allDtJson_mutable[i+3]];
        }
        [_dataArray addObject:thirdRowData];
        NSLog(@"_dataArray = %lu",(unsigned long)_dataArray.count);
    }
    [_tableView reloadData];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
