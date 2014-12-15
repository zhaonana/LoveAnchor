//
//  SearchViewController.m
//  LoveAnchor
//
//  Created by zhongqinglongtu on 14-8-11.
//  Copyright (c) 2014年 zhongqinglongtu. All rights reserved.
//

#import "SearchViewController.h"


@interface SearchViewController ()
{
    UISearchBar *_searchBar;
    NSMutableArray *_dataArray;
    UITableView *_tableView;
    
    int segPage;
    int btnPage;
    
    NSDictionary *_dic;
}
@end

@implementation SearchViewController

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
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"nav_bg.png"] forBarMetrics:UIBarMetricsDefault];
    self.view.backgroundColor = [UIColor whiteColor];
    [self showUI];
    [self requestWithTag:0 andTag1:0];
    [self initSet];
    
}
- (void)initSet
{
    NSString *nameUrl = [NSString stringWithFormat:@"%@public/room_list?nick_name=%@",BaseURL,_searchBar.text];
    NSString *idUrl = [NSString stringWithFormat:@"%@public/room_list?room_id=%@",BaseURL,_searchBar.text];
    NSArray *array = [NSArray arrayWithObjects:nameUrl,idUrl, nil];
    
    _dic = [[NSDictionary alloc]initWithObjects:[NSArray arrayWithObject:array] forKeys:[NSArray arrayWithObject:@"0"]];
    
}
#pragma mark - UI界面
- (void)showUI
{
    _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 5, 320, 35)];
    _searchBar.placeholder = @"请输入昵称";
    _searchBar.delegate = self;
    _searchBar.showsCancelButton = YES;
    [self.navigationController.navigationBar addSubview: _searchBar];
    for (UIView *v in [[_searchBar subviews][0] subviews]) {
        if ([v isKindOfClass:[NSClassFromString(@"UINavigationButton") class]]) {
            UIButton *btn = (UIButton *)v;
            [btn setTitle:@"搜索" forState:UIControlStateNormal];
            [btn setTitleColor:textFontColor forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
    NSArray *buttonArray = @[@"昵称",@"房号"];
    UISegmentedControl *segmented = [[UISegmentedControl alloc]initWithItems:buttonArray];
    segmented.frame = CGRectMake(10, 8, 300, 28);
    segmented.selectedSegmentIndex = 0;
    segmented.tintColor = textFontColor;
    [segmented addTarget:self action:@selector(segmentedClick:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segmented];
    
    UIImageView *segImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 44, kScreenWidth, 0.5)];
    segImageView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:segImageView];
    
    _tableView= [[UITableView alloc]initWithFrame:CGRectMake(0, 45, kScreenWidth, kScreenHeight-64-49-44) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:_tableView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [_tableView addGestureRecognizer:tap];
}

#pragma mark - 点击事件
- (void)segmentedClick:(UISegmentedControl *)seg
{
    switch (seg.selectedSegmentIndex) {
        case 0:
            segPage = 0;
            _searchBar.placeholder = @"请输入昵称";
            break;
        case 1:
            segPage = 1;
            _searchBar.placeholder = @"请输入房间号";
            break;
            
        default:
            break;
    }
}
- (void)buttonClick
{
    [_searchBar resignFirstResponder];
    [self initSet];
    [self requestWithTag:btnPage andTag1:segPage];
}

- (void)tap:(UITapGestureRecognizer *)tap
{
    [_searchBar resignFirstResponder];
}

#pragma mark - 解析
- (void)requestWithTag:(NSInteger)tag andTag1:(NSInteger)tag1
{
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[_dic objectForKey:[NSString stringWithFormat:@"%ld",(long)tag]][tag1]]];
    request.delegate = self;
    [request startAsynchronous];
    [request setTimeOutSeconds:[_dataArray count]];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    [_dataArray removeAllObjects];
    id result = [NSJSONSerialization JSONObjectWithData:request.responseData  options:NSJSONReadingMutableContainers error:nil];
    if ([result isKindOfClass:[NSDictionary class]]) {
        NSArray *allData = [result objectForKey:@"data"];
        NSMutableArray *allData_mutable = [NSMutableArray array];
        
        for (NSDictionary *dict in allData) {
            SearchModel *model = [[SearchModel alloc]init];
            [model setValuesForKeysWithDictionary:dict];
            [allData_mutable addObject:model];
        }
        for (int i = 0; i < [allData_mutable count]; i++) {
            NSArray *firstData = @[[allData_mutable objectAtIndex:i]];
            [_dataArray addObject:firstData];
        }
    }
    [_tableView reloadData];
}


#pragma mark - UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *modelArray = [_dataArray objectAtIndex:indexPath.row];
    static NSString *idenifier = @"SearchTableViewCell";
    SearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idenifier];
    if (cell == nil) {
        cell = [[SearchTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idenifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [cell setCellData:modelArray];
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
    [_searchBar resignFirstResponder];
}

#pragma mark - UISearchBarDelegate methods
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self buttonClick];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
