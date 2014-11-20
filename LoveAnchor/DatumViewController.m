//
//  DatumViewController.m
//  LoveAnchor
//
//  Created by zhongqinglongtu on 14-10-18.
//  Copyright (c) 2014年 zhongqinglongtu. All rights reserved.
//

#import "DatumViewController.h"
#import "OneCell.h"
#import "TwoCell.h"

@interface DatumViewController ()
{
    NSArray *_titleArray;
    NSArray *_imageArray;
}

@end

@implementation DatumViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _titleArray = [[NSArray alloc]initWithObjects:@"徽章",@"地区",@"座驾",@"相册",@"直播地址", nil];
        _imageArray = [[NSArray alloc]initWithObjects:@"huizhang",@"huizhang",@"huizhang",@"huizhang",@"huizhang",@"huizhang",@"huizhang",@"huizhang",@"huizhang",@"huizhang", nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self shouUI];
}
#pragma mark - 界面
- (void)shouUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    UIImageView *headImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 20, kScreenWidth, 33)];
    headImageView.userInteractionEnabled = YES;
    headImageView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:headImageView];
    
    UIButton *returnButton = [UIButton buttonWithType:UIButtonTypeCustom];
    returnButton.frame = CGRectMake(0, 0, 20, 33);
    returnButton.tag = 100;
    [returnButton setImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [returnButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [headImageView addSubview:returnButton];
    
    UIButton *SCButton = [UIButton buttonWithType:UIButtonTypeCustom];
    SCButton.frame = CGRectMake(280, 10, 20, 15);
    SCButton.tag = 101;
    [SCButton setImage:[UIImage imageNamed:@"shoucang1"] forState:UIControlStateNormal];
    [SCButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [headImageView addSubview:SCButton];
    
    UILabel *titleLabel = [[UILabel alloc]init];
    NSString *str = @"花开时节又逢君求包养";;
    UIFont *font = [UIFont systemFontOfSize:15];
    CGSize size = CGSizeMake(300, 60);
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil];
    CGSize atusize = [str boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    titleLabel.text = str;
    titleLabel.textColor = textFontColor;
    titleLabel.font = font;
    titleLabel.frame = CGRectMake(20, 5, atusize.width, atusize.height);
    [headImageView addSubview:titleLabel];
    
    UIImageView *HGImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20+atusize.width+2, 8, 20, 15)];
    HGImageView.image = [UIImage imageNamed:@"shoucangdianji1"];
    [headImageView addSubview:HGImageView];
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 53, kScreenWidth, kScreenHeight)];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:tableView];
    
}

#pragma mark - 点击事件
- (void)buttonClick:(UIButton *)button
{
    if (button.tag == 100) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}

#pragma mark - uitableViewDelegate
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        OneCell *oneCell = [tableView dequeueReusableCellWithIdentifier:@"oneCell"];
        if (oneCell == nil) {
            oneCell = [[OneCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"oneCell"];
        }
        return oneCell;
    } else {
        TwoCell *twoCell = [tableView dequeueReusableCellWithIdentifier:@"twoCell"];
        if (twoCell == nil) {
            twoCell = [[TwoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"twoCell"];
        }
        twoCell.label1.text = [_titleArray objectAtIndex:indexPath.row-1];
        if (indexPath.row == 1) {
            for (int i = 0; i < 9; i++) {
                UIImageView *View = [[UIImageView alloc]initWithFrame:CGRectMake(75+i*21, 10, 15, 15)];
                View.image = [UIImage imageNamed:[_imageArray objectAtIndex:i]];
                [twoCell addSubview:View];
            }
        } else if (indexPath.row == 2) {
            twoCell.label2.text = @"河北石家庄";
        } else if (indexPath.row == 3) {
            twoCell.NImageView.image = [UIImage imageNamed:@"zuojia"];
        } else if (indexPath.row == 4) {
            twoCell.label2.text = @"河北石家庄";
        } else if (indexPath.row == 5) {
            twoCell.label2.text = @"WWW.hao123.com";
        }
        return twoCell;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 55;
    } else {
        return 35;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
