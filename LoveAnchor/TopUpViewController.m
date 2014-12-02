//
//  TopUpViewController.m
//  LoveAnchor
//
//  Created by zhongqinglongtu on 14-8-27.
//  Copyright (c) 2014年 zhongqinglongtu. All rights reserved.
//

#import "TopUpViewController.h"

@interface TopUpViewController ()
{
    CGSize  actualsize;
    NSArray *_imageArray;
}
@end

@implementation TopUpViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _imageArray = [[NSArray alloc] initWithObjects:@"400",@"800",@"2000",@"4600",@"8600",@"22000",@"43400", nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:232/255.0 green:241/255.0 blue:243/255.0 alpha:1];

    UILabel *topTitle = [[UILabel alloc]initWithFrame:CGRectMake(140, 0, 40, 44)];
    topTitle.text = @"充值";
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
    
//    self.view.backgroundColor = [UIColor colorWithRed:230/255.0 green:233/255.0 blue:232/255.0 alpha:0.8];
    UILabel *topLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 74, 75, 18)];
    topLabel.text = @"充值账户:";
    topLabel.textColor = [UIColor colorWithRed:81/255.0 green:87/255.0 blue:94/255.0 alpha:0.8];
    topLabel.font = [UIFont systemFontOfSize:17.0f];
    topLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:topLabel];
    
    UILabel *nickLabel = [[UILabel alloc]initWithFrame:CGRectMake(85, 74, 100, 18)];
    nickLabel.text = @"dagehaodiao";
    nickLabel.textColor = [UIColor colorWithRed:81/255.0 green:87/255.0 blue:94/255.0 alpha:0.8];
    nickLabel.font = [UIFont systemFontOfSize:17.0f];
    nickLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:nickLabel];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64+38, kScreenWidth, 44)];
    imageView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:imageView];
    
    UIImageView *headImageView = [[UIImageView alloc]initWithFrame:CGRectMake(12, 8, 28, 28)];
    headImageView.image = [UIImage imageNamed:@"jinbi"];
    headImageView.backgroundColor = [UIColor clearColor];
    [imageView addSubview:headImageView];
    
    UILabel *yueLabel = [[UILabel alloc]initWithFrame:CGRectMake(44, 12, 35, 18)];
    yueLabel.text = @"余额";
    yueLabel.font = [UIFont systemFontOfSize:17.0f];
    [imageView addSubview:yueLabel];
    
    UILabel *Label1 = [[UILabel alloc]initWithFrame:CGRectMake(200, 10, 100, 15)];
    Label1.text = [NSString stringWithFormat:@"%d 金币",0];
    Label1.textColor = [UIColor colorWithRed:228/255.0 green:105/255.0 blue:80/255.0 alpha:0.8];
    Label1.font = [UIFont systemFontOfSize:15.0f];
    Label1.textAlignment = NSTextAlignmentRight;
    [imageView addSubview:Label1];
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 173, kScreenWidth, kScreenHeight-174)];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:tableView];
}

#pragma mark - tableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor whiteColor];
    
    UIImageView *headImageVIew = [[UIImageView alloc]initWithFrame:CGRectMake(5, 0, 50, 50)];
    headImageVIew.image = [UIImage imageNamed:[_imageArray objectAtIndex:indexPath.row]];
    [cell addSubview:headImageVIew];
    
    UILabel *diLabel = [[UILabel alloc]initWithFrame:CGRectMake(64, 33, 110, 15)];
    diLabel.text = @"花费人民币6元";
    diLabel.font= [UIFont systemFontOfSize:12.0f];
    [cell addSubview:diLabel];
    
    UILabel *titleLabel = [[UILabel alloc]init];
    NSString *str;
    if (indexPath.row == 0) {
        str = @"兑换 400 个";
    }
    if (indexPath.row == 1) {
        str = @"兑换 800 个";
        diLabel.text = @"花费人民币12元";
    } else if (indexPath.row == 2) {
        str = @"兑换 2,000 个";
        diLabel.text = @"花费人民币30元";
    }else if (indexPath.row == 3) {
        str = @"兑换 4,600 个";
        diLabel.text = @"花费人民币68元";
    }else if (indexPath.row == 4) {
        str = @"兑换 8,600 个";
        diLabel.text = @"花费人民币128元";
    }else if (indexPath.row == 5) {
        str = @"兑换 22,000 个";
        diLabel.text = @"花费人民币328元";
    }else if(indexPath.row == 6) {
        str = @"兑换 43,400 个";
        diLabel.text = @"花费人民币648元";
    }
    
    UIFont * tfont = [UIFont systemFontOfSize:17.0f];
    CGSize size =CGSizeMake(300,60);
    NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:tfont,NSFontAttributeName,nil];
    actualsize =[str boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin  attributes:tdic context:nil].size;
    titleLabel.text = str;
    titleLabel.font = tfont;
    titleLabel.frame = CGRectMake(64, 10, actualsize.width, actualsize.height);
    [cell addSubview:titleLabel];
    
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(64+actualsize.width+5, 8, 23, 23)];
    imageView.image = [UIImage imageNamed:@"jinbi"];
    [cell addSubview:imageView];
    
    UIButton *dButton = [UIButton buttonWithType:UIButtonTypeCustom];
    dButton.frame = CGRectMake(240, 10, 60, 30);
    [dButton setTitle:@"兑换" forState:UIControlStateNormal];
    dButton.layer.borderColor = [UIColor colorWithRed:228/255.0 green:105/255.0 blue:80/255.0 alpha:0.6].CGColor;
    dButton.layer.borderWidth = 1.0;
    dButton.layer.cornerRadius = 5.0;
    dButton.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    [dButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [dButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell addSubview:dButton];
    
    return cell;
}

- (void)buttonClick:(UIButton *)button
{
    NSLog(@"11");
    if (button.tag == 100) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 7;
    }else {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return 37;
    }
    return 0;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor colorWithRed:232/255.0 green:241/255.0 blue:243/255.0 alpha:1];

    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, 300, 15)];
    label.text = @"如果您遇到问题,请联系官方客服QQ:2055320190";
    label.font = [UIFont systemFontOfSize:12.0f];
    [view addSubview:label];
    return view;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
