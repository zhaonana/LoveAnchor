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
    LoginModel *model;
    NSMutableArray *allSeatImageArray;
    NSMutableArray *allSeatIDArray;
    NSMutableArray *carArray;
    int curr;
    int newTag;
}

@end

@implementation SeatManageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSData *myEncodedObject = [[NSUserDefaults standardUserDefaults] objectForKey:@"books"];
    model = [NSKeyedUnarchiver unarchiveObjectWithData: myEncodedObject];
    
    [self allRequest];
    [self request];
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
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:tableView];
}
- (void)buttonClick:(UIButton *)button
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - tableViewDelegate
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"SeatManageTableViewCell";
    SeatManageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[SeatManageTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return carArray.count;
}
#pragma mark - 数据解析
//全部座驾
- (void)allRequest
{
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:@"http://ttapi.izhubo.com/show/cars_list"]];
    request.delegate = self;
    request.tag = 100;
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
    if (request.tag == 100) {
        NSLog(@"所有 = %@",request.responseString);
        id result = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        if ([result isKindOfClass:[NSDictionary class]]) {
            allSeatImageArray = [NSMutableArray array];
            allSeatIDArray = [NSMutableArray array];
            NSArray *allSeatArray = [result objectForKey:@"data"];
            NSLog(@"所有 == %@",allSeatArray);
            for (NSDictionary *dict in allSeatArray) {
                [allSeatImageArray addObject:[dict objectForKey:@"pic_url"]];
                [allSeatIDArray addObject:[dict objectForKey:@"_id"]];
            }
            NSLog(@"所有图片 == %@",allSeatImageArray);
            NSLog(@"所有ID == %@",allSeatIDArray);
        }
    } else if (request.tag == 101){
        NSLog(@"zuojia == %@",request.responseString);
        id result = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        if ([result isKindOfClass:[NSDictionary class]]) {
            NSDictionary *seatDict = [result objectForKey:@"data"];
            NSLog(@"data= %@",seatDict);
            NSDictionary *dic = [seatDict objectForKey:@"car"];
            carArray = [NSMutableArray arrayWithArray:dic.allKeys];
            [carArray removeObject:@"curr"];
            curr = [[dic objectForKey:@"curr"] intValue];
            NSLog(@"car= %@",carArray);
            NSLog(@"car= %ld",carArray.count);
            [self showUI];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
