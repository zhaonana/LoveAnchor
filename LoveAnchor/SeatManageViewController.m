//
//  SeatManageViewController.m
//  LoveAnchor
//
//  Created by zhongqinglongtu on 14-11-15.
//  Copyright (c) 2014年 zhongqinglongtu. All rights reserved.
//

#import "SeatManageViewController.h"

@interface SeatManageViewController ()<ASIHTTPRequestDelegate,UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    UIScrollView *scrollerView;
    UIButton *forbiddenButton;
    UITableView *_tableView;
    LoginModel *model;
    NSMutableArray *allSeatArray;
    NSMutableArray *carArray;
    NSMutableArray *mySeatArray;
    NSString *currId;
    NSNumber *seatId;
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
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    SeatManageModel *seat = [mySeatArray objectAtIndex:indexPath.row];
    [cell setCellData:seat];
    
    __block SeatManageViewController *seatSelf = self;
    if ([cell.timeLabel.text isEqualToString:@"已过期"]) {
        [cell.useButton setBackgroundImage:[UIImage imageNamed:@"shanchu"] forState:UIControlStateNormal];
        [cell.useButton setBackgroundImage:[UIImage imageNamed:@"shanchudianji"] forState:UIControlStateHighlighted];
        cell.UseButtonClickBlock = ^() {
            [seatSelf requestWithParams:[NSString stringWithFormat:@"shop/del_car/%@/%@",model.access_token,seat._id] tag:105];
        };
    } else {
        if (seat._id.intValue == currId.intValue) {
            [cell.useButton setBackgroundImage:[UIImage imageNamed:@"jinyong"] forState:UIControlStateNormal];
            [cell.useButton setBackgroundImage:[UIImage imageNamed:@"jinyongdianji"] forState:UIControlStateHighlighted];
            cell.UseButtonClickBlock = ^() {
                [seatSelf requestWithParams:[NSString stringWithFormat:@"shop/unset_curr_car/%@",model.access_token] tag:103];
            };
        } else {
            [cell.useButton setBackgroundImage:[UIImage imageNamed:@"qiyong"] forState:UIControlStateNormal];
            [cell.useButton setBackgroundImage:[UIImage imageNamed:@"qiyongdianji"] forState:UIControlStateHighlighted];
            cell.UseButtonClickBlock = ^() {
                [seatSelf requestWithParams:[NSString stringWithFormat:@"shop/set_curr_car/%@/%@",model.access_token,seat._id] tag:102];
            };
        }
    }
    [cell.continueButton setBackgroundImage:[UIImage imageNamed:@"xufei"] forState:UIControlStateNormal];
    [cell.continueButton setBackgroundImage:[UIImage imageNamed:@"xufeidianji"] forState:UIControlStateHighlighted];
    
    cell.ContinueButtonClickBlock = ^() {
        NSString *message = [NSString stringWithFormat:@"道具名称：%@\n购买天数：30天\n价格：%@金币",seat.name,seat.coin_price];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"购买道具确认" message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertView.tag = 1000;
        [alertView show];
        seatId = seat._id;
    };

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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        switch (alertView.tag) {
            case 1000: {
                [self requestWithParams:[NSString stringWithFormat:@"shop/buy_car/%@/%@",model.access_token,seatId] tag:104];
            }
                break;
            case 1001: {
                TopUpViewController *top = [[TopUpViewController alloc]init];
                UINavigationController *nc = [[UINavigationController alloc]initWithRootViewController:top];
                [self presentViewController:nc animated:YES completion:nil];
            }
                break;
            default:
                break;
        }
    }
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

- (void)requestFinished:(ASIHTTPRequest *)request
{
    id result = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
    switch (request.tag) {  //全部座驾
        case 100: {
            if ([result isKindOfClass:[NSDictionary class]]) {
                NSArray *dataArray = [result objectForKey:@"data"];
                allSeatArray = [NSMutableArray array];
                for (NSDictionary *dict in dataArray) {
                    SeatManageModel *allSeat = [[SeatManageModel alloc] init];
                    allSeat.pic_url = [dict objectForKey:@"pic_url"];
                    allSeat._id = [dict objectForKey:@"_id"];
                    allSeat.coin_price = [dict objectForKey:@"coin_price"];
                    allSeat.name = [dict objectForKey:@"name"];
                    [allSeatArray addObject:allSeat];
                }
            }
        }
            break;
        case 101: { //拥有座驾
            NSLog(@"shijian == %@",request.responseString);
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
        case 102:   //启用座驾
        case 103:   //禁用座驾
        case 105: { //删除座驾
            if ([result isKindOfClass:[NSDictionary class]]) {
                NSString *code = [result objectForKey:@"code"];
                if (code.intValue == 1) {
                    [self requestWithParams:[NSString stringWithFormat:@"user/car_info/%@",model.access_token] tag:101];
                }
            }
        }
            break;
        case 104: { //购买座驾
            if ([result isKindOfClass:[NSDictionary class]]) {
                NSString *code = [result objectForKey:@"code"];
                if (code.intValue == 1) {
                    [self requestWithParams:[NSString stringWithFormat:@"user/car_info/%@",model.access_token] tag:101];
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"道具购买成功" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [alertView show];
                } else if (code.intValue == 30412) {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"购买失败" message:@"您的金币不足" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"充值", nil];
                    alertView.tag = 1001;
                    [alertView show];
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
