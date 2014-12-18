//
//  RankingListViewController.m
//  LoveAnchor
//
//  Created by zhongqinglongtu on 14-8-11.
//  Copyright (c) 2014年 zhongqinglongtu. All rights reserved.
//

#import "RankingListViewController.h"

@interface RankingListViewController ()
{
    //排行榜下拉菜单底图
    UIImageView *buttonImageView;
    //排行榜button
    UIButton *rankingButton;
    //排行榜下拉菜单底图上的button
    NSArray *buttonTitle;
    //装所有请求回来的数据的数组
    NSMutableArray *_dataArray;
    //页面的表格
    UITableView *_tableView;
    //左右键
    BOOL leftisVisible;
    BOOL rightisVisible;
    //判断点击了日 月 周 超哪个按钮
    int page;
    //判断点击明星 富豪 人气哪个按钮
    int page2;
    //装url数组的字典
    NSDictionary *_dict;
}

@property (nonatomic, strong) LoginModel *model;

@end

@implementation RankingListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController.navigationBar setTranslucent:NO];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _dataArray = [NSMutableArray array];
    _model = [CommonUtil getUserModel];
    page = 0;
    page2 = 10;
    
    [self initSet];
    [self showUI];
    [self requestWithTag:10 andTag2:0];
}

- (void)initSet {
    NSArray *arr1 = [NSArray arrayWithObjects:MINGXINGRIBANG,MINGXINGZHOUBANG,MINGXINGYUEBANG,MINGXINGCHAOBANG, nil];
    NSArray *arr2 = [NSArray arrayWithObjects:FUHAORIBANG,FUHAOZHOUBANG,FUHAOYUEBANG,FUHAOCHAOBANG, nil];
    NSArray *arr3 = [NSArray arrayWithObjects:RENQIRIBANG,RENQIZHOUBANG,RENQIYUEBANG,RENQICHAOBANG, nil];
    
    _dict = [[NSDictionary alloc]initWithObjects:[NSArray arrayWithObjects:arr1,arr2,arr3, nil] forKeys:[NSArray arrayWithObjects:@"0",@"1",@"2", nil]];
}
#pragma mark - 界面
-(void)showUI
{
    //个人信息
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setImage:[UIImage imageNamed:@"gerenxinxi"] forState:UIControlStateNormal];
    leftButton.frame = CGRectMake(10, 5, 40, 30);
    leftButton.backgroundColor = [UIColor clearColor];
    leftButton.tag = 1000;
    [leftButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar addSubview:leftButton];
    //排行榜button
    rankingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rankingButton.frame = CGRectMake(110, 12, 95, 20);
    rankingButton.tag = 104;
    rankingButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [rankingButton setTitle:@"明星排行榜" forState:UIControlStateNormal];
    [rankingButton setTitleColor:textFontColor forState:UIControlStateNormal];
    [rankingButton  addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar addSubview:rankingButton];
    //小三角
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(200, 10, 20, 20)];
    imageView.image = [UIImage imageNamed:@"xialacaidan"];
    [self.navigationController.navigationBar addSubview:imageView];
    //横线
    UIImageView *segImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 44, kScreenWidth, 0.5)];
    segImageView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:segImageView];
    //横榜
    NSArray *buttonArray = [NSArray arrayWithObjects:@"日榜",@"周榜",@"月榜",@"超榜", nil];
    
    UISegmentedControl *segmented = [[UISegmentedControl alloc]initWithItems:buttonArray];
    [segmented setFrame:CGRectMake(10, 8, 300, 28)];
    [segmented setTintColor:textFontColor];
    segmented.selectedSegmentIndex = 0;
    [segmented addTarget:self action:@selector(segmentedClick:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segmented];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 45, kScreenWidth, kScreenHeight-44-64-49)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.autoresizesSubviews  = YES;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:_tableView];
    
    //排行榜下拉菜单底图
    buttonImageView = [[UIImageView alloc]initWithFrame:CGRectMake(105, 0, 120, 105)];
    buttonImageView.image = [UIImage imageNamed:@"paihangbang"];
    buttonImageView.backgroundColor = [UIColor clearColor];
    buttonImageView.userInteractionEnabled = YES;
    [self.view addSubview:buttonImageView];
    for (int i = 0; i<3; i++) {
        buttonTitle = @[@"明星排行榜",@"富豪排行榜",@"人气排行榜"];
        UIButton *listButton = [UIButton buttonWithType:UIButtonTypeCustom];
        listButton.frame = CGRectMake(10, 15+i*28, buttonImageView.frame.size.width-20, 20);
        [listButton setTitleColor:textFontColor forState:UIControlStateNormal];
        [listButton setTitle:[buttonTitle objectAtIndex:i] forState:UIControlStateNormal];
        [listButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        listButton.tag = 100+i;
        
        listButton.layer.borderColor = [UIColor clearColor].CGColor;
        listButton.layer.borderWidth = 5.0;
        listButton.layer.cornerRadius = 5.0;
        [buttonImageView addSubview:listButton];
    }
    [buttonImageView setHidden:YES];
}

#pragma mark - 解析
- (void)requestWithTag:(NSInteger)tag andTag2:(NSInteger)tag2
{
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[_dict objectForKey:[NSString stringWithFormat:@"%d",tag - 10]][tag2]]];
    request.delegate = self;
    request.tag = tag;
    [request setTimeOutSeconds:20];
    [request startAsynchronous];
}

- (void)addRequestWithRoomId:(NSNumber *)roomId
{
    NSString *urlStr = [NSString stringWithFormat:@"%@viewlog/add/%@/%@",BaseURL,_model.access_token,roomId];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
    request.delegate = self;
    request.tag = 100;
    [request setTimeOutSeconds:100];
    [request startAsynchronous];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    id result = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
    if (request.tag == 100) {
        if ([result isKindOfClass:[NSDictionary class]]) {
            NSNumber *code = [result objectForKey:@"code"];
            if (code.intValue == 1) {
                
            }
        }
    } else {
        [_dataArray removeAllObjects];
        if ([result isKindOfClass:[NSDictionary class]]) {
            NSArray *allData = [result objectForKey:@"data"];
            NSMutableArray *allData_mutable = [NSMutableArray array];
            for (NSDictionary *dict in allData) {
                RankingModel *rankModel = [[RankingModel alloc] init];
                [rankModel getRankModelWithDictionary:dict];
                switch (request.tag) {
                    case 10:
                        rankModel.rankType = starType;
                        break;
                    case 11:
                        rankModel.rankType = richType;
                        break;
                    case 12:
                        rankModel.rankType = popularityType;
                        break;
                    default:
                        break;
                }
                [allData_mutable addObject:rankModel];
            }
            NSUInteger count = [allData_mutable count];
            for (int i = 0; i < count; i++) {
                NSArray *firstData = @[[allData_mutable objectAtIndex:i]];
                [_dataArray addObject:firstData];
            }
        }
        [_tableView reloadData];
    }
}


#pragma mark - 点击事件

- (void)segmentedClick:(UISegmentedControl *)seg
{
    switch (seg.selectedSegmentIndex) {
        case 0:
            page = 0;
            [self requestWithTag:page2 andTag2:0];
            break;
        case 1:
            page = 1;
            [self requestWithTag:page2 andTag2:1];
            break;
        case 2:
            page = 2;
            [self requestWithTag:page2 andTag2:2];
            break;
        case 3:
            page = 3;
            [self requestWithTag:page2 andTag2:3];
            break;
        default:
            break;
    }
}

- (void)buttonClick:(UIButton *)button
{
    if (button.tag == 1000) {
        if (!leftisVisible) {
            [[SliderViewController sharedSliderController] leftItemClick];
            leftisVisible = YES;
        }else{
            [[SliderViewController sharedSliderController]  showContentControllerWithModel:@"TabBarViewController"];
            leftisVisible = NO;
        }

    } else if (button.tag == 104) {
        if (buttonImageView.hidden) {
            [buttonImageView setHidden:NO];
        } else {
            [buttonImageView setHidden:YES];
        }
    } else {
        [buttonImageView setHidden:YES];
        [rankingButton setTitle:[buttonTitle objectAtIndex:button.tag-100] forState:UIControlStateNormal];
        for (id object in buttonImageView.subviews) {
            if ([object isKindOfClass:[UIButton class]]) {
                UIButton *btn = (UIButton *)object;
                if (btn.tag != button.tag) {
                    [btn setBackgroundColor:[UIColor clearColor]];
                    [btn setTitleColor:textFontColor forState:UIControlStateNormal];
                } else {
                    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    [btn setBackgroundColor:textFontColor];
                }
            }
        }
        if (button.tag == 100) {
            page2 = 10;
            [self requestWithTag:page2 andTag2:page];
        } else if (button.tag == 101) {
            page2 = 11;
            [self requestWithTag:page2 andTag2:page];
        } else if (button.tag == 102) {
            page2 = 12;
            [self requestWithTag:page2 andTag2:page];
        }
    }
}

#pragma mark - tabelViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *modelArray = [_dataArray objectAtIndex:indexPath.row];
    static NSString *identifier = @"RankingCell";
    RankingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[RankingTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setCellData:modelArray];
    
    if (indexPath.row == 0) {
        [cell.firstImgView setHidden:NO];
        [cell.numberLabel setHidden:YES];
    } else if (indexPath.row == 1||indexPath.row == 2) {
        [cell.firstImgView setHidden:YES];
        [cell.numberLabel setHidden:NO];
        cell.numberLabel.text = [NSString stringWithFormat:@"%d",indexPath.row+1];
        cell.numberLabel.textColor = [UIColor colorWithRed:205/255.0 green:35/255.0 blue:33/255.0 alpha:0.8];
    } else {
        [cell.firstImgView setHidden:YES];
        [cell.numberLabel setHidden:NO];
        cell.numberLabel.text = [NSString stringWithFormat:@"%d",indexPath.row+1];
        cell.numberLabel.textColor = [UIColor colorWithRed:109/255.0 green:109/255.0 blue:109/255.0 alpha:0.8];
    }
    return cell;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RankingModel *rankModel = [_dataArray objectAtIndex:indexPath.row][0];
    switch (rankModel.rankType) {
        case starType:
        case popularityType: {
            [self addRequestWithRoomId:rankModel._id];
            
            PlayViewController *play = [[PlayViewController alloc]init];
            play.allModel = rankModel;
            [self presentViewController:play animated:YES completion:nil];
        }
            break;
        case richType: {
            DatumViewController *datum = [[DatumViewController alloc] init];
            NSArray *modeArr = [_dataArray objectAtIndex:indexPath.row];
            datum.userId = [modeArr[0] _id];
            [self presentViewController:datum animated:YES completion:nil];
        }
            break;
        default:
            break;
    }    
}

@end
