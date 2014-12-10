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
    UITableView *_tableView;
}
@end

@implementation DynamicViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _dataArray = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

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
- (void)showUI {
    
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
    NSLog(@"着火了，别点了");
}

#pragma mark - delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *modelArray = [_dataArray objectAtIndex:indexPath.row];
    static NSString *idenifier = @"DynamicTableViewCell";
    DynamicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idenifier];
    if (cell == nil) {
        cell = [[DynamicTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idenifier];
    }
    [cell setCellData:modelArray];
    cell.userInteractionEnabled = NO;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return [[_dataArray objectAtIndex:0] count];
            break;
        case 1:
            return [[_dataArray objectAtIndex:1] count];
            break;
        case 2:
            return [[_dataArray objectAtIndex:2] count];
            break;
        default:
            break;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 27;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    if (section == 0) {
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 27)];
        titleLabel.text = @"今天";
        titleLabel.font = [UIFont systemFontOfSize:15.0f];
        titleLabel.backgroundColor = [UIColor colorWithRed:230/255.0 green:233/255.0 blue:232/255.0 alpha:0.8];
        titleLabel.textColor = [UIColor colorWithRed:99/255.0 green:109/255.0 blue:114/255.0 alpha:0.8];
        return titleLabel;
    } else if (section == 1) {
        UILabel *titleLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 70, 27)];
        titleLabel1.text = @"昨天";
        titleLabel1.font = [UIFont systemFontOfSize:15.0f];
        titleLabel1.backgroundColor = [UIColor colorWithRed:230/255.0 green:233/255.0 blue:232/255.0 alpha:0.8];
        titleLabel1.textColor = [UIColor colorWithRed:99/255.0 green:109/255.0 blue:114/255.0 alpha:0.8];
        return titleLabel1;
    } else {
        UILabel *titleLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 70, 27)];
        titleLabel2.text = @"更早";
        titleLabel2.font = [UIFont systemFontOfSize:15.0f];
        titleLabel2.backgroundColor = [UIColor colorWithRed:230/255.0 green:233/255.0 blue:232/255.0 alpha:0.8];
        titleLabel2.textColor = [UIColor colorWithRed:99/255.0 green:109/255.0 blue:114/255.0 alpha:0.8];
        return titleLabel2;
    }
}

#pragma mark - 解析
- (void)request
{
    NSString *urlStr = [NSString stringWithFormat:@"%sviewlog/list/%@",BaseURL,model.access_token];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
    request.delegate = self;
    [request setTimeOutSeconds:100];
    [request startAsynchronous];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"历史观看 == %@",request.responseString);
    id result = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
    if ([result isKindOfClass:[NSDictionary class]]) {
        NSArray *array = [result objectForKey:@"data"];
        NSMutableArray *allData_mutable = [NSMutableArray array];
        
        for (NSDictionary *dict in array) {
            DynamicModel *modelData = [[DynamicModel alloc]init];
            [modelData setValuesForKeysWithDictionary:dict];
            NSLog(@"model == %@",modelData);
            [allData_mutable addObject:modelData];
            NSLog(@"allData_mutable == %@",allData_mutable);
        }
        NSUInteger count = [allData_mutable count];
        for (int i = 0; i < count; i++) {
            NSArray *firstData = @[[allData_mutable objectAtIndex:i]];
            [_dataArray addObject:firstData];
        }
    }
    [_tableView reloadData];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
@end
