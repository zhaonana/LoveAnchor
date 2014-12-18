//
//  AttentionViewController.m
//  LoveAnchor
//
//  Created by zhongqinglongtu on 14-8-11.
//  Copyright (c) 2014年 zhongqinglongtu. All rights reserved.
//

#import "AttentionViewController.h"

@interface AttentionViewController ()<ASIHTTPRequestDelegate,ThirdRowTableViewCellDelegate,FirstRowTableViewCellDelegate,SecondRowTableViewCellDelegate>
{
    LoginModel *model;
    NSMutableArray *_dataArray;
    UITableView *_tableView;
}
@property (nonatomic,strong) HomePageViewController *home;
@end

@implementation AttentionViewController

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
    model = [CommonUtil getUserModel];
    self.view.backgroundColor = [UIColor whiteColor];
    [self showUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self request];
}

#pragma mark - 界面

- (void)showUI
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-49-64)style:UITableViewStylePlain];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    _tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
}

#pragma mark - delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *modelArray = [_dataArray objectAtIndex:indexPath.row];
    if (indexPath.row == 0) {
        FirstRowTableViewCell *firstCell = [[FirstRowTableViewCell alloc] init];
        firstCell.selectionStyle = UITableViewCellSelectionStyleNone;
        firstCell.delegate = self;
        [firstCell setCellData:modelArray];
        return firstCell;
    } else if (indexPath.row == 1) {
        SecondRowTableViewCell *secondCell = [[SecondRowTableViewCell alloc]init];
        secondCell.selectionStyle = UITableViewCellSelectionStyleNone;
        secondCell.delegate = self;
        [secondCell setCellData:modelArray];
        return secondCell;
    } else {
        ThirdRowTableViewCell *thirdCell = [[ThirdRowTableViewCell alloc] init];
        thirdCell.selectionStyle = UITableViewCellSelectionStyleNone;
        thirdCell.delegate = self;
        [thirdCell setCellData:modelArray];
        return thirdCell;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 170;
    } else if (indexPath.row == 1) {
        return 122;
    } else {
        return 83;
    }
}
#pragma mark ThirdRowTableViewCellDelegate
- (void)thirdClick:(AllModel *)allModel {
    
    if (!self.home.rightisVisible && !self.home.leftisVisible) {
        PlayViewController *play = [[PlayViewController alloc]init];
        play.allModel = allModel;
        [self presentViewController:play animated:YES completion:nil];
    }
    
}

-(void)firstClick:(AllModel *)allModel
{
    if (!self.home.rightisVisible && !self.home.leftisVisible) {
        PlayViewController *play = [[PlayViewController alloc]init];
        play.allModel = allModel;
        [self presentViewController:play animated:YES completion:nil];
    }
}

-(void)secondClick:(AllModel *)allModel
{
    if (!self.home.rightisVisible && !self.home.leftisVisible) {
        PlayViewController *play = [[PlayViewController alloc]init];
        play.allModel = allModel;
        [self presentViewController:play animated:YES completion:nil];
    }
}


#pragma mark - 解析
- (void)request
{
    NSString *urlStr = [NSString stringWithFormat:@"%@user/following_list/%@",BaseURL,model.access_token];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
    request.delegate = self;
    [request setTimeOutSeconds:100];
    [request startAsynchronous];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    id result = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
    if ([result isKindOfClass:[NSDictionary class]]) {
        NSArray *allDtJson = [[result objectForKey:@"data"] objectForKey:@"rooms"];
        NSMutableArray *allDtJson_mutable = [NSMutableArray array];
        
        for (NSDictionary *dict in allDtJson) {
            AllModel *allModel = [[AllModel alloc]init];
            [allModel setValuesForKeysWithDictionary:dict];
            [allDtJson_mutable addObject:allModel];
        }
        
        [_dataArray removeAllObjects];
        
        NSUInteger count = [allDtJson_mutable count];
        if (count > 0) {
            NSArray *firstRowData = @[[allDtJson_mutable objectAtIndex:0]];
            [_dataArray addObject:firstRowData];
            
            if (count > 2) {
                NSArray *secondRowData = @[[allDtJson_mutable objectAtIndex:1],[allDtJson_mutable objectAtIndex:2]];
                [_dataArray addObject:secondRowData];
                
                if (count > 3) {
                    NSMutableArray *thirdRowData = [NSMutableArray array];
                    for (int i = 0; i < count-3; i++) {
                        if (i%3 == 0 && i != 0) {
                            [_dataArray addObject:thirdRowData];
                            thirdRowData = [NSMutableArray array];
                        }
                        [thirdRowData addObject:allDtJson_mutable[i+3]];
                        if (thirdRowData.count) {
                            [_dataArray addObject:thirdRowData];
                        }
                    }
                }
            }
        }
    }
    [_tableView reloadData];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
