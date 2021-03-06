//
//  RightMenuViewController.m
//  LoveAnchor
//
//  Created by zhongqinglongtu on 14-8-27.
//  Copyright (c) 2014年 zhongqinglongtu. All rights reserved.
//

#import "RightMenuViewController.h"

#define REFRESH_NOTFICATION @"refreshNotification"
#define REFRESH_BACK_NOTFICATION @"refreshBackNotification"

@interface RightMenuViewController ()<ASIHTTPRequestDelegate>
{
    NSArray *array1;
    NSArray *array2;
    NSArray *array3;
    NSArray *array4;
    NSArray *array5;
    UITableView *rightTableView;
    NSMutableArray *dataArr1;
    NSMutableArray *dataArr2;
    NSMutableArray *dataArr3;
    NSMutableArray *dataArr4;
    NSMutableArray *dataArr5;
    NSString *_liveType;
}
@end

@implementation RightMenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        array1 = [NSArray array];
        array2 = [NSArray array];
        array3 = [NSArray array];
        array4 = [NSArray array];
        array5 = [NSArray array];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshBackView:) name:REFRESH_BACK_NOTFICATION object:nil];

    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    imageView.image = [UIImage imageNamed:@"zhuyebeijing"];
    imageView.userInteractionEnabled = YES;
    [self.view addSubview:imageView];
    
    rightTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height-200) style:UITableViewStylePlain];
    rightTableView.delegate = self;
    rightTableView.dataSource = self;
    rightTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    rightTableView.backgroundColor = [UIColor clearColor];
    [imageView addSubview:rightTableView];

    [self requestWithSbean:1616000 ebean:0 tag:1];
    [self requestWithSbean:561000 ebean:1616000 tag:2];
    [self requestWithSbean:106000 ebean:561000 tag:3];
    [self requestWithSbean:0 ebean:106000 tag:4];
    [self request];
}

- (void)refreshBackView:(NSNotification *)notification
{
    if ([notification.object isEqualToString:@"allType"]) {
        _liveType = @"allType";
        [self request];
    } else if ([notification.object isEqualToString:@"superstarType"]) {
        _liveType = @"superstarType";
        [self requestWithSbean:1616000 ebean:0 tag:1];
    } else if ([notification.object isEqualToString:@"giantstarType"]) {
        _liveType = @"giantstarType";
        [self requestWithSbean:561000 ebean:1616000 tag:2];
    } else if ([notification.object isEqualToString:@"starType"]) {
        _liveType = @"starType";
        [self requestWithSbean:106000 ebean:561000 tag:3];
    } else if ([notification.object isEqualToString:@"rookieType"]) {
        _liveType = @"rookieType";
        [self requestWithSbean:0 ebean:106000 tag:4];
    }
}

#pragma mark - tableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == 0) {
        UIImageView *imgeviewIcont = [[UIImageView alloc]initWithFrame:CGRectMake(80, 6, 30, 30)];
        imgeviewIcont.image = [UIImage imageNamed:@"quanbu"];
        [cell addSubview:imgeviewIcont];
        
        UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(125, 14, 35, 15)];
        textLabel.text = @"全部";
        textLabel.font = [UIFont systemFontOfSize:15.0f];
        textLabel.textColor = [UIColor whiteColor];
        [cell addSubview:textLabel];
        
        UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(258, 15, 42, 15)];
        [label1 setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"shuzidise"]]];
        label1.text = [NSString stringWithFormat:@"%d",array5.count];
        label1.textColor = [UIColor whiteColor];
        label1.textAlignment = NSTextAlignmentCenter;
        label1.font = [UIFont systemFontOfSize:12.0f];
        [cell addSubview:label1];
        
    } else if (indexPath.row == 1){
        UIImageView *imgeviewIcont1 = [[UIImageView alloc]initWithFrame:CGRectMake(80, 6, 30, 30)];
        imgeviewIcont1.image = [UIImage imageNamed:@"zhuboxingjihuangguan"];
        [cell addSubview:imgeviewIcont1];
        
        UILabel *textLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(125, 14, 35, 15)];
        textLabel1.text = @"超星";
        textLabel1.font = [UIFont systemFontOfSize:15.0f];
        textLabel1.textColor = [UIColor whiteColor];
        [cell addSubview:textLabel1];
        
        UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(258, 15, 42, 15)];
        [label1 setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"shuzidise"]]];
        label1.text = [NSString stringWithFormat:@"%d",array1.count];
        label1.textColor = [UIColor whiteColor];
        label1.textAlignment = NSTextAlignmentCenter;
        label1.font = [UIFont systemFontOfSize:12.0f];
        [cell addSubview:label1];
        
    } else if (indexPath.row == 2) {
        UIImageView *imgeviewIcont1 = [[UIImageView alloc]initWithFrame:CGRectMake(80, 6, 30, 30)];
        imgeviewIcont1.image = [UIImage imageNamed:@"zhuboxingjihuangguan"];
        [cell addSubview:imgeviewIcont1];
        
        UILabel *textLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(125, 14, 35, 15)];
        textLabel1.text = @"巨星";
        textLabel1.font = [UIFont systemFontOfSize:15.0f];
        textLabel1.textColor = [UIColor whiteColor];
        [cell addSubview:textLabel1];
        
        UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(258, 15, 42, 15)];
        [label1 setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"shuzidise"]]];
        label1.text = [NSString stringWithFormat:@"%d",array2.count];
        label1.textColor = [UIColor whiteColor];
        label1.textAlignment = NSTextAlignmentCenter;
        label1.font = [UIFont systemFontOfSize:12.0f];
        [cell addSubview:label1];
        
    } else if (indexPath.row == 3) {
        UIImageView *imgeviewIcont1 = [[UIImageView alloc]initWithFrame:CGRectMake(80, 6, 30, 30)];
        imgeviewIcont1.image = [UIImage imageNamed:@"zuanshi"];
        [cell addSubview:imgeviewIcont1];
        
        UILabel *textLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(125, 14, 35, 15)];
        textLabel1.text = @"明星";
        textLabel1.font = [UIFont systemFontOfSize:15.0f];
        textLabel1.textColor = [UIColor whiteColor];
        [cell addSubview:textLabel1];
        
        UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(258, 15, 42, 15)];
        [label1 setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"shuzidise"]]];
        label1.text = [NSString stringWithFormat:@"%d",array3.count];
        label1.textColor = [UIColor whiteColor];
        label1.textAlignment = NSTextAlignmentCenter;
        label1.font = [UIFont systemFontOfSize:12.0f];
        [cell addSubview:label1];
        
    } else {
        UIImageView *imgeviewIcont1 = [[UIImageView alloc]initWithFrame:CGRectMake(80, 6, 30, 30)];
        imgeviewIcont1.image = [UIImage imageNamed:@"hongxin"];
        [cell addSubview:imgeviewIcont1];
        
        UILabel *textLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(125, 14, 35, 15)];
        textLabel1.text = @"新秀";
        textLabel1.font = [UIFont systemFontOfSize:15.0f];
        textLabel1.textColor = [UIColor whiteColor];
        [cell addSubview:textLabel1];
        
        UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(258, 15, 42, 15)];
        [label1 setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"shuzidise"]]];
        label1.text = [NSString stringWithFormat:@"%lu",(unsigned long)array4.count];
        label1.textColor = [UIColor whiteColor];
        label1.textAlignment = NSTextAlignmentCenter;
        label1.font = [UIFont systemFontOfSize:12.0f];
        [cell addSubview:label1];
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 25;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 25)];
    [self.view addSubview:imageView];
    
    UILabel *headLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 5, 60, 16)];
    headLabel.text = @"直播分类";
    headLabel.textColor = [UIColor whiteColor];
    headLabel.font = [UIFont systemFontOfSize:14.0f];
    [imageView addSubview:headLabel];
    return imageView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    switch (indexPath.row) {
        case 0:
            [dic setObject:dataArr5 forKey:@"allType"];
            break;
        case 1:
            [dic setObject:dataArr1 forKey:@"superstarType"];
            break;
        case 2:
            [dic setObject:dataArr2 forKey:@"giantstarType"];
            break;
        case 3:
            [dic setObject:dataArr3 forKey:@"starType"];
            break;
        case 4:
            [dic setObject:dataArr4 forKey:@"rookieType"];
            break;
        default:
            break;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:REFRESH_NOTFICATION object:nil userInfo:dic];
}

#pragma mark - 数据
- (void)request
{
    NSString *urlStr = [NSString stringWithFormat:@"%@public/room_list",BaseURL];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
    request.delegate = self;
    request.tag = 100;
    [request setTimeOutSeconds:100];
    [request startAsynchronous];
}
- (void)requestWithSbean:(int)sbean ebean:(int)ebean tag:(NSInteger)tag
{
    NSString *urlStr = [NSString stringWithFormat:@"%@public/room_list?page=1&size=20&sbean=%d&ebean=%d&sort=0",BaseURL,sbean,ebean];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
    request.delegate = self;
    request.tag = tag;
    [request setTimeOutSeconds:100];
    [request startAsynchronous];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    id result = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if ([result isKindOfClass:[NSDictionary class]]) {
        switch (request.tag) {
            case 1:
                array1 = [result objectForKey:@"data"];
                if (array1.count) {
                    dataArr1 = [self createDataArrayWithData:array1];
                    if ([_liveType isEqualToString:@"allType"]) {
                        [dic setObject:dataArr1 forKey:_liveType];
                    }
                }
                break;
            case 2:
                array2 = [result objectForKey:@"data"];
                if (array2.count) {
                    dataArr2 = [self createDataArrayWithData:array2];
                    if ([_liveType isEqualToString:@"superstarType"]) {
                        [dic setObject:dataArr1 forKey:_liveType];
                    }
                }
                break;
            case 3:
                array3 = [result objectForKey:@"data"];
                if (array3.count) {
                    dataArr3 = [self createDataArrayWithData:array3];
                    if ([_liveType isEqualToString:@"giantstarType"]) {
                        [dic setObject:dataArr1 forKey:_liveType];
                    }
                }
                break;
            case 4:
                array4 = [result objectForKey:@"data"];
                if (array4.count) {
                    dataArr4 = [self createDataArrayWithData:array4];
                    if ([_liveType isEqualToString:@"starType"]) {
                        [dic setObject:dataArr1 forKey:_liveType];
                    }
                }
                break;
            case 100:
                array5 = [result objectForKey:@"data"];
                if (array5.count) {
                    dataArr5 = [self createDataArrayWithData:array5];
                    if ([_liveType isEqualToString:@"rookieType"]) {
                        [dic setObject:dataArr1 forKey:_liveType];
                    }
                }
                break;
            default:
                break;
        }
        
    }
    [rightTableView reloadData];
}

- (NSMutableArray *)createDataArrayWithData:(NSArray *)allDtJson
{
    NSMutableArray *dataArr = [NSMutableArray array];
    NSMutableArray *allDtJson_mutable = [NSMutableArray array];
    
    for (NSDictionary *dict in allDtJson) {
        AllModel *model = [[AllModel alloc] init];
        [model setValuesForKeysWithDictionary:dict];
        [allDtJson_mutable addObject:model];
    }
    if (allDtJson.count > 0) {
        NSArray *firstRowData = @[[allDtJson_mutable objectAtIndex:0]];
        [dataArr addObject:firstRowData];
        if (allDtJson.count > 3) {
            NSArray *secondRowData = @[[allDtJson_mutable objectAtIndex:1],[allDtJson_mutable objectAtIndex:2]];
            [dataArr addObject:secondRowData];
            
            NSUInteger count = [allDtJson_mutable count];
            NSMutableArray *thirdRowData = [NSMutableArray array];
            for (int i = 0; i < count-3; i++) {
                if (i%3 == 0 && i != 0) {
                    [dataArr addObject:thirdRowData];
                    thirdRowData = [NSMutableArray array];
                }
                [thirdRowData addObject:allDtJson_mutable[i+3]];
            }
            if (thirdRowData.count) {
                [dataArr addObject:thirdRowData];
            }
        }
    }

    return dataArr;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
