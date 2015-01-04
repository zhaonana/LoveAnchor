//
//  SetViewController.m
//  LoveAnchor
//
//  Created by zhongqinglongtu on 14-8-27.
//  Copyright (c) 2014年 zhongqinglongtu. All rights reserved.
//

#import "SetViewController.h"

@interface SetViewController ()<ASIHTTPRequestDelegate>
{
    UITableView         *_tableView;
    NSArray             *_two1Array;
    NSArray             *_two2Array;
    NSArray             *_oneArray;
    UISwitch            *_KGSwitch;
    LoginModel          *model;
}

@end

@implementation SetViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _two1Array = [[NSArray alloc]initWithObjects:@"开播提醒",@"广播跑道",@"礼物跑道",@"进场信息", nil];
        _two2Array = [[NSArray alloc]initWithObjects:@"开启后你关注的主播开播会第一时间通知你",@"开启或关闭直播间公聊顶部的广播跑道",@"开启或关闭直播间公聊顶部的礼物跑道",@"开启或关闭公聊窗进场信息提示", nil];
        _oneArray = [[NSArray alloc] initWithObjects:@"功能设置",@"至尊VIP隐身",@"其他功能",@"关于",@"爱主播",@"退出",@"退出登录",@"个人账号",@"修改密码", nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    model = [CommonUtil getUserModel];
    
    UILabel *topTitle = [[UILabel alloc]initWithFrame:CGRectMake(140, 0, 40, 44)];
    topTitle.text = @"设置";
    topTitle.font = [UIFont systemFontOfSize:18];
    topTitle.textColor = textFontColor;
    [self.navigationController.navigationBar addSubview:topTitle];
    
    UIButton *returnButton = [UIButton buttonWithType:UIButtonTypeCustom];
    returnButton.frame = CGRectMake(0, 0, 65, 44);
    returnButton.tag = 100;
    [returnButton setTitle:@"返回" forState:UIControlStateNormal];
    [returnButton setTitleColor:textFontColor forState:UIControlStateNormal];
    returnButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [returnButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar addSubview:returnButton];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    _tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_tableView];
}

- (void)buttonClick:(UIButton *)button
{
    if (button.tag == 100) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - tableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
     TwoTableViewCell *twoCell = [tableView dequeueReusableCellWithIdentifier:@"twoCell"];
    if (indexPath.row == 4 || indexPath.row == 5 || indexPath.row == 6 || indexPath.row == 7) {
       
        if (twoCell == nil) {
            twoCell = [[TwoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"twoCell"];
        }
        LoginModel *userModel = [CommonUtil getUserModel];
        switch (indexPath.row) {
            case 4:
                twoCell.label1.text = [_two1Array objectAtIndex:0];
                twoCell.label2.text = [_two2Array objectAtIndex:0];
                
                break;
            case 5:
                twoCell.label1.text = [_two1Array objectAtIndex:1];
                twoCell.label2.text = [_two2Array objectAtIndex:1];
                
                break;
            case 6:
                twoCell.label1.text = [_two1Array objectAtIndex:2];
                twoCell.label2.text = [_two2Array objectAtIndex:2];
                
                break;
            case 7: {
                twoCell.label1.text =  [_two1Array objectAtIndex:3];
                twoCell.label2.text = [_two2Array objectAtIndex:3];
                if (userModel) {
                    if (userModel.admission) {
                        twoCell.KGSwitth.on = YES;
                    } else {
                        twoCell.KGSwitth.on = NO;
                    }
                } else {
                    twoCell.KGSwitth.on = YES;
                }
                twoCell.switchClick = ^(BOOL isOn) {
                    if (isOn) {
                        userModel.admission = YES;
                    } else {
                        userModel.admission = NO;
                    }
                    [CommonUtil saveUserModel:userModel];
                };
            }
                break;
                
            default:
                break;
        }
        twoCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return twoCell;
    } else {
        OneTableViewCell *oneCell = [tableView dequeueReusableCellWithIdentifier:@"oneCell"];
        if (oneCell == nil) {
            oneCell = [[OneTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"oneCell"];
        }
        switch (indexPath.row) {
            case 0:{
                oneCell.label3.text = [_oneArray objectAtIndex:7];
            }
                break;
            case 1:{
                oneCell.label3.text = [_oneArray objectAtIndex:8];
                oneCell.label3.font = [UIFont systemFontOfSize:12];
                oneCell.label3.textColor = [UIColor blackColor];
            }
                break;
            case 2:{
                oneCell.label3.text = [_oneArray objectAtIndex:0];
                oneCell.selectionStyle = UITableViewCellSelectionStyleNone;
                oneCell.label3.font = [UIFont systemFontOfSize:10];
                oneCell.label3.textColor = [UIColor lightGrayColor];
                oneCell.image3.frame = CGRectMake(15, 39, kScreenWidth-30, 0.7);
                oneCell.image3.backgroundColor = [UIColor grayColor];
                }
                break;
            case 3:
                oneCell.label3.text = [_oneArray objectAtIndex:1];
                oneCell.label3.textColor = [UIColor blackColor];
                oneCell.label3.font = [UIFont systemFontOfSize:12];
                oneCell.KGSwitch.hidden = NO;
                break;
            case 8:
                oneCell.label3.text = [_oneArray objectAtIndex:2];
                oneCell.selectionStyle = UITableViewCellSelectionStyleNone;
                oneCell.image3.frame = CGRectMake(15, 39, kScreenWidth-30, 0.7);
                oneCell.image3.backgroundColor = [UIColor grayColor];
                break;
            case 9:
                oneCell.label3.text = [_oneArray objectAtIndex:3];
                oneCell.selectionStyle = UITableViewCellSelectionStyleNone;
                oneCell.image3.frame = CGRectMake(15, 39, kScreenWidth-30, 0.7);
                oneCell.image3.backgroundColor = [UIColor grayColor];
                break;
            case 10:
                oneCell.label3.text = [_oneArray objectAtIndex:4];
                oneCell.label3.textColor = [UIColor blackColor];
                oneCell.label3.font = [UIFont systemFontOfSize:12];
                break;
            case 11:
                oneCell.label3.text = [_oneArray objectAtIndex:5];
                oneCell.selectionStyle = UITableViewCellSelectionStyleNone;
                oneCell.image3.frame = CGRectMake(15, 39, kScreenWidth-30, 0.7);
                oneCell.image3.backgroundColor = [UIColor grayColor];
                break;
            case 12:
                oneCell.label3.text = [_oneArray objectAtIndex:6];
                oneCell.label3.textColor = [UIColor blackColor];
                oneCell.label3.font = [UIFont systemFontOfSize:12];
                break;
                
            default:
                break;
        }
        oneCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return oneCell;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (model.access_token == nil) {
        return 9;
    } else {
        return 13;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 4 || indexPath.row == 5 || indexPath.row == 6 || indexPath.row == 7) {
        return 60;
    } else {
        return 40;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1) {
        ModifyPassWordViewController *pass = [[ModifyPassWordViewController alloc]init];
        UINavigationController *nc = [[UINavigationController alloc]initWithRootViewController:pass];
        [self presentViewController:nc animated:YES completion:nil];
    } else if (indexPath.row == 10) {
        LoveViewController *love = [[LoveViewController alloc] init];
        UINavigationController *nv = [[UINavigationController alloc]initWithRootViewController:love];
        [self presentViewController:nv animated:YES completion:nil];
    } else if (indexPath.row == 12) {
        [self request];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
#pragma mark - 解析
- (void)request
{
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@user/logout/%@",BaseURL,model.access_token]]];
    NSLog(@"result == %@",model.access_token);
    request.delegate = self;
    [request setTimeOutSeconds:100];
    [request startAsynchronous];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    id result = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
    if ([result isKindOfClass:[NSDictionary class]]) {
        NSLog(@"result == %@",[result objectForKey:@"code"]);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
