//
//  DynamicViewController.m
//  LoveAnchor
//
//  Created by zhongqinglongtu on 14-8-11.
//  Copyright (c) 2014年 zhongqinglongtu. All rights reserved.
//

#import "DynamicViewController.h"

@interface DynamicViewController ()<ASIHTTPRequestDelegate>
{
    LoginModel *model;
    NSMutableArray *_dataArray;
    NSMutableArray *_todayArray;
    NSMutableArray *_yesterdayArray;
    NSMutableArray *_daysagoArray;
    UITableView *_tableView;
}
@end

@implementation DynamicViewController

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

    _dataArray = [[NSMutableArray alloc] init];
    _todayArray = [[NSMutableArray alloc] init];
    _yesterdayArray = [[NSMutableArray alloc] init];
    _daysagoArray = [[NSMutableArray alloc] init];
    
    [self.navigationController.navigationBar setTranslucent:NO];
    self.view.backgroundColor = [UIColor whiteColor];
    [self showUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    model = [CommonUtil getUserModel];
    [self request];
}

#pragma mark - 界面
- (void)showUI
{
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithTitle:@"清空" style:UIBarButtonItemStylePlain target:self action:@selector(barButtonItemClick:)];
    rightButton.tintColor = textFontColor;
    rightButton.tag = 1001;
    self.navigationItem.rightBarButtonItem = rightButton;
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(122, 15, 70, 17)];
    titleLabel.text = @"历史观看";
    titleLabel.font = [UIFont systemFontOfSize:17.0f];
    titleLabel.textColor = textFontColor;
    [self.navigationController.navigationBar addSubview:titleLabel];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 49) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    _tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
}

- (void)barButtonItemClick:(UIBarButtonItem *)button
{
    NSMutableArray *allRoomIds = [NSMutableArray array];
    for (DynamicModel *dynamicModel in _todayArray) {
        [allRoomIds addObject:[NSString stringWithFormat:@"roomid=%@",dynamicModel.roomId]];
    }
    for (DynamicModel *dynamicModel in _yesterdayArray) {
        [allRoomIds addObject:[NSString stringWithFormat:@"roomid=%@",dynamicModel.roomId]];
    }
    for (DynamicModel *dynamicModel in _daysagoArray) {
        [allRoomIds addObject:[NSString stringWithFormat:@"roomid=%@",dynamicModel.roomId]];
    }
    NSString *urlStr = [NSMutableString stringWithFormat:@"%@viewlog/del/%@?",BaseURL,model.access_token];
    for (NSString *ids in allRoomIds) {
        urlStr = [urlStr stringByAppendingFormat:[urlStr hasSuffix:@"?"] ? @"%@" : @"&%@",ids];
    }
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
    request.delegate = self;
    request.tag = 102;
    [request setTimeOutSeconds:100];
    [request startAsynchronous];
}

#pragma mark - delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *idenifier = @"DynamicTableViewCell";
    DynamicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idenifier];
    if (cell == nil) {
        cell = [[DynamicTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idenifier];
    }
    NSArray *modelArray = [_dataArray objectAtIndex:indexPath.section];
    [cell loadCellDataWithModel:modelArray[indexPath.row]];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.deleteButtonBlock = ^() {
        [self deleteRequestWithRoomId:[modelArray[indexPath.row] roomId]];
    };
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[_dataArray objectAtIndex:section] count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([[_dataArray objectAtIndex:section] count]) {
        return 27.0;
    }
    return 0.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        if ([[_dataArray objectAtIndex:section] count]) {
            UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 27)];
            titleLabel.text = @"今天";
            titleLabel.font = [UIFont systemFontOfSize:15.0f];
            titleLabel.backgroundColor = [UIColor colorWithRed:230/255.0 green:233/255.0 blue:232/255.0 alpha:0.8];
            titleLabel.textColor = [UIColor colorWithRed:99/255.0 green:109/255.0 blue:114/255.0 alpha:0.8];
            return titleLabel;
        }
    } else if (section == 1) {
        if ([[_dataArray objectAtIndex:section] count]) {
            UILabel *titleLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 70, 27)];
            titleLabel1.text = @"昨天";
            titleLabel1.font = [UIFont systemFontOfSize:15.0f];
            titleLabel1.backgroundColor = [UIColor colorWithRed:230/255.0 green:233/255.0 blue:232/255.0 alpha:0.8];
            titleLabel1.textColor = [UIColor colorWithRed:99/255.0 green:109/255.0 blue:114/255.0 alpha:0.8];
            return titleLabel1;
        }
    } else if (section == 2) {
        if ([[_dataArray objectAtIndex:section] count]) {
            UILabel *titleLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 70, 27)];
            titleLabel2.text = @"更早";
            titleLabel2.font = [UIFont systemFontOfSize:15.0f];
            titleLabel2.backgroundColor = [UIColor colorWithRed:230/255.0 green:233/255.0 blue:232/255.0 alpha:0.8];
            titleLabel2.textColor = [UIColor colorWithRed:99/255.0 green:109/255.0 blue:114/255.0 alpha:0.8];
            return titleLabel2;
        }
    }
    return nil;
}

#pragma mark - 解析
- (void)request
{
    NSString *urlStr = [NSString stringWithFormat:@"%@viewlog/list/%@",BaseURL,model.access_token];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
    request.delegate = self;
    request.tag = 100;
    [request setTimeOutSeconds:100];
    [request startAsynchronous];
}

- (void)deleteRequestWithRoomId:(NSNumber *)roomId
{
    NSString *urlStr = [NSString stringWithFormat:@"%@viewlog/del/%@?roomid=%@",BaseURL,model.access_token,roomId];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
    request.delegate = self;
    request.tag = 101;
    [request setTimeOutSeconds:100];
    [request startAsynchronous];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    id result = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
    switch (request.tag) {
        case 100: {
            if ([result isKindOfClass:[NSDictionary class]]) {
                [_todayArray removeAllObjects];
                [_yesterdayArray removeAllObjects];
                [_daysagoArray removeAllObjects];
                [_dataArray removeAllObjects];
                
                NSArray *array = [result objectForKey:@"data"];
                NSMutableArray *allData_mutable = [NSMutableArray array];
                
                for (NSDictionary *dict in array) {
                    DynamicModel *modelData = [[DynamicModel alloc]init];
                    [modelData setValuesForKeysWithDictionary:dict];
                    [allData_mutable addObject:modelData];
                }
                
                for (DynamicModel *dynamicModel in allData_mutable) {
                    NSString *time = [CommonUtil getTimeInterval:dynamicModel.timestamp.longLongValue/1000];
                    if (time.intValue == 0) {
                        [_todayArray addObject:dynamicModel];
                    } else if (time.intValue == -1) {
                        [_yesterdayArray addObject:dynamicModel];
                    } else if (time.intValue < 0) {
                        [_daysagoArray addObject:dynamicModel];
                    }
                }
                [_dataArray addObject:_todayArray];
                [_dataArray addObject:_yesterdayArray];
                [_dataArray addObject:_daysagoArray];
            }
            [_tableView reloadData];
        }
            break;
        case 101:
        case 102: {
            if ([result isKindOfClass:[NSDictionary class]]) {
                NSNumber *code = [result objectForKey:@"code"];
                if (code.intValue == 1) {
                    [self request];
                }
            }
        }
            break;
        default:
            break;
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
