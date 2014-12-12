//
//  PlayViewController.m
//  LoveAnchor
//
//  Created by zhongqinglongtu on 14-9-18.
//  Copyright (c) 2014年 zhongqinglongtu. All rights reserved.
//

#import "PlayViewController.h"
#import "SocketIO.h"
#import "SocketIOPacket.h"
#import "SocketIOJSONSerialization.h"
#import "ChatCell.h"
#import "ChatModel.h"
#import "NSString+TrimmingAdditions.h"
#import "RankCell.h"

@interface PlayViewController () <VMediaPlayerDelegate, UITextFieldDelegate, SocketIODelegate, ASIHTTPRequestDelegate>

{
    UIScrollView *_scrollView;
    //导航
    UIView *_navView;
    
    //视频部分
    UIImageView *_liveView;
    //升级
    UIImageView *_upgradeView;
    //羽毛
    UIImageView *_yumaoView;
    //主播详情
    UIView *_classifyView;
    BOOL tap;
    //button背景
    UIImageView *_backImageView;
    //综合
    UIButton *synthesizeButton;
    //公聊
    UIButton *publicButton;
    //私聊
    UIButton *privateButton;
    //观众
    UIButton *audienceButton;
    //抢沙发
    UIView *_sofaView;
    //聊天输入框
    UITextField *_chatTextField;
    VMediaPlayer *mMPayer;
    //视频背景
    UIImageView *bagView;
    //下半部的背景VIew
    UIView *View;
    //关闭视频
    UIButton *bearButton;
    //聊天背景
    UIView *chatView;
    SocketIO *_socketIO;
    //观众榜里的button
    UIView *announcementView;
    //判断观众榜的左右滑动
    UIImageView *announcementImageView;
    //观众榜
    UIScrollView *audienceScrollView;
    //本场观众
    UIButton *homeCourseButton;
    //月榜
    UIButton *monthButton;
    //总榜
    UIButton *alwaysButton;
}

@property (nonatomic, strong) UIActivityIndicatorView *activityView;
@property (nonatomic, strong) NSURL                   *videoURL;
//综合
@property (nonatomic, strong) UITableView             *synthesizeTableView;
//公聊
@property (nonatomic, strong) UITableView             *publicTableView;
//私聊
@property (nonatomic, strong) UITableView             *privateTableView;
//综合
@property (nonatomic, strong) NSMutableArray          *dataArray;
//公聊
@property (nonatomic, strong) NSMutableArray          *publicDataArray;
//私聊
@property (nonatomic, strong) NSMutableArray          *privateArray;
//本场观众榜
@property (nonatomic, strong) UITableView             *homeCourseTableView;
//月榜
@property (nonatomic, strong) UITableView             *monthTableView;
//总榜
@property (nonatomic, strong) UITableView             *alwaysTableView;
//本场观众榜
@property (nonatomic, strong) NSMutableArray          *homeCourseArray;
//月榜
@property (nonatomic, strong) NSMutableArray          *monthArray;
//总榜
@property (nonatomic, strong) NSMutableArray          *alwaysArray;

@end

@implementation PlayViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    LoginModel *model = [CommonUtil getUserModel];
    _dataArray = [[NSMutableArray alloc] init];
    _publicDataArray = [[NSMutableArray alloc] init];
    _privateArray = [[NSMutableArray alloc] init];
    _homeCourseArray = [[NSMutableArray alloc] init];
    _monthArray = [[NSMutableArray alloc] init];
    _alwaysArray = [[NSMutableArray alloc] init];
    
    _socketIO = [[SocketIO alloc] initWithDelegate:self];
    
    //socket
    if (model) {
        NSDictionary *dic = @{@"room_id": self.allModel._id,
                              @"access_token": model.access_token};
        [_socketIO connectToHost:BaseHost onPort:80 withParams:dic];
    }
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self shouwUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self requestWithParam:@"room_user_live" tag:500];
    [self requestWithParam:@"room_user_month" tag:501];
    [self requestWithParam:@"room_user_total" tag:502];

//    NSString *url = @"http://v.17173.com/api/5981245-4.m3u8";
    NSString *url = [NSString stringWithFormat:@"rtmp://ttvpull.izhubo.com/live/%@",self.allModel._id];
    self.videoURL = [NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    [mMPayer setDataSource:self.videoURL];
    [mMPayer prepareAsync];
    [self.activityView setHidden:NO];
    [self.activityView startAnimating];
}

#pragma mark - shouUI
- (void)shouwUI
{
    //视频播放
    _liveView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 20, kScreenWidth, 240)];
    _liveView.userInteractionEnabled = YES;
    tap = NO;
    _liveView.backgroundColor = [UIColor colorWithRed:211.0/255.0 green:195.0/255.0 blue:29.0/255.0 alpha:1.0];
    [self.view addSubview:_liveView];
    
    _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:
                     UIActivityIndicatorViewStyleWhiteLarge];
    [_activityView setFrame:CGRectMake(kScreenWidth/2, 120, 10, 10)];
    [_liveView addSubview:_activityView];
    
    if (!mMPayer) {
        mMPayer = [VMediaPlayer sharedInstance];
        [mMPayer setupPlayerWithCarrierView:_liveView withDelegate:self];
        [self setupObservers];
    }
    
    //点击视频播放区域手势
    UITapGestureRecognizer *tapdesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(liveClick:)];
    [_liveView addGestureRecognizer:tapdesture];
    
    //视频背景
    bagView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 160)];
    bagView.image = [UIImage imageNamed:@"guanbishipin"];
    bagView.hidden = YES;
    [_liveView addSubview:bagView];
    
    UIImageView *headImage = [[UIImageView alloc]initWithFrame:CGRectMake(125, 30, 70, 70)];
    headImage.image = [UIImage imageNamed:@"touxiangquan"];
    [bagView addSubview:headImage];
    
    //升级
    _upgradeView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 40, 110, 32)];
    _upgradeView.image = [UIImage imageNamed:@"shengji"];
    _upgradeView.hidden = YES;
    [_liveView addSubview:_upgradeView];
    
    UILabel *shengjiLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 8, 80, 16)];
    shengjiLabel.text = [NSString stringWithFormat:@"差%d经验升级",25541];
    shengjiLabel.font = [UIFont systemFontOfSize:10];
    [_upgradeView addSubview:shengjiLabel];
    //羽毛
    _yumaoView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 10, 33, 32)];
    _yumaoView.image = [UIImage imageNamed:@"yumao"];
    [_liveView addSubview:_yumaoView];
    
    UILabel *quantityLabel = [[UILabel alloc]initWithFrame:CGRectMake(13, 20, 18, 7)];
    quantityLabel.text = @"12222";
    quantityLabel.font = [UIFont systemFontOfSize:6];
    [_yumaoView addSubview:quantityLabel];
    
    //导航
    _navView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, kScreenWidth, 35)];
    _navView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.8];
    _navView.hidden = YES;
    [self.view addSubview:_navView];
    
    UILabel *navLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 0, 200, 35)];
    navLabel.text = [NSString stringWithFormat:@"%@",self.allModel.nick_name];
    navLabel.textColor = textFontColor;
    navLabel.font = [UIFont systemFontOfSize:15];
    navLabel.textAlignment = NSTextAlignmentLeft;
    [_navView addSubview:navLabel];
    
    UIImageView *gradeView = [[UIImageView alloc]initWithFrame:CGRectMake(190, 5, 25, 25)];
    gradeView.image = [UIImage imageNamed:@"sanxin"];
    [_navView addSubview:gradeView];
    
    UIButton *returnButton = [UIButton buttonWithType:UIButtonTypeCustom];
    returnButton.frame = CGRectMake(0, 0, 30, 35);
    returnButton.tag = 100;
    [returnButton setImage:[UIImage imageNamed:@"guanbi"] forState:UIControlStateNormal];
    [returnButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_navView addSubview:returnButton];
    
    UIButton *attentionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    attentionButton.frame = CGRectMake(275, 0, 20, 35);
    attentionButton.tag = 101;
    [attentionButton setImage:[UIImage imageNamed:@"shoucang"] forState:UIControlStateNormal];
    [attentionButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_navView addSubview:attentionButton];
    
    UIButton *classifyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    classifyButton.frame = CGRectMake(300, 0, 15, 35);
    classifyButton.tag = 102;
    [classifyButton setImage:[UIImage imageNamed:@"zhuboxiangqing"] forState:UIControlStateNormal];
    [classifyButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_navView addSubview:classifyButton];

    //主播详情
    _classifyView = [[UIView alloc]initWithFrame:CGRectMake(225, 34, 94, 110)];
    _classifyView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.8];
    _classifyView.userInteractionEnabled = YES;
    _classifyView.hidden = YES;
    [_liveView addSubview:_classifyView];

    //关闭视频
    bearButton = [UIButton buttonWithType:UIButtonTypeCustom];
    bearButton.frame = CGRectMake(280, 200, 35, 35);
    [bearButton setImage:[UIImage imageNamed:@"shipinguanbi"] forState:UIControlStateNormal];
    bearButton.tag = 1000;
    [bearButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_liveView addSubview:bearButton];
    
    //---------------------------------------------------------------------------
    //下半部的背景VIew
    View = [[UIView alloc]initWithFrame:CGRectMake(0, 260, kScreenWidth, kScreenHeight-260)];
    View.backgroundColor = [UIColor clearColor];
    View.userInteractionEnabled = YES;
    [self.view addSubview:View];
    //button背景
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 28)];
    imageView.backgroundColor = [UIColor whiteColor];
    imageView.userInteractionEnabled = YES;
    [View addSubview:imageView];
    
    UIImageView *HXImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 27.5, kScreenWidth, 0.5)];
    HXImageView.backgroundColor = [UIColor lightGrayColor];
    [imageView addSubview:HXImageView];
    
    //判断button点击的是哪个
    _backImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 27, 62, 1)];
    _backImageView.backgroundColor = [UIColor clearColor];
    [imageView addSubview:_backImageView];
    
    synthesizeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    synthesizeButton.frame = CGRectMake(0, 0, 62, 28);
    synthesizeButton.selected = YES;
    synthesizeButton.tag = 0;
    synthesizeButton.backgroundColor = textFontColor;
    [synthesizeButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [synthesizeButton setTitle:@"综合" forState:UIControlStateNormal];
    [synthesizeButton setTitleColor:textFontColor forState:UIControlStateNormal];
    [synthesizeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [synthesizeButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    synthesizeButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [imageView addSubview:synthesizeButton];
    
    publicButton = [UIButton buttonWithType:UIButtonTypeCustom];
    publicButton.frame = CGRectMake(62, 0, 62, 28);
    publicButton.tag = 1;
    [publicButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [publicButton setTitle:@"公聊" forState:UIControlStateNormal];
    [publicButton setTitleColor:textFontColor forState:UIControlStateNormal];
    [publicButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [publicButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    publicButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [imageView addSubview:publicButton];
    
    privateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    privateButton.frame = CGRectMake(124, 0, 62, 28);
    privateButton.tag = 2;
    [privateButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [privateButton setTitle:@"私聊" forState:UIControlStateNormal];
    [privateButton setTitleColor:textFontColor forState:UIControlStateNormal];
    [privateButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [privateButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    privateButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [imageView addSubview:privateButton];
    
    audienceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    audienceButton.frame = CGRectMake(186, 0, 134, 28);
    audienceButton.tag = 3;
    [audienceButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [audienceButton setTitle:[NSString stringWithFormat:@"观众榜(%d)",3456] forState:UIControlStateNormal];
    [audienceButton setTitleColor:textFontColor forState:UIControlStateNormal];
    [audienceButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [audienceButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    audienceButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [imageView addSubview:audienceButton];

    //4个聊天界面
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 28, kScreenWidth, kScreenHeight-333)];
    _scrollView.contentSize = CGSizeMake(kScreenWidth *4, kScreenHeight-333);
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    [View addSubview:_scrollView];
    //综合
    _synthesizeTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, _scrollView.frame.size.height) style:UITableViewStylePlain];
    _synthesizeTableView.tag = 1000;
    _synthesizeTableView.delegate = self;
    _synthesizeTableView.dataSource = self;
    _synthesizeTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [_scrollView addSubview:_synthesizeTableView];
    //公聊
    _publicTableView = [[UITableView alloc]initWithFrame:CGRectMake(kScreenWidth, 0, kScreenWidth, _scrollView.frame.size.height) style:UITableViewStylePlain];
    _publicTableView.tag = 1001;
    _publicTableView.delegate = self;
    _publicTableView.dataSource = self;
    _publicTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [_scrollView addSubview:_publicTableView];
    //私聊
    _privateTableView = [[UITableView alloc]initWithFrame:CGRectMake(kScreenWidth*2, 0, kScreenWidth, _scrollView.frame.size.height) style:UITableViewStylePlain];
    _privateTableView.tag = 1002;
    _privateTableView.delegate = self;
    _privateTableView.dataSource = self;
    _privateTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [_scrollView addSubview:_privateTableView];
    //聊天框背景
    chatView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight-45, kScreenWidth, 45)];
    chatView.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1];
    [self.view addSubview:chatView];
    //聊天框
    _chatTextField = [[UITextField alloc]initWithFrame:CGRectMake(5, 5, 260, 35)];
    _chatTextField.backgroundColor = [UIColor whiteColor];
    _chatTextField.borderStyle = UITextBorderStyleNone;
    _chatTextField.delegate = self;
    [chatView addSubview:_chatTextField];
    //礼物按钮
    UIButton *giftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    giftButton.frame = CGRectMake(270, 12.5, 20, 20);
    giftButton.tag = 103;
    [giftButton setImage:[UIImage imageNamed:@"liwu"] forState:UIControlStateNormal];
    [giftButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [chatView addSubview:giftButton];
    //信息档案
    UIButton *manageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    manageButton.frame = CGRectMake(295, 12.5, 15, 20);
    manageButton.tag = 104;
    [manageButton setImage:[UIImage imageNamed:@"zhuboxiangqing"] forState:UIControlStateNormal];
    [manageButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [chatView addSubview:manageButton];

    //观众榜
    audienceScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(kScreenWidth*3, 0, kScreenWidth, _scrollView.frame.size.height)];
    audienceScrollView.contentSize = CGSizeMake(kScreenWidth *3, 0);
    audienceScrollView.showsHorizontalScrollIndicator = NO;
    audienceScrollView.showsVerticalScrollIndicator = NO;
    audienceScrollView.pagingEnabled = YES;
    audienceScrollView.delegate = self;
    audienceScrollView.tag = 100;
    [_scrollView addSubview:audienceScrollView];
    //本场观众
    _homeCourseTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, _scrollView.frame.size.height) style:UITableViewStylePlain];
    _homeCourseTableView.tag = 600;
    _homeCourseTableView.delegate = self;
    _homeCourseTableView.dataSource = self;
    _homeCourseTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [audienceScrollView addSubview:_homeCourseTableView];
    //月榜
    _monthTableView = [[UITableView alloc]initWithFrame:CGRectMake(kScreenWidth, 0, kScreenWidth, _scrollView.frame.size.height) style:UITableViewStylePlain];
    _monthTableView.tag = 601;
    _monthTableView.delegate = self;
    _monthTableView.dataSource = self;
    _monthTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [audienceScrollView addSubview:_monthTableView];
    //总榜
    _alwaysTableView = [[UITableView alloc]initWithFrame:CGRectMake(kScreenWidth*2  , 0, kScreenWidth, _scrollView.frame.size.height) style:UITableViewStylePlain];
    _alwaysTableView.tag = 602;
    _alwaysTableView.delegate = self;
    _alwaysTableView.dataSource = self;
    _alwaysTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [audienceScrollView addSubview:_alwaysTableView];
    //button背景
    announcementView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight-30, kScreenWidth, 30)];
    announcementView.userInteractionEnabled = YES;
    announcementView.hidden = YES;
    announcementView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:announcementView];
    //点击button的判断背景
    announcementImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 29, 106, 1)];
    announcementImageView.backgroundColor = [UIColor redColor];
    [announcementView addSubview:announcementImageView];
    //本场观众
    homeCourseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    homeCourseButton.frame = CGRectMake(0, 0, 120, 30);
    homeCourseButton.tag = 105;
    [homeCourseButton setTitle:@"本场观众榜" forState:UIControlStateNormal];
    [homeCourseButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [homeCourseButton setBackgroundColor:[UIColor colorWithRed:228/255.0 green:105./255.0 blue:80/255.0 alpha:1]];
    [homeCourseButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [announcementView addSubview:homeCourseButton];
    //月榜
    monthButton = [UIButton buttonWithType:UIButtonTypeCustom];
    monthButton.frame = CGRectMake(120, 0, 100, 30);
    monthButton.tag = 106;
    [monthButton setTitle:@"月榜" forState:UIControlStateNormal];
    [monthButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [monthButton setBackgroundColor:[UIColor colorWithRed:245/255.0 green:146/255.0 blue:123/255.0 alpha:1]];
    [monthButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [announcementView addSubview:monthButton];
    //总榜
    alwaysButton = [UIButton buttonWithType:UIButtonTypeCustom];
    alwaysButton.frame = CGRectMake(220, 0, 100, 30);
    alwaysButton.tag = 107;
    [alwaysButton setTitle:@"总榜" forState:UIControlStateNormal];
    [alwaysButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [alwaysButton setBackgroundColor:[UIColor colorWithRed:253/255.0 green:193/255.0 blue:176/255.0 alpha:1]];
    [alwaysButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [announcementView addSubview:alwaysButton];
    
    //抢沙发
    _sofaView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight- 130, kScreenWidth, 130)];
    _sofaView.backgroundColor = [UIColor blackColor];
    _sofaView.hidden = YES;
    _sofaView.alpha = 0.6;
    [self.view addSubview:_sofaView];
    
    for (int i = 0; i < 4; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(i*80, 0, _sofaView.frame.size.width/4, _sofaView.frame.size.height);
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_sofaView addSubview:button];
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, 80, 15)];
        titleLabel.text = @"虚位以待";
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont systemFontOfSize:12];
        [button addSubview:titleLabel];
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(7.5, 30, 65, 65)];
        imageView.image = [UIImage imageNamed:@"xuweiyidai"];
        [button addSubview:imageView];
        
        UIImageView *QImageView = [[UIImageView alloc]initWithFrame:CGRectMake(21, 100, 38, 18)];
        QImageView.image = [UIImage imageNamed:@"qiangzuo"];
        [button addSubview:QImageView];
    }

}
/**********************************************************************************************************/

#pragma mark - 点击事件
- (void)buttonClick:(UIButton *)button
{
    NSLog(@"1");
    if (button.tag == 100) {
        [mMPayer reset];
        [mMPayer unSetupPlayer];
        [self dismissViewControllerAnimated:YES completion:nil];
    } else if (button.tag == 101) {
        
    } else if (button.tag == 102) {
        if (_classifyView.hidden) {
            _classifyView.hidden = NO;
        }else {
            _classifyView.hidden = YES;
        }
    } else if (button.tag == 1000) {
        if (button.selected) {
            bearButton.frame = CGRectMake(280, 200, 35, 35);
            [button setImage:[UIImage imageNamed:@"shipinguanbi"] forState:UIControlStateNormal];
            button.selected = NO;
            bagView.hidden = YES;
            View.frame = CGRectMake(0, kScreenHeight-308, kScreenWidth, kScreenHeight-260);
            _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 28, kScreenWidth, kScreenHeight-333)];
            _scrollView.contentSize = CGSizeMake(kScreenWidth *4, kScreenHeight-333);
        } else {
            bearButton.frame = CGRectMake(280, 120, 35, 35);
           [button setImage:[UIImage imageNamed:@"shipin"] forState:UIControlStateNormal];
            button.selected = YES;
            bagView.hidden = NO;
            View.frame = CGRectMake(0, kScreenHeight-388, kScreenWidth, kScreenHeight-180);
            _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 28, kScreenWidth, kScreenHeight-253)];
            _scrollView.contentSize = CGSizeMake(kScreenWidth *4, kScreenHeight-253);
        }
    } else {
        NSLog(@"%ld",(long)button.tag);
        if (button.selected) {
            return;
        }
        synthesizeButton.selected = NO;
        publicButton.selected = NO;
        privateButton.selected = NO;
        audienceButton.selected = NO;
        button.selected = YES;
        [UIView animateWithDuration:0 animations:^{
            _scrollView.contentOffset = CGPointMake(kScreenWidth*button.tag, 0);
            [self changed];
            
        }];
    }

}

#pragma mark - 点击播放界面方法
- (void)liveClick:(UITapGestureRecognizer *)sender
{
    if (tap) {
        NSLog(@"123");
        _navView.hidden = YES;
        _upgradeView.hidden = YES;
        _classifyView.hidden = YES;
        _sofaView.hidden = YES;
        _yumaoView.frame = CGRectMake(5, 10, 33, 32);
        tap = NO;
    } else {
        NSLog(@"345");
        _navView.hidden = NO;
        _upgradeView.hidden = NO;
        _sofaView.hidden = NO;
        _yumaoView.frame = CGRectMake(5, 73, 33, 32);
        tap = YES;
    }
}
/**********************************************************************************************************/

#pragma mark - scrollView滑动代理
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView.tag == 100) {
        [self announcementchanged];
    }else {
        [UIView animateWithDuration:0 animations:^{
            [self changed];
        }];
    }
}

- (void)announcementchanged
{
    CGRect rect = announcementImageView.frame;
    rect.origin.x = audienceScrollView.contentOffset.x/4;
    NSLog(@"ffffff = %f",rect.origin.x);
    announcementImageView.frame = rect;
    if (rect.origin.x == 0) {
        [homeCourseButton setBackgroundColor:[UIColor colorWithRed:228/255.0 green:105./255.0 blue:80/255.0 alpha:1]];
        [monthButton setBackgroundColor:[UIColor colorWithRed:245/255.0 green:146/255.0 blue:123/255.0 alpha:1]];
        [alwaysButton setBackgroundColor:[UIColor colorWithRed:253/255.0 green:193/255.0 blue:176/255.0 alpha:1]];
        alwaysButton.frame = CGRectMake(220, 0, 100, 30);
        monthButton.frame = CGRectMake(120, 0, 100, 30);
        homeCourseButton.frame = CGRectMake(0, 0, 120, 30);
    }else if (rect.origin.x == 80) {
        [homeCourseButton setBackgroundColor:[UIColor colorWithRed:253/255.0 green:193/255.0 blue:176/255.0 alpha:1]];
        [monthButton setBackgroundColor:[UIColor colorWithRed:228/255.0 green:105./255.0 blue:80/255.0 alpha:1]];
        [alwaysButton setBackgroundColor:[UIColor colorWithRed:245/255.0 green:146/255.0 blue:123/255.0 alpha:1]];
        alwaysButton.frame = CGRectMake(220, 0, 100, 30);
        monthButton.frame = CGRectMake(100, 0, 120, 30);
        homeCourseButton.frame = CGRectMake(0, 0, 100, 30);
    }else {
        [homeCourseButton setBackgroundColor:[UIColor colorWithRed:245/255.0 green:146/255.0 blue:123/255.0 alpha:1]];
        [monthButton setBackgroundColor:[UIColor colorWithRed:253/255.0 green:193/255.0 blue:176/255.0 alpha:1]];
        [alwaysButton setBackgroundColor:[UIColor colorWithRed:228/255.0 green:105./255.0 blue:80/255.0 alpha:1]];
        alwaysButton.frame = CGRectMake(200, 0, 120, 30);
        monthButton.frame = CGRectMake(100, 0, 100, 30);
        homeCourseButton.frame = CGRectMake(0, 0, 100, 30);
    }
}

- (void)changed
{
    CGRect rect = _backImageView.frame;
    rect.origin.x = _scrollView.contentOffset.x/4;
    NSLog(@"ffffff = %f",rect.origin.x);
    _backImageView.frame = rect;
    synthesizeButton.selected = NO;
    publicButton.selected = NO;
    privateButton.selected = NO;
    audienceButton.selected = NO;
    if (rect.origin.x == 0) {
        synthesizeButton.selected = YES;
        synthesizeButton.backgroundColor = textFontColor;
        audienceButton.backgroundColor = [UIColor clearColor];
        publicButton.backgroundColor = [UIColor clearColor];
        privateButton.backgroundColor = [UIColor clearColor];
        announcementView.hidden = YES;
        chatView.hidden = NO;
    } else if (rect.origin.x == 80) {
        publicButton.selected = YES;
        publicButton.backgroundColor = textFontColor;
        audienceButton.backgroundColor = [UIColor clearColor];
        privateButton.backgroundColor = [UIColor clearColor];
        synthesizeButton.backgroundColor = [UIColor clearColor];
        announcementView.hidden = YES;
        chatView.hidden = NO;
    } else if (rect.origin.x == 160) {
        privateButton.selected = YES;
        privateButton.backgroundColor = textFontColor;
        audienceButton.backgroundColor = [UIColor clearColor];
        publicButton.backgroundColor = [UIColor clearColor];
        synthesizeButton.backgroundColor = [UIColor clearColor];
        announcementView.hidden = YES;
        chatView.hidden = NO;
    } else if (rect.origin.x == 240){
        audienceButton.selected = YES;
        audienceButton.backgroundColor = textFontColor;
        publicButton.backgroundColor = [UIColor clearColor];
        privateButton.backgroundColor = [UIColor clearColor];
        synthesizeButton.backgroundColor = [UIColor clearColor];
        chatView.hidden = YES;
        announcementView.hidden = NO;
    }
}

#pragma mark - UITableViewDataSource methods
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (tableView.tag) {
        case 1000: {    //综合
            ChatCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChatCell"];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"ChatCell" owner:self options:nil] lastObject];
            }
            ChatModel *chatModel = [_dataArray objectAtIndex:indexPath.row];
            switch (chatModel.chatType) {
                case contentType:
                case tellTAType:
                    [cell loadContentWithModel:chatModel];
                    break;
                case changeType:
                case featherType:
                case giftType:
                    [cell loadChangeWithModel:chatModel];
                    break;
                default:
                    break;
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
            break;
        case 1001: {    //公聊
            ChatCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChatCell"];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"ChatCell" owner:self options:nil] lastObject];
            }
            ChatModel *chatModel = [_publicDataArray objectAtIndex:indexPath.row];
            [cell loadContentWithModel:chatModel];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
            break;
        case 1002: {    //私聊
            
        }
            break;
        case 600: {     //本场观众
            RankCell *rankCell = [tableView dequeueReusableCellWithIdentifier:@"RankCell"];
            if (rankCell == nil) {
                rankCell = [[[NSBundle mainBundle] loadNibNamed:@"RankCell" owner:self options:nil] lastObject];
            }
            RankingModel *rankModel = [_homeCourseArray objectAtIndex:indexPath.row];
            [rankCell loadDataWithRankModel:rankModel];
            rankCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return rankCell;
        }
            break;
        case 601: {     //月榜
            RankCell *rankCell = [tableView dequeueReusableCellWithIdentifier:@"RankCell"];
            if (rankCell == nil) {
                rankCell = [[[NSBundle mainBundle] loadNibNamed:@"RankCell" owner:self options:nil] lastObject];
            }
            RankingModel *rankModel = [_monthArray objectAtIndex:indexPath.row];
            [rankCell loadDataWithRankModel:rankModel];
            rankCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return rankCell;
        }
            break;
        case 602: {     //总榜
            RankCell *rankCell = [tableView dequeueReusableCellWithIdentifier:@"RankCell"];
            if (rankCell == nil) {
                rankCell = [[[NSBundle mainBundle] loadNibNamed:@"RankCell" owner:self options:nil] lastObject];
            }
            RankingModel *rankModel = [_alwaysArray objectAtIndex:indexPath.row];
            [rankCell loadDataWithRankModel:rankModel];
            rankCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return rankCell;
        }
            break;
        default:
            break;
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (tableView.tag) {
        case 1000:
            return _dataArray.count;
            break;
        case 1001:
            return _publicDataArray.count;
            break;
        case 1002:
            return _privateArray.count;
            break;
        case 600:
            return _homeCourseArray.count;
            break;
        case 601:
            return _monthArray.count;
            break;
        case 602:
            return _alwaysArray.count;
            break;
        default:
            break;
    }
    return 0;
}

#pragma mark - UITableViewDelegate methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (tableView.tag) {
        case 1000: {
            ChatModel *chatModel = [_dataArray objectAtIndex:indexPath.row];
            switch (chatModel.chatType) {
                case contentType:
                case tellTAType: {
                    CGRect rect = [chatModel.content boundingRectWithSize:CGSizeMake(294.0, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0]} context:nil];
                    return rect.size.height + 30.0;
                }
                    break;
                case changeType:
                case featherType:
                case giftType:
                    return 26.0;
                    break;
                default:
                    return 44.0;
                    break;
            }
        }
            break;
        case 1001: {
            ChatModel *chatModel = [_publicDataArray objectAtIndex:indexPath.row];
            CGRect rect = [chatModel.content boundingRectWithSize:CGSizeMake(304.0, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0]} context:nil];
            return rect.size.height + 30.0;
        }
            break;
        case 1002: {
            
        }
            break;
        case 600: {
            return 44.0;
        }
            break;
        case 601: {
            
        }
            break;
        case 602: {
            
        }
            break;
        default:
            break;
    }
    
    return 0.0;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_chatTextField resignFirstResponder];
}
#pragma mark - 后台运行
- (void)setupObservers
{
    NSNotificationCenter *def = [NSNotificationCenter defaultCenter];
    [def addObserver:self
            selector:@selector(applicationDidEnterForeground:)
                name:UIApplicationDidBecomeActiveNotification
              object:[UIApplication sharedApplication]];
    [def addObserver:self
            selector:@selector(applicationDidEnterBackground:)
                name:UIApplicationWillResignActiveNotification
              object:[UIApplication sharedApplication]];
}

- (void)applicationDidEnterForeground:(NSNotification *)notification
{
    [mMPayer setVideoShown:YES];
    if (![mMPayer isPlaying]) {
        [mMPayer setDataSource:self.videoURL];
        [mMPayer prepareAsync];
        [self.activityView setHidden:NO];
    }
}

- (void)applicationDidEnterBackground:(NSNotification *)notification
{
    if ([mMPayer isPlaying]) {
        [mMPayer reset];
        [mMPayer setVideoShown:NO];
    }
}

#pragma mark VMediaPlayerDelegate Implement / Required

- (void)mediaPlayer:(VMediaPlayer *)player didPrepared:(id)arg
{
    [self.activityView setHidden:YES];
    [player start];
}

- (void)mediaPlayer:(VMediaPlayer *)player playbackComplete:(id)arg
{
    
    
}

- (void)mediaPlayer:(VMediaPlayer *)player error:(id)arg
{
    [self.activityView setHidden:YES];
}

# pragma mark - socket.IO-objc delegate methods
- (void)socketIODidConnect:(SocketIO *)socket
{
    NSLog(@"socket.io connected.");
}
/*
 {"content":"/给力","level":7,"from_medals":{},"from":{"_id":11157909,"spend":120996,"nick_name":"快乐仙","priv":3,"s":"","medal_list":[]},"room_id":12700590,"etime":1418033100591}
 
 {"content":"亏死了","level":10,"from_medals":{"1":1418202588407},"to":{"private":false,"_id":12695998,"nick_name":"小贝贝","level":2,"vip":0,"priv":3},"from":{"_id":12256761,"spend":397151,"nick_name":"0014&clubs;十四爷失忆了","priv":3,"s":"","vip":2,"car":16,"medal_list":["1"],"vip_hiding":0},"room_id":12695998,"etime":1418191732714}
 
 {"action":"room.change","data_d":{"_id":13225491,"spend":0,"nick_name":"一切在无言中","priv":3,"s":"","medal_list":[]}}
 
 {"action":"gift.notify","data_d":{"from":{"_id":12843524,"nick_name":"华冉","priv":3,"finance":{"coin_spend_total":14362},"qd":"ttxy"},"to":{"_id":10265417,"nick_name":"青楼、风尘女子","priv":2,"finance":{"bean_count_total":2412676,"coin_spend_total":70509}},"gift":{"_id":138,"name":"奔驰跑车","count":1,"coin_price":6000},"room_id":10265417,"win_coin":[]}}
 
 {"action":"gift.marquee","data_d":{"from":{"_id":12843524,"nick_name":"华冉","finance":{"coin_spend_total":20362,"bean_count_total":0}},"to":{"_id":10265417,"nick_name":"青楼、风尘女子","priv":2,"finance":{"bean_count_total":2412676,"coin_spend_total":70509}},"gift":{"_id":138,"name":"奔驰跑车","count":1},"room_id":10265417,"t":1418111245286}}
 
 {"action":"gift.feather","data_d":{"_id":11663047,"nick_name":"ミ忆&rarr;傷.","user":{"_id":11663047,"nick_name":"ミ忆&rarr;傷.","priv":3,"finance":{"feather_send_total":33,"coin_spend_total":33},"qd":"ttxy"}}}
 
 {"action":"room.star","data_d":{"_id":13165230,"nick_name":"小小叮当","finance":{"bean_count_total":169373,"feather_receive_total":774,"coin_spend_total":54},"star":{"room_id":13165230},"pic":"http://ttimg.app1101168695.twsapp.com/46/6/13165230_0_200200.jpg?v=548_548_1417776204762","followers":194}}
 
 {"action":"manage.shutup","data_d":{"xy_user_id":13025690,"nick_name":"有钱难买我愿意","f_id":12539754,"f_name":"淡淡的忧伤；淡淡的怀念","minute":720}}
 */
- (void)socketIO:(SocketIO *)socket didReceiveMessage:(SocketIOPacket *)packet
{
    NSLog(@"didReceiveMessage()");
    id result = packet.dataAsJSON;
    if ([result isKindOfClass:[NSDictionary class]]) {
        ChatModel *chatModel = [[ChatModel alloc] init];
        NSString *action = [result objectForKey:@"action"];
        if (action.length) {
            if ([action isEqualToString:@"room.change"]) {
                chatModel.chatType = changeType;
                id data_d = [result objectForKey:@"data_d"];
                if ([data_d isKindOfClass:[NSDictionary class]]) {
                    NSString *nick_name = [[data_d objectForKey:@"nick_name"] stringByTrimmingLeftCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                    if (nick_name.length) {
                        chatModel.nick_name = nick_name;
                    }
                }
                [self reloadDataWithTableView:_synthesizeTableView dataArray:_dataArray chatModel:chatModel];
            } else if ([action isEqualToString:@"gift.notify"]) {
                chatModel.chatType = giftType;
                id data_d = [result objectForKey:@"data_d"];
                if ([data_d isKindOfClass:[NSDictionary class]]) {
                    NSDictionary *fromDic = [data_d objectForKey:@"from"];
                    NSString *fromNick = [[fromDic objectForKey:@"nick_name"] stringByTrimmingLeftCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                    if (fromNick.length) {
                        chatModel.nick_name = fromNick;
                    }
                    NSDictionary *toDic = [data_d objectForKey:@"to"];
                    NSString *toNick = [[toDic objectForKey:@"nick_name"] stringByTrimmingLeftCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                    if (toNick.length) {
                        chatModel.toNick_name = toNick;
                    }
                    NSDictionary *giftDic = [data_d objectForKey:@"gift"];
                    NSString *giftName = [giftDic objectForKey:@"name"];
                    NSNumber *giftNum = [giftDic objectForKey:@"count"];
                    if (giftName.length) {
                        chatModel.giftName = giftName;
                    }
                    if (giftNum) {
                        chatModel.giftCount = giftNum;
                    }
                    [self reloadDataWithTableView:_synthesizeTableView dataArray:_dataArray chatModel:chatModel];
                }
            } else if ([action isEqualToString:@"gift.feather"]) {
                chatModel.chatType = featherType;
                id data_d = [result objectForKey:@"data_d"];
                NSString *nick_name = [[data_d objectForKey:@"nick_name"] stringByTrimmingLeftCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                if (nick_name.length) {
                    chatModel.nick_name = nick_name;
                }
                [self reloadDataWithTableView:_synthesizeTableView dataArray:_dataArray chatModel:chatModel];
            }
        } else {
            NSString *content = [result objectForKey:@"content"];
            NSNumber *level = [result objectForKey:@"level"];
            NSDictionary *fromDic = [result objectForKey:@"from"];
            NSString *nick_name = [[fromDic objectForKey:@"nick_name"] stringByTrimmingLeftCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            NSDictionary *toDic = [result objectForKey:@"to"];
            if (toDic) {
                chatModel.chatType = tellTAType;
                NSString *toNick = [[toDic objectForKey:@"nick_name"] stringByTrimmingLeftCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                chatModel.toNick_name = toNick;
            } else {
                chatModel.chatType = contentType;
            }
            if (nick_name.length) {
                chatModel.nick_name = nick_name;
                chatModel.content = content;
                chatModel.level = level;
            }
            [self reloadDataWithTableView:_synthesizeTableView dataArray:_dataArray chatModel:chatModel];
            [self reloadDataWithTableView:_publicTableView dataArray:_publicDataArray chatModel:chatModel];
        }
    }
}

//根据对应数据源刷新对应tableView
- (void)reloadDataWithTableView:(UITableView *)tableView dataArray:(NSMutableArray *)dataArray chatModel:(ChatModel *)chatModel
{
    [dataArray addObject:chatModel];
    [tableView reloadData];
    [tableView scrollToRowAtIndexPath:
     [NSIndexPath indexPathForRow:dataArray.count - 1 inSection:0]
                                atScrollPosition: UITableViewScrollPositionBottom
                                        animated:NO];
}

- (void)socketIO:(SocketIO *)socket onError:(NSError *)error
{
    if ([error code] == SocketIOUnauthorized) {
        NSLog(@"not authorized");
    } else {
        NSLog(@"onError() %@", error);
    }
}

- (void)socketIODidDisconnect:(SocketIO *)socket disconnectedWithError:(NSError *)error
{
    NSLog(@"socket.io disconnected. did error occur? %@", error);
}

#pragma mark - request
- (void)requestWithParam:(NSString *)param tag:(NSInteger)tag
{
    NSString *urlStr = [NSString stringWithFormat:@"%@rank/%@/%@?size=%@",BaseURL,param,self.allModel._id,self.allModel.visiter_count];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [request setTimeOutSeconds:100];
    request.delegate = self;
    request.tag = tag;
    [request startAsynchronous];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    id result = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
    switch (request.tag) {
        case 500: { //本场观众
            if ([result isKindOfClass:[NSDictionary class]]) {
                NSNumber *code = [result objectForKey:@"code"];
                if (code.intValue == 1) {
                    NSArray *dataArr = [result objectForKey:@"data"];
                    for (NSDictionary *dic in dataArr) {
                        RankingModel *rankModel = [[RankingModel alloc] init];
                        rankModel.nick_name = [dic objectForKey:@"nick_name"];
                        rankModel.pic = [dic objectForKey:@"pic"];
                        [_homeCourseArray addObject:rankModel];
                    }
                    [_homeCourseTableView reloadData];
                }
            }
        }
            break;
        case 501: { //月榜
            if ([result isKindOfClass:[NSDictionary class]]) {
                NSNumber *code = [result objectForKey:@"code"];
                if (code.intValue == 1) {
                    NSArray *dataArr = [result objectForKey:@"data"];
                    for (NSDictionary *dic in dataArr) {
                        RankingModel *rankModel = [[RankingModel alloc] init];
                        rankModel.nick_name = [dic objectForKey:@"nick_name"];
                        rankModel.pic = [dic objectForKey:@"pic"];
                        [_monthArray addObject:rankModel];
                    }
                }
                [_monthTableView reloadData];
            }
        }
            break;
        case 502: { //总榜
            if ([result isKindOfClass:[NSDictionary class]]) {
                NSNumber *code = [result objectForKey:@"code"];
                if (code.intValue == 1) {
                    NSArray *dataArr = [result objectForKey:@"data"];
                    for (NSDictionary *dic in dataArr) {
                        RankingModel *rankModel = [[RankingModel alloc] init];
                        rankModel.nick_name = [dic objectForKey:@"nick_name"];
                        rankModel.pic = [dic objectForKey:@"pic"];
                        [_alwaysArray addObject:rankModel];
                    }
                }
                [_alwaysTableView reloadData];
            }
        }
            break;
        default:
            break;
    }
    
}

@end
