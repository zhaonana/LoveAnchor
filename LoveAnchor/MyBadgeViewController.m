//
//  MyBadgeViewController.m
//  LoveAnchor
//
//  Created by zhongqinglongtu on 15-1-4.
//  Copyright (c) 2015年 zhongqinglongtu. All rights reserved.
//

#import "MyBadgeViewController.h"

@interface MyBadgeViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation MyBadgeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
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
    
    UITableView *badgeTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64) style:UITableViewStyleGrouped];
    badgeTableView.delegate = self;
    badgeTableView.dataSource = self;
    badgeTableView.backgroundColor = [UIColor clearColor];
    badgeTableView.backgroundView = [[UIView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:badgeTableView];
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
        cell = [[[NSBundle mainBundle]loadNibNamed:@"MyBadgeTableViewCell" owner:nil options:nil] lastObject];
    }
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
