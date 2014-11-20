//
//  PlayViewController.m
//  LoveAnchor
//
//  Created by zhongqinglongtu on 14-9-18.
//  Copyright (c) 2014年 zhongqinglongtu. All rights reserved.
//

#import "PlayViewController.h"

@interface PlayViewController () {
    UIView *_navView;
}

@end

@implementation PlayViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSLog(@"self.allModel.nick_name:%@",self.allModel.nick_name);
    
    [self shouwUI];
}
#pragma mark - shouUI
- (void)shouwUI
{
    UIImageView *liveView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 20, kScreenWidth, 240)];
    liveView.backgroundColor = [UIColor purpleColor];
    [self.view addSubview:liveView];
    
    UIImageView *upgradeView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 40, 110, 32)];
    upgradeView.image = [UIImage imageNamed:@"shengji"];
    [liveView addSubview:upgradeView];
    
    UILabel *shengjiLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 8, 80, 16)];
    shengjiLabel.text = [NSString stringWithFormat:@"差%d经验升级",25541];
    shengjiLabel.font = [UIFont systemFontOfSize:10];
    [upgradeView addSubview:shengjiLabel];
    
    UIImageView *yumaoView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 73, 33, 32)];
    yumaoView.image = [UIImage imageNamed:@"yumao"];
    [liveView addSubview:yumaoView];
    
    UILabel *quantityLabel = [[UILabel alloc]initWithFrame:CGRectMake(13, 20, 18, 7)];
    quantityLabel.text = @"12222";
    quantityLabel.font = [UIFont systemFontOfSize:6];
    [yumaoView addSubview:quantityLabel];
    
    UIButton *reportButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [reportButton setImage:[UIImage imageNamed:@"jubao"] forState:UIControlStateNormal];
    [reportButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    reportButton.frame = CGRectMake(280, 200, 36, 36);
    [liveView addSubview:reportButton];
    
    //----------------------------------------------------------------------------/
    _navView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, kScreenWidth, 35)];
    _navView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.8];
    [self.view addSubview:_navView];
    
    UILabel *navLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 0, 200, 35)];
    navLabel.text = @"花开那时又逢君求包养";
    navLabel.text = [NSString stringWithFormat:@"%@",self.allModel.nick_name];
    navLabel.textColor = textFontColor;
    navLabel.font = [UIFont systemFontOfSize:15];
    navLabel.textAlignment = NSTextAlignmentLeft;
    [_navView addSubview:navLabel];
    
    UIImageView *gradeView = [[UIImageView alloc]initWithFrame:CGRectMake(190, 5, 25, 25)];
    gradeView.image = [UIImage imageNamed:@"sanxin"];
    [_navView addSubview:gradeView];
    
    UIButton *returnButton = [UIButton buttonWithType:UIButtonTypeCustom];
    returnButton.frame = CGRectMake(0, 0, 30, 35);
    returnButton.tag = 100;
    [returnButton setImage:[UIImage imageNamed:@"guanbi"] forState:UIControlStateNormal];
    [returnButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_navView addSubview:returnButton];
    
    UIButton *attentionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    attentionButton.frame = CGRectMake(275, 0, 20, 35);
    attentionButton.tag = 101;
    [attentionButton setImage:[UIImage imageNamed:@"shoucang"] forState:UIControlStateNormal];
    [attentionButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_navView addSubview:attentionButton];
    
    UIButton *classifyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    classifyButton.frame = CGRectMake(300, 0, 15, 35);
    classifyButton.tag = 102;
    [classifyButton setImage:[UIImage imageNamed:@"zhuboxiangqing"] forState:UIControlStateNormal];
    [classifyButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_navView addSubview:classifyButton];
    
    UIView *classifyView = [[UIView alloc]initWithFrame:CGRectMake(225, 36, 94, 110)];
    classifyView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.8];
    [liveView addSubview:classifyView];
    
    [self performSelector:@selector(hideTopView) withObject:nil afterDelay:3];
    
    //---------------------------------------------------------------------------
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 260, kScreenWidth, 28)];
    imageView.backgroundColor = [UIColor redColor];
    imageView.userInteractionEnabled = YES;
    [self.view addSubview:imageView];
    
    NSArray *titleArray = @[@"综合",@"公聊",@"私聊",@"观众榜"];
    for (int i = 0; i < 4; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0+i*62, 0, 62, 27);
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:[titleArray objectAtIndex:i] forState:UIControlStateNormal];
        [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        [imageView addSubview:button];
    }
    
    UILabel *numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(240, 0, 60, 27)];
    numberLabel.text = [NSString stringWithFormat:@"(%d)",11234];
    numberLabel.textColor = [UIColor whiteColor];
    [imageView addSubview:numberLabel];
    
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 285, kScreenWidth, 220) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:tableView];
    
    
    
}
#pragma mark - 点击事件
- (void)buttonClick:(UIButton *)button
{
    NSLog(@"1");
    if (button.tag == 100) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - tableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *idenifier = @"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idenifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idenifier];
    }
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (void)hideTopView {
    //滑动
//    [UIView animateWithDuration:1 animations:^{
//        CGRect rect = _navView.frame;
//        rect.origin.y = 0;
//        _navView.frame = rect;
//    } completion:^(BOOL finished) {
//        _navView.alpha = 0;
//    }];
    //淡入淡出
//    [UIView animateWithDuration:1 animations:^{
//        _navView.alpha = 0;
//    }];
}



@end
