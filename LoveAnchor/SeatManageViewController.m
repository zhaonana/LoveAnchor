//
//  SeatManageViewController.m
//  LoveAnchor
//
//  Created by zhongqinglongtu on 14-11-15.
//  Copyright (c) 2014年 zhongqinglongtu. All rights reserved.
//

#import "SeatManageViewController.h"

@interface SeatManageViewController ()<ASIHTTPRequestDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UIScrollView *scrollerView;
    UIButton *forbiddenButton;
//    UIButton *continueButton;
    UITableView *_tableView;
    LoginModel *model;
    NSMutableArray *allSeatArray;
    NSMutableArray *carArray;
    NSMutableArray *mySeatArray;
    NSString *currId;
    int newTag;
}

@end

@implementation SeatManageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSData *myEncodedObject = [[NSUserDefaults standardUserDefaults] objectForKey:@"books"];
    model = [NSKeyedUnarchiver unarchiveObjectWithData: myEncodedObject];
    
    [self requestWithParams:[NSString stringWithFormat:@"show/cars_list"] tag:100];
    [self requestWithParams:[NSString stringWithFormat:@"user/car_info/%@",model.access_token] tag:101];
    [self showUI];
}

- (void)showUI
{
    UIButton *titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    titleButton.frame = CGRectMake(0, 0, 50, 44);
    titleButton.tag = 100;
    [titleButton setTitle:@"返回" forState:UIControlStateNormal];
    titleButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [titleButton setTitleColor:textFontColor forState:UIControlStateNormal];
    [titleButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar addSubview:titleButton];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(110, 0, 100, 44)];
    label.text = @"我的座驾";
    label.font = [UIFont systemFontOfSize:18];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = textFontColor;
    label.textAlignment = NSTextAlignmentCenter;
    [self.navigationController.navigationBar addSubview:label];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:_tableView];
}
- (void)buttonClick:(UIButton *)button
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"SeatManageTableViewCell";
    SeatManageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[SeatManageTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    SeatManageModel *seat = [mySeatArray objectAtIndex:indexPath.row];
    [cell setCellData:seat];
    
    __block SeatManageViewController *seatSelf = self;
    if (seat._id.intValue == currId.intValue) {
        [cell.useButton setTitle:@"禁用" forState:UIControlStateNormal];
        [cell.useButton setTitle:@"禁用" forState:UIControlStateHighlighted];
        cell.UseButtonClickBlock = ^() {
            [seatSelf requestWithParams:[NSString stringWithFormat:@"shop/unset_curr_car/%@",model.access_token] tag:103];
        };
    } else {
        [cell.useButton setTitle:@"启用" forState:UIControlStateNormal];
        [cell.useButton setTitle:@"启用" forState:UIControlStateHighlighted];
        cell.UseButtonClickBlock = ^() {
            [seatSelf requestWithParams:[NSString stringWithFormat:@"shop/set_curr_car/%@/%@",model.access_token,seat._id] tag:102];
        };
    }

    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return mySeatArray.count;
}

#pragma mark - 数据解析
- (void)requestWithParams:(NSString *)params tag:(int)tag;
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://ttapi.izhubo.com/%@",params]];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    request.delegate = self;
    request.tag = tag;
    [request setTimeOutSeconds:100];
    [request startAsynchronous];
}
//拥有座驾
- (void)request
{
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://ttapi.izhubo.com/user/car_info/%@",model.access_token]]];
    request.delegate = self;
    request.tag = 101;
    [request setTimeOutSeconds:100];
    [request startAsynchronous];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    id result = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
    switch (request.tag) {
        case 100: {
            if ([result isKindOfClass:[NSDictionary class]]) {
                NSArray *dataArray = [result objectForKey:@"data"];
                allSeatArray = [NSMutableArray array];
                for (NSDictionary *dict in dataArray) {
                    SeatManageModel *allSeat = [[SeatManageModel alloc] init];
                    allSeat.pic_url = [dict objectForKey:@"pic_url"];
                    allSeat._id = [dict objectForKey:@"_id"];
                    [allSeatArray addObject:allSeat];
                }
            }
        }
            break;
        case 101: {
            if ([result isKindOfClass:[NSDictionary class]]) {
                NSDictionary *seatDict = [result objectForKey:@"data"];
                NSDictionary *dic = [seatDict objectForKey:@"car"];
                currId = [dic objectForKey:@"curr"];
                carArray = [NSMutableArray arrayWithArray:dic.allKeys];
                [carArray removeObject:@"curr"];
                mySeatArray = [[NSMutableArray alloc] initWithCapacity:0];
                for (NSString *ids in carArray) {
                    for (SeatManageModel *seat in allSeatArray) {
                        if (seat._id.intValue == ids.intValue) {
                            seat.time = [dic objectForKey:ids];
                            [mySeatArray addObject:seat];
                        }
                    }
                }
            }
            [_tableView reloadData];
        }
            break;
        case 102: { //启用座驾
            if ([result isKindOfClass:[NSDictionary class]]) {
                NSString *code = [result objectForKey:@"code"];
                if (code.intValue == 1) {
                    [self requestWithParams:[NSString stringWithFormat:@"user/car_info/%@",model.access_token] tag:101];
                }
            }
        }
            break;
        case 103: { //禁用座驾
            if ([result isKindOfClass:[NSDictionary class]]) {
                NSString *code = [result objectForKey:@"code"];
                if (code.intValue == 1) {
                    [self requestWithParams:[NSString stringWithFormat:@"user/car_info/%@",model.access_token] tag:101];
                }
            }
        }
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
