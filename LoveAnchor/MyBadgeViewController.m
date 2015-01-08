//
//  MyBadgeViewController.m
//  LoveAnchor
//
//  Created by zhongqinglongtu on 15-1-5.
//  Copyright (c) 2015年 zhongqinglongtu. All rights reserved.
//

#import "MyBadgeViewController.h"

@interface MyBadgeViewController ()<UITableViewDataSource,UITableViewDelegate,ASIHTTPRequestDelegate>
{
    NSMutableArray *imageArray;
    NSMutableArray *titleArray;
    NSMutableArray *timeArray;
    NSMutableArray *introduceArray;
    NSMutableArray *moneyArray;
    NSMutableArray *zongArray;
    
    UITableView    *_tableView;
}

@end

@implementation MyBadgeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        imageArray      = [NSMutableArray array];
        titleArray      = [NSMutableArray array];
        timeArray       = [NSMutableArray array];
        introduceArray  = [NSMutableArray array];
        moneyArray      = [NSMutableArray array];
        zongArray       = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self request];
    UIButton *titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    titleButton.frame = CGRectMake(0, 0, 50, 44);
    titleButton.tag = 100;
    [titleButton setTitle:@"返回" forState:UIControlStateNormal];
    titleButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [titleButton setTitleColor:textFontColor forState:UIControlStateNormal];
    [titleButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar addSubview:titleButton];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(123, 0, 75, 44)];
    label.text = @"我的徽章";
    label.font = [UIFont systemFontOfSize:18];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = textFontColor;
    [self.navigationController.navigationBar addSubview:label];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:_tableView];
    
}
- (void)buttonClick:(UIButton *)button
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"MyBadgeTableViewCell";
    MyBadgeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[MyBadgeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell.badgeImageView setImageWithURL:[NSURL URLWithString:[imageArray objectAtIndex:indexPath.row]]];
    cell.titleLabel.text = [titleArray objectAtIndex:indexPath.row];
    cell.timeLabel.text = [NSString stringWithFormat:@"（点亮后有效期：%@天）",[timeArray objectAtIndex:indexPath.row]];
    cell.introduceLabel.text = [NSString stringWithFormat:@"%@",[introduceArray objectAtIndex:indexPath.row]];
    cell.moneyLabel.text = [NSString stringWithFormat:@"金豆：%@/%@",[moneyArray objectAtIndex:indexPath.row],[zongArray objectAtIndex:indexPath.row]];
    
    if (indexPath.row == 0 || indexPath.row == 1) {
        [cell.badgeImageView setFrame:CGRectMake(10, 5, 35, 35)];
    } else if (indexPath.row == 2 || indexPath.row == 3 || indexPath.row == 6 || indexPath.row == 7 || indexPath.row == 38) {
        [cell.badgeImageView setFrame:CGRectMake(10, 12.5, 35, 35)];
    } else if (indexPath.row == 4 || indexPath.row == 5 || indexPath.row == 8 || indexPath.row == 9) {
        [cell.badgeImageView setFrame:CGRectMake(10, 17.5, 35, 35)];
        cell.introduceLabel.frame = CGRectMake(50, 25, 270, 30);
        cell.moneyLabel.frame = CGRectMake(50, 55, 100, 15);
    }
    if (indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 8 || indexPath.row == 9) {
        cell.moneyLabel.hidden = YES;
    }

    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return imageArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0 || indexPath.row == 1) {
        return 45;
    } else if (indexPath.row == 2 || indexPath.row == 3 || indexPath.row == 6 || indexPath.row == 7 || indexPath.row == 38) {
        return 60;
    } else {
        return 70;
    }
}
- (void)request
{
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@zone/user_medal/%@",BaseURL,self._id]]];
    NSLog(@"%@",self._id);
    NSLog(@"%@",BaseURL);
    request.delegate = self;
    [request setTimeOutSeconds:100];
    [request startAsynchronous];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    id result = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
    if ([result isKindOfClass:[NSDictionary class]]) {
        NSArray *array = [result objectForKey:@"data"];
        for (NSDictionary *dict in array) {
            [imageArray addObject:[dict objectForKey:@"grey_pic"]];
            [titleArray addObject:[dict objectForKey:@"name"]];
            [timeArray addObject:[dict objectForKey:@"expiry_days"]];
            [introduceArray addObject:[dict objectForKey:@"desc"]];
            [moneyArray addObject:[dict objectForKey:@"sum_cost"]];
            NSNumber *coins = [dict objectForKey:@"coins"];
            [zongArray addObject:coins ? coins : @""];
            
        }
        NSLog(@"234 == %@",zongArray);
        [_tableView reloadData];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
