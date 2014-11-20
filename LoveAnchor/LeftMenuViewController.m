//
//  LeftMenuViewController.m
//  LoveAnchor
//
//  Created by zhongqinglongtu on 14-8-27.
//  Copyright (c) 2014年 zhongqinglongtu. All rights reserved.
//

#import "LeftMenuViewController.h"
#import "PersonageViewController.h"
#import "TopUpViewController.h"
#import "SetViewController.h"
#import "LoginViewController.h"
#import "StoreViewController.h"


@interface LeftMenuViewController ()

@end

@implementation LeftMenuViewController

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
    
    UITableView *leftTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 200, self.view.frame.size.width-70, 132) style:UITableViewStylePlain];
    leftTableView.backgroundColor = [UIColor clearColor];
    leftTableView.scrollEnabled = NO;
    leftTableView.delegate = self;
    leftTableView.dataSource = self;
    leftTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:leftTableView];
    
    UIButton *headButton = [UIButton buttonWithType:UIButtonTypeCustom];
    headButton.frame = CGRectMake(92, 45, 70, 70);
    headButton.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"touxiang"]];
    [headButton addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:headButton];
    
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(90, 122, 80, 16)];
    nameLabel.text = @"钢铁侠13号";
    nameLabel.font = [UIFont systemFontOfSize:15.0f];
    nameLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:nameLabel];
    
    UILabel *balanceLabel = [[UILabel alloc]initWithFrame:CGRectMake(90, 144, 38, 16)];
    balanceLabel.text = @"余额:";
    balanceLabel.font = [UIFont systemFontOfSize:15.0f];
    balanceLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:balanceLabel];
    
    UILabel *numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(135, 144, 44, 16)];
    numberLabel.text = @"88888";
    numberLabel.font = [UIFont systemFontOfSize:15.0f];
    numberLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:numberLabel];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(25, 350, 190, 18)];
    label.text = @"当前在线玩家共有";
    label.font = [UIFont systemFontOfSize:15.0f];
    label.textColor = [UIColor whiteColor];
    [self.view addSubview:label];
    
    UILabel *label1 = [[UILabel alloc]init];
    NSString *s = @"12234";
    label1.text = s;
    label1.textColor = textFontColor;
    UIFont *font = [UIFont systemFontOfSize:15.0f];
    label1.font = font;
    CGSize size =CGSizeMake(300,60);
    NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName,nil];
        CGSize actualsize =[s boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin  attributes:tdic context:nil].size;
        label1.frame = CGRectMake(145, 350, actualsize.width, 18);
    [self.view addSubview:label1];
    
        UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(145+actualsize.width, 350, 190, 18)];
        label2.text = @"位";
        label2.font = [UIFont systemFontOfSize:15.0f];
        label2.textColor = [UIColor whiteColor];
        [self.view addSubview:label2];
    
    UILabel *label11 = [[UILabel alloc]initWithFrame:CGRectMake(10, kScreenHeight - 20, 28, 13)];
    label11.text = @"V1.0";
    label11.font = [UIFont systemFontOfSize:12.0f];
    label11.textColor = [UIColor whiteColor];
    [self.view addSubview:label11];

}

- (void)buttonClick
{
    NSLog(@"111");
    LoginViewController *login = [[LoginViewController alloc]init];
    [login setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    UINavigationController *nc = [[UINavigationController alloc]initWithRootViewController:login];
    [self presentViewController:nc animated:YES completion:nil];
//    PersonageViewController *per = [[PersonageViewController alloc]init];
//    UINavigationController *nc = [[UINavigationController alloc]initWithRootViewController:per];
//    [self presentViewController:nc animated:YES completion:nil];
}

#pragma mark - tableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == 1) {
        UIImageView *imgeviewIcont = [[UIImageView alloc]initWithFrame:CGRectMake(10, 8, 30, 30)];
        imgeviewIcont.image = [UIImage imageNamed:@"chongzhi"];
        [cell addSubview:imgeviewIcont];
        
        UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(56, 14, 33, 17)];
        textLabel.text = @"充值";
        textLabel.font = [UIFont systemFontOfSize:15.0f];
        textLabel.textColor = [UIColor whiteColor];
        [cell addSubview:textLabel];
    } else if (indexPath.row == 2){
        UIImageView *imgeviewIcont1 = [[UIImageView alloc]initWithFrame:CGRectMake(10, 8, 30, 30)];
        imgeviewIcont1.image = [UIImage imageNamed:@"shezhi"];
        [cell addSubview:imgeviewIcont1];
        
        UILabel *textLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(56, 14, 33, 17)];
        textLabel1.text = @"设置";
        textLabel1.font = [UIFont systemFontOfSize:15.0f];
        textLabel1.textColor = [UIColor whiteColor];
        [cell addSubview:textLabel1];
    }else {
        UIImageView *storeView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 8, 30, 30)];
        storeView.image = [UIImage imageNamed:@"shangchengbag"];
        [cell addSubview:storeView];
        
        UILabel *storeLabel = [[UILabel alloc]initWithFrame:CGRectMake(56, 14, 33, 17)];
        storeLabel.text = @"商城";
        storeLabel.font = [UIFont systemFontOfSize:15.0f];
        storeLabel.textColor = [UIColor whiteColor];
        [cell addSubview:storeLabel];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1) {
        TopUpViewController *topUp = [[TopUpViewController alloc] init];
        [topUp setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
        UINavigationController *nc = [[UINavigationController alloc]initWithRootViewController:topUp];
        [self presentViewController:nc animated:NO completion:nil];
        
    } else if (indexPath.row == 2){
        NSLog(@"11");
        SetViewController *set = [[SetViewController alloc]init];
        [set setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
        UINavigationController *nc = [[UINavigationController alloc]initWithRootViewController:set];
        [self presentViewController:nc animated:NO completion:nil];
    }else {
        StoreViewController *store = [[StoreViewController alloc]init];
        [store setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
        UINavigationController *nc = [[UINavigationController alloc]initWithRootViewController:store];
        [self presentViewController:nc animated:YES completion:nil];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

@end
