//
//  SongViewController.m
//  LoveAnchor
//
//  Created by zhongqinglongtu on 14-12-23.
//  Copyright (c) 2014年 zhongqinglongtu. All rights reserved.
//

#import "SongViewController.h"

@interface SongViewController ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,ASIHTTPRequestDelegate,UIAlertViewDelegate,UITextFieldDelegate>
{
    UIButton        *_leftButton;
    UIButton        *_rightButton;
    UIView          *_lineVIew;
    UIScrollView    *_rootScrollView;
    NSArray         *songListArray;
    UITableView     *leftTabelView;
    UITableView     *rightTabelView;
    LoginModel      *model;
    NSArray         *allArray;
    NSMutableArray  *songNameArray;
    NSMutableArray  *statusArray;
    UIView          *songbagView;
    UIView          *songView;
    UITextField     *nameTextField;
}

@property (nonatomic,strong)UIView *leftView;
@property (nonatomic,strong)UIView *rightView;

@end

@implementation SongViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        songListArray = [NSArray array];
        allArray      = [NSArray array];
        songNameArray = [NSMutableArray array];
        statusArray   = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    model = [CommonUtil getUserModel];
    [self theSongListRequest];
    [self haveSomeSongsRequest];
    self.view.backgroundColor = [UIColor whiteColor];
    [self showUI];
}
#pragma mark - 主界面
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
    [_rightButton setTitle:@"查看已点歌曲" forState:UIControlStateNormal];
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
    
    _rootScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 102, kScreenWidth, kScreenHeight-102)];
    _rootScrollView.contentSize = CGSizeMake(kScreenWidth *2, 0);
    _rootScrollView.showsHorizontalScrollIndicator = NO;
    _rootScrollView.showsVerticalScrollIndicator = NO;
    _rootScrollView.pagingEnabled = YES;
    _rootScrollView.delegate = self;
    [self.view addSubview:_rootScrollView];
    
    self.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, _rootScrollView.frame.size.height)];
    self.leftView.backgroundColor = [UIColor whiteColor];
    [_rootScrollView addSubview:self.leftView];
    [self createLeftView];
    
    self.rightView = [[UIView alloc]initWithFrame:CGRectMake(kScreenWidth, 0, kScreenWidth, _rootScrollView.frame.size.height)];
    self.rightView.backgroundColor = [UIColor whiteColor];
    [_rootScrollView addSubview:self.rightView];
    [self createRightView];
}
#pragma mark - 自选歌曲
- (void)customizeTheSong
{
    songbagView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    songbagView.alpha = 0.5;
    songbagView.backgroundColor = [UIColor blackColor];
    songbagView.hidden = NO;
    [self.view addSubview:songbagView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
    [songbagView addGestureRecognizer:tap];
    
    songView = [[UIView alloc]initWithFrame:CGRectMake(20, 240, kScreenWidth-40, 140)];
    songView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:songView];
    
    UIImageView *songImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, songView.frame.size.width, 30)];
    songImageView.backgroundColor = textFontColor;
    [songView addSubview:songImageView];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, songImageView.frame.size.width, 30)];
    titleLabel.text = @"自选歌曲点唱";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [songImageView addSubview:titleLabel];
    
    UILabel *promptLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 40, 200, 20)];
    promptLabel.text = @"输入您想听的歌曲名称";
    promptLabel.font = [UIFont systemFontOfSize:12];
    [songView addSubview:promptLabel];
    
    UIView *nameView = [[UIView alloc]initWithFrame:CGRectMake(10, 70, songView.frame.size.width-20, 25)];
    nameView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    nameView.layer.borderWidth = 0.3;
    [songView addSubview:nameView];
    
    nameTextField = [[UITextField alloc]initWithFrame:CGRectMake(5, 0, songView.frame.size.width-20, 25)];
    nameTextField.delegate = self;
    nameTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [nameView addSubview:nameTextField];
    
    UIImageView *HXImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 110, songView.frame.size.width, 0.3)];
    HXImageView.backgroundColor = [UIColor lightGrayColor];
    [songView addSubview:HXImageView];
    
    UIButton *QDButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 111, songView.frame.size.width, 30)];
    QDButton.tag = 103;
    [QDButton setTitle:@"确认点歌" forState:UIControlStateNormal];
    [QDButton setTitleColor:textFontColor forState:UIControlStateNormal];
    QDButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [QDButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [songView addSubview:QDButton];
}
#pragma mark - 右菜单
- (void)createRightView
{
    rightTabelView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, self.leftView.frame.size.height) style:UITableViewStylePlain];
    rightTabelView.tag = 100;
    rightTabelView.delegate = self;
    rightTabelView.dataSource = self;
    rightTabelView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    rightTabelView.backgroundColor = [UIColor clearColor];
    [self.rightView addSubview:rightTabelView];

}
#pragma mark -左菜单
- (void)createLeftView
{
    leftTabelView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, self.leftView.frame.size.height-55) style:UITableViewStylePlain];
    leftTabelView.tag = 101;
    leftTabelView.delegate = self;
    leftTabelView.dataSource = self;
    leftTabelView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    leftTabelView.backgroundColor = [UIColor clearColor];
    [self.leftView addSubview:leftTabelView];
    
    UIView *TSView = [[UIView alloc]initWithFrame:CGRectMake(0, self.leftView.frame.size.height-55, kScreenWidth, 55)];
    NSLog(@"eedc == %f",self.leftView.frame.size.height-55);
    TSView.backgroundColor = [UIColor colorWithRed:232/255.0 green:241/255.0 blue:243/255.0 alpha:1];
    [self.leftView addSubview:TSView];
    
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
    CZButton.tag = 101;
    [CZButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [TSView addSubview:CZButton];
    
    UIButton *ZXButton = [[UIButton alloc]initWithFrame:CGRectMake(261, 0, 60, 20)];
    [ZXButton setTitle:@"自选歌曲" forState:UIControlStateNormal];
    [ZXButton setTitleColor:textFontColor forState:UIControlStateNormal];
    ZXButton.titleLabel.font = [UIFont systemFontOfSize:12];
    ZXButton.tag = 102;
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
#pragma mark - 点歌
- (void)buttonLive:(UIButton *)button
{
    NSString *songName = [songListArray objectAtIndex:button.tag];
    [self andSoRequest:songName];
}
#pragma mark - 按钮点击事件处理
- (void)buttonClick:(UIButton *)button
{
    if (button.tag == 100) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else if (button.tag == 101) {
        TopUpViewController *top = [[TopUpViewController alloc]init];
        UINavigationController *nc = [[UINavigationController alloc]initWithRootViewController:top];
        [self presentViewController:nc animated:YES completion:nil];
        
    } else if (button.tag == 102) {
        [self customizeTheSong];
    } else if (button.tag == 103) {
        if (nameTextField.text.length > 0) {
            [self optionalEventfulRequest];
            songbagView.hidden = YES;
            songView.hidden = YES;
        } else {
            UIAlertView *alert = [[UIAlertView alloc]init];
            alert.title = @"提示";
            alert.message = @"请输入歌名！";
            [alert addButtonWithTitle:@"确定"];
            [alert show];
        }
        
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
#pragma mark - 左右滑动方法
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
    if (tableView.tag == 101) {
        NSString *identifier = @"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        UILabel *numberLabel;
        UIButton *songButton;
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(35, 0, 180, 37)];
            songButton = [[UIButton alloc]initWithFrame:CGRectMake(280, 0, 30, 37)];
        }
        cell.textLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row+1];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        numberLabel.text = [NSString stringWithFormat:@"%@",[songListArray objectAtIndex:indexPath.row]];
        numberLabel.font = [UIFont systemFontOfSize:14];
        numberLabel.backgroundColor = [UIColor clearColor];
        [cell addSubview:numberLabel];
        
        [songButton setTitle:@"点歌" forState:UIControlStateNormal];
        [songButton setTitleColor:textFontColor forState:UIControlStateNormal];
        songButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [songButton addTarget:self action:@selector(buttonLive:) forControlEvents:UIControlEventTouchUpInside];
        songButton.tag = indexPath.row;
        [cell addSubview:songButton];
        return cell;
    } else {
        NSString *identifier = @"cellID";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        UILabel *statusLabel;
        UILabel *numberLabel;
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            statusLabel = [[UILabel alloc]initWithFrame:CGRectMake(260, 0, 50, 37)];
            numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(35, 0, 180, 37)];
        }
        cell.textLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row+1];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        numberLabel.text = [NSString stringWithFormat:@"%@",[songNameArray objectAtIndex:indexPath.row]];
        numberLabel.font = [UIFont systemFontOfSize:14];
        numberLabel.backgroundColor = [UIColor clearColor];
        [cell addSubview:numberLabel];
        if ([[statusArray objectAtIndex:indexPath.row] intValue] == 1) {
            statusLabel.text = @"已同意";
        } else if ([[statusArray objectAtIndex:indexPath.row] intValue] == 2) {
            statusLabel.text = @"已拒绝";
        } else {
            statusLabel.text = @"排队中";
        }
        statusLabel.font = [UIFont systemFontOfSize:14];
        statusLabel.backgroundColor = [UIColor clearColor];
        statusLabel.textColor = textFontColor;
        [cell addSubview:statusLabel];
        return cell;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == 101) {
        return songListArray.count;
    } else {
        return songNameArray.count;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}
#pragma mark - 数据
//获得歌曲列表
- (void)theSongListRequest
{
    NSString *urlStr = [NSString stringWithFormat:@"%@show/song_list/%@",BaseURL,self.userId];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
    request.delegate = self;
    request.tag = 100;
    [request setTimeOutSeconds:100];
    [request startAsynchronous];
}
- (void)andSoRequest:(NSString *)songName
{
    NSString* encodedString = [songName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *urlStr = [NSString stringWithFormat:@"%@song/order/%@/%@?song_name=%@",BaseURL,model.access_token,self.live_id,encodedString];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
    request.delegate = self;
    request.tag = 101;
    [request setTimeOutSeconds:100];
    [request startAsynchronous];

}
- (void)haveSomeSongsRequest
{
    NSInteger time = [[NSDate date] timeIntervalSince1970];
    NSLog(@"shijian  == %ld",time*1000);
    NSString *urlStr = [NSString stringWithFormat:@"%@show/order_list/%@",BaseURL,self.live_id];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
    request.delegate = self;
    request.tag = 102;
    [request setTimeOutSeconds:100];
    [request startAsynchronous];
}
- (void)optionalEventfulRequest
{
    NSString* encodedString = [nameTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *urlStr = [NSString stringWithFormat:@"%@song/order/%@/%@?song_name=%@",BaseURL,model.access_token,self.live_id,encodedString];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
    request.delegate = self;
    request.tag = 103;
    [request setTimeOutSeconds:100];
    [request startAsynchronous];
    
}

-(void)requestFinished:(ASIHTTPRequest *)request
{
    id result = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
    if ([result isKindOfClass:[NSDictionary class]]) {
        switch (request.tag) {
            case 100: {
                songListArray = [result objectForKey:@"data"];
                NSLog(@"123 == %@",songListArray);
                [leftTabelView reloadData];
            }
                break;
            case 101: {
                int code = [[result objectForKey:@"code"] intValue];
                NSLog(@"%d",code);
                if (code == 1) {
                    UIAlertView *alert = [[UIAlertView alloc]init];
                    alert.title = @"点歌成功";
                    alert.message = @"请等候主播处理";
                    [alert addButtonWithTitle:@"确定"];
                    [alert show];
                } else if (code == 30412) {
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"购买失败！\n您的金币不足！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"充值", nil];
                    [alert show];
                } else if (code == 31503) {
                    UIAlertView *alert = [[UIAlertView alloc]init];
                    alert.title = @"提示";
                    alert.message = @"直播已结束！";
                    [alert addButtonWithTitle:@"确定"];
                    [alert show];
                }
            }
                break;
            case 102: {
                allArray = [result objectForKey:@"data"];
                for (NSDictionary *dict in allArray) {
                    [songNameArray addObject:[dict objectForKey:@"song_name"]];
                    [statusArray addObject:[dict objectForKey:@"status"]];
                    
                }
                [rightTabelView reloadData];
            }
                break;
            case 103: {
                id code = [result objectForKey:@"code"];
                if ([code intValue] == 1) {
                    UIAlertView *alert = [[UIAlertView alloc]init];
                    alert.title = @"点歌成功";
                    alert.message = @"请等候主播处理";
                    [alert addButtonWithTitle:@"确定"];
                    [alert show];
                }
            }
                break;
            default:
                break;
        }
    }
}
#pragma mark - alertView代理
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        TopUpViewController *top = [[TopUpViewController alloc]init];
        UINavigationController *nc = [[UINavigationController alloc]initWithRootViewController:top];
        [self presentViewController:nc animated:YES completion:nil];
    }
}
- (void)tapClick:(UITapGestureRecognizer *)tap
{
    songbagView.hidden = YES;
    songView.hidden = YES;
    [nameTextField resignFirstResponder];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    songView.frame = CGRectMake(20, 240, kScreenWidth-40, 140);
    [textField resignFirstResponder];
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    songView.frame = CGRectMake(20, 210, kScreenWidth-40, 140);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
