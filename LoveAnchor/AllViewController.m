//
//  AllViewController.m
//  LoveAnchor
//
//  Created by zhongqinglongtu on 14-8-11.
//  Copyright (c) 2014年 zhongqinglongtu. All rights reserved.
//

#import "AllViewController.h"
#import "MJRefresh.h"

#define REFRESH_NOTFICATION @"refreshNotification"
#define REFRESH_BACK_NOTFICATION @"refreshBackNotification"

@interface AllViewController () <ThirdRowTableViewCellDelegate,FirstRowTableViewCellDelegate,SecondRowTableViewCellDelegate>
{
    NSMutableArray *_dataArray;
    UITableView *_tableView;
    BOOL _tag;
    NSString *_liveType;
}
@end

@implementation AllViewController

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
    self.view.backgroundColor = [UIColor whiteColor];
    [self shouUI];
    [self request];
    [self setupRefresh];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshView:) name:REFRESH_NOTFICATION object:nil];
}

- (void)refreshView:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    if ([userInfo objectForKey:@"allType"]) {
        _liveType = @"allType";
        _dataArray = [NSMutableArray arrayWithArray:[userInfo objectForKey:@"allType"]];
    }
    if ([userInfo objectForKey:@"superstarType"]) {
        _dataArray = [NSMutableArray arrayWithArray:[userInfo objectForKey:@"superstarType"]];
        _liveType = @"superstarType";
    }
    if ([userInfo objectForKey:@"giantstarType"]) {
        _dataArray = [NSMutableArray arrayWithArray:[userInfo objectForKey:@"giantstarType"]];
        _liveType = @"giantstarType";
    }
    if ([userInfo objectForKey:@"starType"]) {
        _dataArray = [NSMutableArray arrayWithArray:[userInfo objectForKey:@"starType"]];
        _liveType = @"starType";
    }
    if ([userInfo objectForKey:@"rookieType"]) {
        _dataArray = [NSMutableArray arrayWithArray:[userInfo objectForKey:@"rookieType"]];
        _liveType = @"rookieType";
    }
    [_tableView reloadData];
    [self.home rightClick];
}

#pragma mark - 界面
- (void)shouUI {
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-49-64)style:UITableViewStylePlain];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    _tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
    
}

/**
 *  集成刷新控件
 */
- (void)setupRefresh
{
    //下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [_tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    [_tableView headerBeginRefreshing];
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    //请求数据
    if (_liveType.length) {
        [[NSNotificationCenter defaultCenter] postNotificationName:REFRESH_BACK_NOTFICATION object:_liveType];
    } else {
        [self request];
    }
    
    //2秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [_tableView headerEndRefreshing];
    });
}

#pragma mark - 数据解析
- (void)request
{
    NSString *urlStr = [NSString stringWithFormat:@"%@public/room_list",BaseURL];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [request setTimeOutSeconds:100];
    request.delegate = self;
    [request startAsynchronous];
}

-(void)requestFinished:(ASIHTTPRequest *)request
{   
    id resutl = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
    if ([resutl isKindOfClass:[NSDictionary class]]) {
        NSArray *allDtJson = [resutl objectForKey:@"data"];
        NSMutableArray *allDtJson_mutable = [NSMutableArray array];
        
        for (NSDictionary *dict in allDtJson) {
            AllModel *model = [[AllModel alloc]init];
            [model setValuesForKeysWithDictionary:dict];
            [allDtJson_mutable addObject:model];
        }
        
        [_dataArray removeAllObjects];
        
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
        if (thirdRowData.count) {
            [_dataArray addObject:thirdRowData];
        }
    }
    [_tableView reloadData];
}

-(void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"error == %@",request.error);
}

#pragma mark - delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{   
    NSArray *modelArray = [_dataArray objectAtIndex:indexPath.row];
    if (indexPath.row == 0) {
        FirstRowTableViewCell *firstCell = [[FirstRowTableViewCell alloc] init];
        firstCell.selectionStyle = UITableViewCellSelectionStyleNone;
        firstCell.delegate = self;
        [firstCell setCellData:modelArray];
        return firstCell;
    } else if (indexPath.row == 1) {
        SecondRowTableViewCell *secondCell = [[SecondRowTableViewCell alloc]init];
        secondCell.selectionStyle = UITableViewCellSelectionStyleNone;
        secondCell.delegate = self;
        [secondCell setCellData:modelArray];
        return secondCell;
    } else {
        ThirdRowTableViewCell *thirdCell = [[ThirdRowTableViewCell alloc] init];
        thirdCell.selectionStyle = UITableViewCellSelectionStyleNone;
        thirdCell.delegate = self;
        [thirdCell setCellData:modelArray];
        
        return thirdCell;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataArray count];
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

@end
