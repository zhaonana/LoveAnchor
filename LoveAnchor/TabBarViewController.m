//
//  TabBarViewController.m
//  LoveAnchor
//
//  Created by zhongqinglongtu on 14-8-11.
//  Copyright (c) 2014年 zhongqinglongtu. All rights reserved.
//

#import "TabBarViewController.h"

@interface TabBarViewController ()

@end

@implementation TabBarViewController

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
    [self showUI];
}
- (void)showUI {
    NSArray *titleArray = @[@"直播大厅",@"历史观看",@"排行榜",@"搜索"];
    NSArray *imageArray = @[@"zhibodatingxuanzhong",@"lishiguankanxuanzhong",@"paihangbangxuanzhong",@"sousuoxuanzhong"];
    NSArray *UnImageArray = @[@"zhibodatingweixuanzhong",@"lishiguankanweixuanzhong",@"paihangbangweixuanzhong",@"sousuoweixuanzhong",];
    
    HomePageViewController *homeVC = [[HomePageViewController alloc]init];
    UINavigationController *homeNC = [[UINavigationController alloc]initWithRootViewController:homeVC];
    
    DynamicViewController *dynamicVC = [[DynamicViewController alloc]init];
    UINavigationController *dynamicNC = [[UINavigationController alloc]initWithRootViewController:dynamicVC];
    
    RankingListViewController *rankingVC = [[RankingListViewController alloc]init];
    UINavigationController *rankingNC = [[UINavigationController alloc]initWithRootViewController:rankingVC];
    
    SearchViewController *searchVC = [[SearchViewController alloc]init];
    UINavigationController *searchNC = [[UINavigationController alloc]initWithRootViewController:searchVC];
    
    NSArray *ncArray = [[NSArray alloc]initWithObjects:homeNC,dynamicNC,rankingNC,searchNC, nil];
    
    self.viewControllers = ncArray;
    
    NSArray *itemArray = self.tabBar.items;
    
    for (int i = 0; i < 4; i++) {
        UITabBarItem *items = [itemArray objectAtIndex:i];
        [items setFinishedSelectedImage:[UIImage imageNamed:[imageArray objectAtIndex:i]] withFinishedUnselectedImage:[UIImage imageNamed:[UnImageArray objectAtIndex:i]]];
        [items setTitle:[titleArray objectAtIndex:i]];
    }
    [[UITabBarItem appearance] setTitleTextAttributes:@{UITextAttributeTextColor:textFontColor} forState:UIControlStateNormal];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
