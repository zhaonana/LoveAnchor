//
//  LeftMenuViewController.m
//  LoveAnchor
//
//  Created by zhongqinglongtu on 14-8-27.
//  Copyright (c) 2014年 zhongqinglongtu. All rights reserved.
//

#import "LeftMenuViewController.h"

@interface LeftMenuViewController () {
    UILabel *nameLabel;
}

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
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    imageView.userInteractionEnabled = YES;
    imageView.image = [UIImage imageNamed:@"zhuyebeijing"];
    [self.view addSubview:imageView];
    
    UITableView *leftTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 200, self.view.frame.size.width-70, 132) style:UITableViewStylePlain];
    leftTableView.backgroundColor = [UIColor clearColor];
    leftTableView.scrollEnabled = NO;
    leftTableView.delegate = self;
    leftTableView.dataSource = self;
    leftTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [imageView addSubview:leftTableView];
    
    UIButton *headButton = [UIButton buttonWithType:UIButtonTypeCustom];
    headButton.frame = CGRectMake(95, 45, 70, 70);
    headButton.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"touxiang"]];
    [headButton addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:headButton];
    
    nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 122, 220, 16)];
    [nameLabel setBackgroundColor:[UIColor redColor]];
    [nameLabel setTextAlignment:NSTextAlignmentCenter];
    nameLabel.font = [UIFont systemFontOfSize:15.0f];
    nameLabel.textColor = [UIColor whiteColor];
    [imageView addSubview:nameLabel];
    
    UILabel *numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 144, 220, 16)];
    [numberLabel setBackgroundColor:[UIColor redColor]];
    [numberLabel setTextAlignment:NSTextAlignmentCenter];
    numberLabel.text = [NSString stringWithFormat:@"余额:"];
    numberLabel.font = [UIFont systemFontOfSize:15.0f];
    numberLabel.textColor = [UIColor whiteColor];
    [imageView addSubview:numberLabel];
    
    UILabel *label11 = [[UILabel alloc]initWithFrame:CGRectMake(10, kScreenHeight - 20, 28, 13)];
    NSDictionary *dicInfo = [[NSBundle mainBundle] infoDictionary];    
    NSString *strAppBuild = [dicInfo objectForKey:@"CFBundleVersion"];
    label11.text = [NSString stringWithFormat:@"V%@",strAppBuild];
    label11.font = [UIFont systemFontOfSize:12.0f];
    label11.textColor = [UIColor whiteColor];
    [imageView addSubview:label11];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    LoginModel *model = [CommonUtil getUserModel];
    nameLabel.text = model.userName;
}

- (void)buttonClick
{
    if ([CommonUtil isLogin]) {
        PersonageViewController *per = [[PersonageViewController alloc]init];
        per.firstLogin = NO;
        UINavigationController *nc = [[UINavigationController alloc]initWithRootViewController:per];
        [self presentViewController:nc animated:YES completion:nil];
    } else {
        LoginViewController *login = [[LoginViewController alloc]init];
        [login setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
        UINavigationController *nc = [[UINavigationController alloc]initWithRootViewController:login];
        [self presentViewController:nc animated:YES completion:nil];
    }
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
