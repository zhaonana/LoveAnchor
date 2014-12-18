//
//  DatumViewController.m
//  LoveAnchor
//
//  Created by zhongqinglongtu on 14-10-18.
//  Copyright (c) 2014年 zhongqinglongtu. All rights reserved.
//

#import "DatumViewController.h"
#import "UserInfoModel.h"
#import "UIImageView+BoundsAdditions.h"

@interface DatumViewController () <ASIHTTPRequestDelegate>

@property (nonatomic, strong) UserInfoModel  *userModel;
@property (nonatomic, strong) UILabel        *titleLabel;
@property (nonatomic, strong) UIButton       *attentionButton;
@property (nonatomic, strong) NSMutableArray *attentionArray;
@property (nonatomic, strong) LoginModel     *model;
@property (nonatomic, strong) UITableView    *tableView;
@property (nonatomic, strong) NSMutableArray *badgeArray;
@property (nonatomic, strong) NSArray        *titleArray;
@property (nonatomic, strong) NSMutableArray *carArray;

@end


@implementation DatumViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _titleArray = [[NSArray alloc] initWithObjects:@"",@"徽章",@"地区",@"座驾",@"直播地址", nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _model = [CommonUtil getUserModel];
    _attentionArray = [[NSMutableArray alloc] init];
    _badgeArray = [[NSMutableArray alloc] init];
    _carArray = [[NSMutableArray alloc] init];
    
    [self shouUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self requestWithParam:@"user_info" tag:500];   //个人信息
    [self requestWithFollowing:@"following_list" tag:602];  //关注列表
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
    
    _attentionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _attentionButton.frame = CGRectMake(280, 10, 20, 15);
    _attentionButton.tag = 101;
    [_attentionButton setImage:[UIImage imageNamed:@"shoucang"] forState:UIControlStateNormal];
    [_attentionButton setImage:[UIImage imageNamed:@"shoucangdianji"] forState:UIControlStateSelected];
    [_attentionButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [headImageView addSubview:_attentionButton];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 250, 24)];
    UIFont *font = [UIFont systemFontOfSize:15];
    _titleLabel.textColor = textFontColor;
    _titleLabel.font = font;
    [headImageView addSubview:_titleLabel];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 53, kScreenWidth, kScreenHeight)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:_tableView];
}

#pragma mark - 点击事件
- (void)buttonClick:(UIButton *)button
{
    switch (button.tag) {
        case 100:
            [self dismissViewControllerAnimated:YES completion:nil];
            break;
        case 101:
            if (button.selected) {
                [self requestWithFollowing:@"del_following" tag:601];
            } else {
                [self requestWithFollowing:@"add_following" tag:600];
            }
            break;
        default:
            break;
    }
}

#pragma mark - uitableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0: {
            OneCell *oneCell = [[OneCell alloc] init];
            [oneCell loadDataWithModel:_userModel];
            [oneCell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return oneCell;
        }
            break;
        case 1: {   //徽章
            TwoCell *twoCell = [[TwoCell alloc] init];
            twoCell.titleLab.text = [_titleArray objectAtIndex:indexPath.row];
            [twoCell.contentLab setHidden:YES];
            [twoCell setSelectionStyle:UITableViewCellSelectionStyleNone];
            for (int i = 0; i <_badgeArray.count; i++) {
                UIImageView *HzImageView = [[UIImageView alloc] initWithFrame:CGRectMake(75 + 20 * i, 10, 15, 15)];
                NSString *greyPic = [_badgeArray[i] grey_pic];
                [HzImageView setImageWithURL:[NSURL URLWithString:greyPic]];
                for (NSString *ids in _userModel.medals.allKeys) {
                    if (ids.intValue == [_badgeArray[i] ID].intValue) {
                        NSString *picUrl = [_badgeArray[i] pic_url];
                        [HzImageView setImageWithURL:[NSURL URLWithString:picUrl]];
                    }
                }
                [twoCell addSubview:HzImageView];
            }
            return twoCell;
        }
            break;
        case 2: {   //地区
            TwoCell *twoCell = [[TwoCell alloc] init];
            twoCell.titleLab.text = [_titleArray objectAtIndex:indexPath.row];
            [twoCell.contentLab setHidden:NO];
            if (_userModel.location.length) {
                [twoCell.contentLab setText:_userModel.location];
            } else {
                [twoCell.contentLab setText:@"未知"];
            }
            [twoCell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return twoCell;
        }
            break;
        case 3: {   //座驾
            TwoCell *twoCell = [[TwoCell alloc] init];
            twoCell.titleLab.text = [_titleArray objectAtIndex:indexPath.row];
            [twoCell.contentLab setHidden:YES];
            [twoCell setSelectionStyle:UITableViewCellSelectionStyleNone];
            NSMutableArray *urlArr = [NSMutableArray array];
            for (int i = 0; i <_carArray.count; i++) {
                for (NSString *ids in _userModel.car.allKeys) {
                    if (ids.intValue == [_carArray[i] ID].intValue) {
                        NSString *picUrl = [_carArray[i] pic_url];
                        [urlArr addObject:picUrl];
                    }
                }
            }
            for (int i = 0; i < urlArr.count; i++) {
                UIImageView *HzImageView = [[UIImageView alloc] initWithFrame:CGRectMake(75 + 20 * i, 10, 15, 15)];
                [HzImageView setImageWithURL:[NSURL URLWithString:urlArr[i]]];
                [twoCell addSubview:HzImageView];
            }
            return twoCell;
        }
            break;
        case 4: {   //直播地址
            TwoCell *twoCell = [[TwoCell alloc] init];
            twoCell.titleLab.text = [_titleArray objectAtIndex:indexPath.row];
            [twoCell.contentLab setHidden:NO];
            if (_userModel._id) {
                [twoCell.contentLab setText:[NSString stringWithFormat:@"http://www.izhubo.com/%@",self.userId]];
            }
            [twoCell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return twoCell;
        }
            break;
        default:
            break;
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _titleArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 55.0;
    } else {
        return 35.0;
    }
}

#pragma mark - request
- (void)requestWithParam:(NSString *)param tag:(NSInteger)tag
{
    NSString *urlStr = [NSString stringWithFormat:@"%@zone/%@/%@",BaseURL,param,self.userId];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [request setTimeOutSeconds:100];
    request.tag = tag;
    request.delegate = self;
    [request startAsynchronous];
}

- (void)requestWithFollowing:(NSString *)param tag:(NSInteger)tag
{
    if (_model.access_token.length) {
        NSString *urlStr = [NSString stringWithFormat:@"%@user/%@/%@/%@",BaseURL,param,_model.access_token,self.userId];
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
        [request setTimeOutSeconds:100];
        request.delegate = self;
        request.tag = tag;
        [request startAsynchronous];
    }
}

- (void)requestCarInfo
{
    NSString *urlStr = [NSString stringWithFormat:@"%@show/cars_list",BaseURL];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [request setTimeOutSeconds:100];
    request.tag = 700;
    request.delegate = self;
    [request startAsynchronous];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    id result = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
    switch (request.tag) {
        case 500: { //个人资料
            if ([result isKindOfClass:[NSDictionary class]]) {
                NSNumber *code = [result objectForKey:@"code"];
                if (code.intValue == 1) {
                    NSDictionary *dataDic = [result objectForKey:@"data"];
                    _userModel = [[UserInfoModel alloc] init];
                    [_userModel getUserInfoWithDictionary:dataDic];
                    _titleLabel.text = _userModel.nick_name;
                    [self requestWithParam:@"user_medal" tag:501];  //徽章信息
                }
            }
        }
            break;
        case 501: { //徽章信息
            if ([result isKindOfClass:[NSDictionary class]]) {
                NSNumber *code = [result objectForKey:@"code"];
                if (code.intValue == 1) {
                    NSArray *dataArr = [result objectForKey:@"data"];
                    for (NSDictionary *dic in dataArr) {
                        BadgeModel *badgeModel = [[BadgeModel alloc] init];
                        [badgeModel getBadgeModelWithDictionary:dic];
                        [_badgeArray addObject:badgeModel];
                    }
                    [self requestCarInfo];  //座驾信息
                }
            }
        }
            break;
        case 700: { //座驾信息
            if ([result isKindOfClass:[NSDictionary class]]) {
                NSNumber *code = [result objectForKey:@"code"];
                if (code.intValue == 1) {
                    NSArray *carArray = [result objectForKey:@"data"];
                    for (NSDictionary *dic in carArray) {
                        BadgeModel *badgeModel = [[BadgeModel alloc] init];
                        [badgeModel getBadgeModelWithDictionary:dic];
                        [_carArray addObject:badgeModel];
                    }
                    [_tableView reloadData];
                }
            }
        }
            break;
        case 600: { //添加关注
            if ([result isKindOfClass:[NSDictionary class]]) {
                NSNumber *code = [result objectForKey:@"code"];
                if (code.intValue == 1) {
                    _attentionButton.selected = YES;
                }
            }
        }
            break;
        case 601: { //取消关注
            if ([result isKindOfClass:[NSDictionary class]]) {
                NSNumber *code = [result objectForKey:@"code"];
                if (code.intValue == 1) {
                    _attentionButton.selected = NO;
                }
            }
        }
            break;
        case 602: { //关注列表
            if ([result isKindOfClass:[NSDictionary class]]) {
                NSNumber *code = [result objectForKey:@"code"];
                if (code.intValue == 1) {
                    NSDictionary *dataDic = [result objectForKey:@"data"];
                    NSArray *roomsArr = [dataDic objectForKey:@"rooms"];
                    for (NSDictionary *dic in roomsArr) {
                        NSNumber *roomid = [dic objectForKey:@"_id"];
                        [_attentionArray addObject:roomid];
                    }
                    if ([self isAttentionWithRoomid:self.userId]) {
                        _attentionButton.selected = YES;
                    } else {
                        _attentionButton.selected = NO;
                    }
                }
            }
        }
            break;
        default:
            break;
    }
    
}

- (BOOL)isAttentionWithRoomid:(NSNumber *)roomid
{
    BOOL isAttention = NO;
    for (NSNumber *ids in _attentionArray) {
        if ([roomid isEqual:ids]) {
            isAttention = YES;
        }
    }
    return isAttention;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
