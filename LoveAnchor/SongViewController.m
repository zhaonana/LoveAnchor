//
//  SongViewController.m
//  LoveAnchor
//
//  Created by zhongqinglongtu on 14-12-23.
//  Copyright (c) 2014年 zhongqinglongtu. All rights reserved.
//

#import "SongViewController.h"

@interface SongViewController ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UIButton        *_leftButton;
    UIButton        *_rightButton;
    UIView          *_lineVIew;
    UIScrollView    *_rootScrollView;
}

@property (nonatomic,strong)UIView *leftView;
@property (nonatomic,strong)UIView *rightView;

@end

@implementation SongViewController

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
    self.view.backgroundColor = [UIColor whiteColor];
    [self showUI];
}

- (void)showUI
{
    UIButton *returnButton = [UIButton buttonWithType:UIButtonTypeCustom];
    returnButton.frame = CGRectMake(10, 0, 50, 44);
    returnButton.tag = 100;
    [returnButton setTitle:@"返回" forState:UIControlStateNormal];
    [returnButton setTitleColor:textFontColor forState:UIControlStateNormal];
    returnButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [returnButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar addSubview:returnButton];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(140, 0, 40, 44)];
    titleLabel.text = @"点歌";
    titleLabel.textColor = textFontColor;
    titleLabel.font = [UIFont systemFontOfSize:18];
    [self.navigationController.navigationBar addSubview:titleLabel];
    
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, 38)];
    topView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:topView];
    
    _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _leftButton.frame = CGRectMake(0, 0, kScreenWidth/2, 37);
    [_leftButton setTitle:@"主播预设歌单" forState:UIControlStateNormal];
    [_leftButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_leftButton setTitleColor:textFontColor forState:UIControlStateSelected];
    [_leftButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    _leftButton.selected = YES;
    _leftButton.tag = 0;
    [topView addSubview:_leftButton];
    
    _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightButton.frame = CGRectMake(kScreenWidth/2, 0, kScreenWidth/2, 37);
    [_rightButton setTitle:@"用户名注册" forState:UIControlStateNormal];
    [_rightButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_rightButton setTitleColor:textFontColor forState:UIControlStateSelected];
    [_rightButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    _rightButton.tag = 1;
    [topView addSubview:_rightButton];
    
    UIView *longView = [[UIView alloc]initWithFrame:CGRectMake(0, 37, kScreenWidth, 1)];
    longView.backgroundColor = [UIColor grayColor];
    [topView addSubview:longView];
    
    _lineVIew = [[UIView alloc]initWithFrame:CGRectMake(0, 37, kScreenWidth/2, 1)];
    _lineVIew.backgroundColor = textFontColor;
    [topView addSubview:_lineVIew];
    
    _rootScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 102, kScreenWidth, kScreenHeight)];
    _rootScrollView.contentSize = CGSizeMake(kScreenWidth *2, 0);
    _rootScrollView.showsHorizontalScrollIndicator = NO;
    _rootScrollView.showsVerticalScrollIndicator = NO;
    _rootScrollView.pagingEnabled = YES;
    _rootScrollView.delegate = self;
    [self.view addSubview:_rootScrollView];
    
    self.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    self.leftView.backgroundColor = [UIColor whiteColor];
    [_rootScrollView addSubview:self.leftView];
    [self createLeftView];
    
    self.rightView = [[UIView alloc]initWithFrame:CGRectMake(kScreenWidth, 0, kScreenWidth, kScreenHeight)];
    self.rightView.backgroundColor = [UIColor colorWithRed:232/255.0 green:241/255.0 blue:243/255.0 alpha:1];
    [_rootScrollView addSubview:self.rightView];
//    [self createRightView];

}
- (void)createLeftView
{
    UITableView *leftTabelView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, self.leftView.frame.size.height-55) style:UITableViewStylePlain];
    leftTabelView.delegate = self;
    leftTabelView.dataSource = self;
    leftTabelView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    leftTabelView.backgroundColor = [UIColor clearColor];
    [self.leftView addSubview:leftTabelView];
    
    UIView *TSView = [[UIView alloc]initWithFrame:CGRectMake(0, self.leftView.frame.size.height-55, kScreenWidth, 55)];
    TSView.backgroundColor = [UIColor colorWithRed:232/255.0 green:241/255.0 blue:243/255.0 alpha:1];
    [self.view addSubview:TSView];
    
    UIImageView *HXImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 20, kScreenWidth, 0.3)];
    HXImageView.backgroundColor = [UIColor whiteColor];
    [TSView addSubview:HXImageView];
    
    UIImageView *SXImageView = [[UIImageView alloc]initWithFrame:CGRectMake(260, 2, 0.3, 16)];
    SXImageView.backgroundColor = [UIColor whiteColor];
    [TSView addSubview:SXImageView];
    
    UILabel *JBLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 180, 20)];
    JBLabel.text = [NSString stringWithFormat:@"金币余额：0"];
    JBLabel.textColor = [UIColor grayColor];
    JBLabel.font=[UIFont systemFontOfSize:12];
    [TSView addSubview:JBLabel];
    
    UIButton *CZButton = [[UIButton alloc]initWithFrame:CGRectMake(225, 0, 30, 20)];
    [CZButton setTitle:@"充值" forState:UIControlStateNormal];
    [CZButton setTitleColor:textFontColor forState:UIControlStateNormal];
    CZButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [CZButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [TSView addSubview:CZButton];
    
    UIButton *ZXButton = [[UIButton alloc]initWithFrame:CGRectMake(261, 0, 60, 20)];
    [ZXButton setTitle:@"自选歌曲" forState:UIControlStateNormal];
    [ZXButton setTitleColor:textFontColor forState:UIControlStateNormal];
    ZXButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [ZXButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [TSView addSubview:ZXButton];
    
    UILabel *SMLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 20, kScreenWidth, 35)];
    SMLabel.text = @"自选歌曲点唱说明:价格1000金币,若主播没有接受您的点歌请求,消耗金币会自动退还到您的账户";
    SMLabel.textColor = [UIColor lightGrayColor];
    SMLabel.font = [UIFont systemFontOfSize:12];
    SMLabel.lineBreakMode = UILineBreakModeCharacterWrap;
    SMLabel.numberOfLines = 0;
    [TSView addSubview:SMLabel];
}
- (void)buttonClick:(UIButton *)button
{
    if (button.tag == 100) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        if (button.selected) {
            return;
        }
        _leftButton.selected = NO;
        _rightButton.selected = NO;
        button.selected = YES;
        [UIView animateWithDuration:0 animations:^{
            _rootScrollView.contentOffset = CGPointMake(kScreenWidth*button.tag, 0);
            [self changed];
            
        }];

    }
}
- (void)changed
{
    CGRect rect = _lineVIew.frame;
    rect.origin.x = _rootScrollView.contentOffset.x/2;
    _lineVIew.frame = rect;
    _leftButton.selected = NO;
    _rightButton.selected = NO;
    if (_rootScrollView.contentOffset.x == 0) {
        _leftButton.selected = YES;
    } else {
        _rightButton.selected = YES;
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [UIView animateWithDuration:0 animations:^{
        [self changed];
    }];
}
#pragma mark - tabelVIew
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
