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
#import "UIImageView+BoundsAdditions.h"

@interface PlayViewController () <VMediaPlayerDelegate, UITextFieldDelegate, SocketIODelegate, ASIHTTPRequestDelegate>

{
    BOOL tap;
    UIScrollView *_scrollView;
    //导航
    UIView       *_navView;
    //视频部分
    UIImageView  *_liveView;
    //升级
    UIImageView  *_upgradeView;
    //羽毛
    UIImageView  *_yumaoView;
    UILabel      *_quantityLabel;
    //主播详情
    UIView       *_classifyView;
    //button背景
    UIImageView  *_backImageView;
    //综合
    UIButton     *synthesizeButton;
    //公聊
    UIButton     *publicButton;
    //私聊
    UIButton     *privateButton;
    //观众
    UIButton     *audienceButton;
    //关注
    UIButton     *attentionButton;
    //抢沙发
    UIView       *_sofaView;
    UIView       *_backView;
    //聊天输入框
    UITextField  *_chatTextField;
    VMediaPlayer *mMPayer;
    //视频背景
    UIImageView  *bagView;
    //下半部的背景VIew
    UIView       *View;
    //关闭视频
    UIButton     *bearButton;
    //聊天背景
    UIView       *chatView;
    SocketIO     *_socketIO;
    //观众榜里的button
    UIView       *announcementView;
    //判断观众榜的左右滑动
    UIImageView  *announcementImageView;
    //观众榜
    UIScrollView *audienceScrollView;
    //本场观众
    UIButton     *homeCourseButton;
    //月榜
    UIButton     *monthButton;
    //总榜
    UIButton     *alwaysButton;
    //textfield输入状态
    UIView       *_inputView;
    //聊天框
    UIView       *chatBView;
    //礼物背景
    UIView       *gifView;
    //黑色背景
    UIView       *blackView;
    //图片
    NSArray      *imageArray;
    //标题
    NSArray      *titleArray;
    //改昵称到意见反馈
    UIView       *whiteView;
}

@property (nonatomic, strong) UIActivityIndicatorView *activityView;
@property (nonatomic, strong) LoginModel              *model;
@property (nonatomic, strong) NSURL                   *videoURL;
//关注ids
@property (nonatomic, strong) NSMutableArray          *attentionArray;
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
//沙发
@property (nonatomic, strong) NSMutableArray          *sofaArray;

@end

@implementation PlayViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    imageArray = [NSArray arrayWithObjects:@"xiugainicheng",@"guangbo",@"diange",@"shezhix",@"yijianfankui", nil];
    titleArray = [NSArray arrayWithObjects:@"改昵称",@"广播",@"点歌",@"设置",@"意见反馈", nil];
    
    _model = [CommonUtil getUserModel];
    _dataArray       = [[NSMutableArray alloc] init];
    _publicDataArray = [[NSMutableArray alloc] init];
    _privateArray    = [[NSMutableArray alloc] init];
    _homeCourseArray = [[NSMutableArray alloc] init];
    _monthArray      = [[NSMutableArray alloc] init];
    _alwaysArray     = [[NSMutableArray alloc] init];
    _attentionArray  = [[NSMutableArray alloc] init];
    _sofaArray       = [[NSMutableArray alloc] init];
    
    _socketIO = [[SocketIO alloc] initWithDelegate:self];
    
    //socket
    if (_model) {
        NSDictionary *dic = @{@"room_id": self.allModel._id,
                              @"access_token": _model.access_token};
        [_socketIO connectToHost:BaseHost onPort:80 withParams:dic];
    }
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self shouwUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(keyboardWasHidden:) name:UIKeyboardDidHideNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self requestWithParam:@"room_user_live" tag:500];
    [self requestWithParam:@"room_user_month" tag:501];
    [self requestWithParam:@"room_user_total" tag:502];
    [self requestWithFollowing:@"following_list" tag:602];
    [self requestWithInfo:@"room_star"tag:700];
    [self requestWithInfo:@"room_sofa" tag:800];

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
    _liveView.tag = 1000;
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
    
    UILabel *shengjiLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 8, 90, 16)];
    NSNumber *coin = [self.allModel.finance objectForKey:@"bean_count_total"];
    NSInteger nextCoin = [CommonUtil getLevelInfoWithCoin:coin.intValue isRich:YES].nextCoin;
    shengjiLabel.text = [NSString stringWithFormat:@"差%d经验升级",nextCoin];
    shengjiLabel.font = [UIFont systemFontOfSize:10];
    [_upgradeView addSubview:shengjiLabel];
    
    //羽毛
    _yumaoView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 10, 33, 32)];
    _yumaoView.image = [UIImage imageNamed:@"yumao"];
    [_liveView addSubview:_yumaoView];
    
    _quantityLabel = [[UILabel alloc]initWithFrame:CGRectMake(13, 20, 18, 7)];
    _quantityLabel.font = [UIFont systemFontOfSize:6];
    [_yumaoView addSubview:_quantityLabel];
    
    //导航
    _navView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, kScreenWidth, 35)];
    _navView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.8];
    _navView.hidden = YES;
    [self.view addSubview:_navView];
    //主播名字
    CGSize size = [CommonUtil getRectWithText:self.allModel.nick_name height:35.0 width:CGFLOAT_MAX font:15.0].size;
    UILabel *navLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, size.width, 35)];
    navLabel.text = [NSString stringWithFormat:@"%@",self.allModel.nick_name];
    navLabel.textColor = textFontColor;
    navLabel.font = [UIFont systemFontOfSize:15];
    navLabel.textAlignment = NSTextAlignmentLeft;
    [_navView addSubview:navLabel];
    //主播等级
    UIImageView *gradeView = [[UIImageView alloc]initWithFrame:CGRectMake(size.width + 38, 5, 25, 25)];
    NSNumber *coinNum = [self.allModel.finance objectForKey:@"bean_count_total"];
    NSInteger level = [CommonUtil getLevelInfoWithCoin:coinNum.intValue isRich:NO].level;
    NSString *imageName = [NSString stringWithFormat:@"%dzhubo",level];
    gradeView.image = [UIImage imageNamed:imageName];
    [_navView addSubview:gradeView];
    //返回上一页
    UIButton *returnButton = [UIButton buttonWithType:UIButtonTypeCustom];
    returnButton.frame = CGRectMake(0, 0, 30, 35);
    returnButton.tag = 100;
    [returnButton setImage:[UIImage imageNamed:@"guanbi"] forState:UIControlStateNormal];
    [returnButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_navView addSubview:returnButton];
    //收藏
    attentionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    attentionButton.frame = CGRectMake(260, 0, 20, 35);
    attentionButton.tag = 101;
    [attentionButton setImage:[UIImage imageNamed:@"shoucang"] forState:UIControlStateNormal];
    [attentionButton setImage:[UIImage imageNamed:@"shoucangdianji"] forState:UIControlStateSelected];
    [attentionButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_navView addSubview:attentionButton];
    //主播详情按钮
    UIButton *classifyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    classifyButton.frame = CGRectMake(285, 0, 30, 35);
    classifyButton.tag = 102;
    [classifyButton setImage:[UIImage imageNamed:@"zhuboxiangqing"] forState:UIControlStateNormal];
    [classifyButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_navView addSubview:classifyButton];

    //主播详情
    _classifyView = [[UIView alloc]initWithFrame:CGRectMake(kScreenWidth-100, 55, 100, 55)];
    _classifyView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.3];
    _classifyView.userInteractionEnabled = YES;
    _classifyView.hidden = YES;
    [self.view addSubview:_classifyView];
    //主播档案
    UIView *recordView = [[UIView alloc] initWithFrame:CGRectMake(0, 1, _classifyView.frame.size.width, _classifyView.frame.size.height/2)];
    recordView.backgroundColor = [UIColor clearColor];
    recordView.tag = 1200;
    [_classifyView addSubview:recordView];
    
    UITapGestureRecognizer *recordTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(classifyTap:)];
    [recordView addGestureRecognizer:recordTap];
    
    //档案图标
    UIImageView *recordImageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 4, 20, 20)];
    recordImageView.image = [UIImage imageNamed:@"zhubodangan"];
    [recordView addSubview:recordImageView];
    //档案字
    UILabel *recordLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 0, 55, recordView.frame.size.height)];
    recordLabel.text = @"主播档案";
    recordLabel.textColor = [UIColor whiteColor];
    recordLabel.font = [UIFont systemFontOfSize:13];
    [recordView addSubview:recordLabel];
    
    //横线
    UIImageView *XQImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, _classifyView.frame.size.height/2, _classifyView.frame.size.width, 0.5)];
    XQImageView.backgroundColor = [UIColor whiteColor];
    [_classifyView addSubview:XQImageView];
    
    //分享
    UIView *shareView = [[UIView alloc]initWithFrame:CGRectMake(0, _classifyView.frame.size.height/2, _classifyView.frame.size.width, _classifyView.frame.size.height/2)];
    shareView.backgroundColor = [UIColor clearColor];
    shareView.tag = 1300;
    [_classifyView addSubview:shareView];
    
    UITapGestureRecognizer *shareTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(classifyTap:)];
    [shareView addGestureRecognizer:shareTap];
    
    //分享图标
    UIImageView *shareImageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 4, 20, 20)];
    shareImageView.image = [UIImage imageNamed:@"fenxiang"];
    [shareView addSubview:shareImageView];
    //分享字
    UILabel *shareLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 0, 65, recordView.frame.size.height)];
    shareLabel.text = @"分享给朋友";
    shareLabel.textColor = [UIColor whiteColor];
    shareLabel.font = [UIFont systemFontOfSize:13];
    [shareView addSubview:shareLabel];
    
    //关闭视频
    bearButton = [UIButton buttonWithType:UIButtonTypeCustom];
    bearButton.frame = CGRectMake(280, 200, 35, 35);
    [bearButton setImage:[UIImage imageNamed:@"shipin"] forState:UIControlStateNormal];
    bearButton.tag = 1000;
    [bearButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_liveView addSubview:bearButton];
    
    //-----------------------------------------------------------------------------------//
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
    chatView.backgroundColor = [UIColor clearColor];
    chatView.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1];
    chatView.userInteractionEnabled = YES;
    [self.view addSubview:chatView];
    //聊天的白框
    chatBView = [[UIView alloc]initWithFrame:CGRectMake(5, 5, 260, 35)];
    chatBView.backgroundColor = [UIColor whiteColor];
    [chatView addSubview:chatBView];
    //表情
    UIImageView *faceView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 7.5, 20, 20)];
    faceView.image = [UIImage imageNamed:@"biaoqing"];
    [chatBView addSubview:faceView];
    //聊天框
    _chatTextField = [[UITextField alloc]initWithFrame:CGRectMake(27, 0, 233, 35)];
    _chatTextField.backgroundColor = [UIColor clearColor];
    _chatTextField.borderStyle = UITextBorderStyleNone;
    _chatTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _chatTextField.delegate = self;
    [chatBView addSubview:_chatTextField];
    
    //礼物按钮
    UIImageView *giftImageView = [[UIImageView alloc]initWithFrame:CGRectMake(270, 12.5, 20, 20)];
    giftImageView.image = [UIImage imageNamed:@"liwu"];
    giftImageView.userInteractionEnabled = YES;
    tap = NO;
    [chatView addSubview:giftImageView];
    
    UITapGestureRecognizer *gifTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gifClick:)];
    [giftImageView addGestureRecognizer:gifTap];
    
    //信息档案
    UIButton *manageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    manageButton.frame = CGRectMake(295, 12.5, 15, 20);
    manageButton.tag = 104;
    [manageButton setImage:[UIImage imageNamed:@"zhuboxiangqing"] forState:UIControlStateNormal];
    [manageButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [chatView addSubview:manageButton];
/************************************************************************************************/
    blackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 260)];
    blackView.alpha = 0.5;
    blackView.hidden = YES;
    blackView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:blackView];
    UITapGestureRecognizer *blackTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(blackClick:)];
    [blackView addGestureRecognizer:blackTap];
    
    //礼物背景
    gifView = [[UIView alloc]initWithFrame:CGRectMake(0, 260, kScreenWidth, kScreenHeight-260)];
    gifView.backgroundColor = [UIColor whiteColor];
    gifView.userInteractionEnabled = YES;
    gifView.hidden = YES;
    [self.view addSubview:gifView];
    gifView.hidden = YES;
    
    //横线
    UIImageView *gifHXImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 25, kScreenWidth, 0.5)];
    gifHXImageView.backgroundColor = [UIColor lightGrayColor];
    [gifView addSubview:gifHXImageView];
    //充值到赠送背景
    UIView *grayView = [[UIView alloc]initWithFrame:CGRectMake(0, gifView.frame.size.height-90, kScreenWidth, 90)];
    grayView.backgroundColor = [UIColor colorWithRed:249/255.0 green:249/255.0 blue:249/255.0 alpha:1];
    [gifView addSubview:grayView];
    //20横线
    UIImageView *ESHXImageVIew = [[UIImageView alloc]initWithFrame:CGRectMake(0, 20, kScreenWidth, 0.5)];
    ESHXImageVIew.backgroundColor = [UIColor lightGrayColor];
    [grayView addSubview:ESHXImageVIew];
    //55横线
    UIImageView *WWHXImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 55, kScreenWidth, 0.5)];
    WWHXImageView.backgroundColor = [UIColor lightGrayColor];
    [grayView addSubview:WWHXImageView];
    //余额
    UILabel *balanceLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 150, 20)];
    balanceLabel.backgroundColor = [UIColor clearColor];
    balanceLabel.text = [NSString stringWithFormat:@"余额：%d金币",1245];
    balanceLabel.textColor = [UIColor grayColor];
    balanceLabel.font = [UIFont systemFontOfSize:14];
    [grayView addSubview:balanceLabel];
    //充值
    UIButton *topUpButton = [UIButton buttonWithType:UIButtonTypeCustom];
    topUpButton.frame = CGRectMake(250, 0, 60, 20);
    topUpButton.tag = 110;
    [topUpButton setTitle:@"立刻充值" forState:UIControlStateNormal];
    [topUpButton setTitleColor:textFontColor forState:UIControlStateNormal];
    topUpButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [topUpButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [grayView addSubview:topUpButton];
    //送给
    UILabel *donateLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 30, 30, 15)];
    donateLabel.text = @"送给";
    donateLabel.font = [UIFont systemFontOfSize:15];
    donateLabel.backgroundColor = [UIColor clearColor];
    donateLabel.textColor = textFontColor;
    [grayView addSubview:donateLabel];
    //名字
    UIImageView *nameImageView = [[UIImageView alloc]initWithFrame:CGRectMake(45, 27, 125, 22)];
    nameImageView.image = [UIImage imageNamed:@"xiala"];
    [grayView addSubview:nameImageView];
    //名字的字
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, 100, 22)];
    nameLabel.text = @"起的隆冬强";
    nameLabel.textColor = textFontColor;
    nameLabel.font = [UIFont systemFontOfSize:14];
    nameLabel.backgroundColor = [UIColor clearColor];
    [nameImageView addSubview:nameLabel];
    //数量
    UIImageView *nuberImageView = [[UIImageView alloc]initWithFrame:CGRectMake(180, 27, 125, 22)];
    nuberImageView.image = [UIImage imageNamed:@"xiala"];
    [grayView addSubview:nuberImageView];
    //数量的字
    UILabel *nuberLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, 100, 22)];
    nuberLabel.text = @"1";
    nuberLabel.textColor = textFontColor;
    nuberLabel.textAlignment = NSTextAlignmentCenter;
    nuberLabel.font = [UIFont systemFontOfSize:14];
    nuberLabel.backgroundColor = [UIColor clearColor];
    [nuberImageView addSubview:nuberLabel];
    
    //礼物跑到
    UILabel *trackLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 64, 60, 15)];
    trackLabel.text = @"礼物跑道";
    trackLabel.textColor = textFontColor;
    trackLabel.font = [UIFont systemFontOfSize:14];
    trackLabel.backgroundColor = [UIColor clearColor];
    [grayView addSubview:trackLabel];
    
    //赠送
    UIButton *ZXButton = [UIButton buttonWithType:UIButtonTypeCustom];
    ZXButton.frame = CGRectMake(180, 60, 125, 25);
    ZXButton.tag = 111;
    [ZXButton setTitle:@"赠送" forState:UIControlStateNormal];
    [ZXButton setBackgroundColor:textFontColor];
    [ZXButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [grayView addSubview:ZXButton];
    
/************************************************************************************************/
    //textfield输入状态
    _inputView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 75)];
    _inputView.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1];
    [self.view addSubview:_inputView];
    //箭头
    UIImageView *arrowsView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 130, 20)];
    arrowsView.image = [UIImage imageNamed:@"xiala"];
    [_inputView addSubview:arrowsView];
    //所有人
    UILabel *allLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 110, 20)];
    allLabel.text = @"所有人";
    allLabel.backgroundColor = [UIColor clearColor];
    allLabel.textAlignment = NSTextAlignmentCenter;
    allLabel.font = [UIFont systemFontOfSize:14];
    allLabel.textColor = [UIColor lightGrayColor];
    [arrowsView addSubview:allLabel];
    //悄悄话
    UIView *QQHView = [[UIView alloc]initWithFrame:CGRectMake(146, 5, 80, 20)];
    QQHView.backgroundColor = [UIColor clearColor];
    [_inputView addSubview:QQHView];
    //悄悄话
    UIImageView *quietlyImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    quietlyImageView.image = [UIImage imageNamed:@"qiaoqiaohuaweixuanzhong"];
    [QQHView addSubview:quietlyImageView];
    // 悄悄话
    UILabel *QQHLabel = [[UILabel alloc]initWithFrame:CGRectMake(25, 0, 55, 20)];
    QQHLabel.text = @"悄悄话";
    QQHLabel.backgroundColor = [UIColor clearColor];
    QQHLabel.textColor = [UIColor lightGrayColor];
    [QQHView addSubview:QQHLabel];
    //礼物
    UIView *LWView = [[UIView alloc]initWithFrame:CGRectMake(245, 5, 70, 20)];
    LWView.backgroundColor = [UIColor clearColor];
    [_inputView addSubview:LWView];
    //礼物
    UIImageView *newGifImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    newGifImageView.image = [UIImage imageNamed:@"liwu"];
    [LWView addSubview:newGifImageView];
    //礼物字
    UILabel *LWLabel = [[UILabel alloc]initWithFrame:CGRectMake(25, 0, 40, 20)];
    LWLabel.text = @"礼物";
    LWLabel.backgroundColor = [UIColor clearColor];
    LWLabel.textColor = [UIColor lightGrayColor];
    [LWView addSubview:LWLabel];
    //横线
    UIImageView *LTHXImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 29.5, kScreenWidth, 0.5)];
    LTHXImageView.backgroundColor = [UIColor lightGrayColor];
    [_inputView addSubview:LTHXImageView];
    //发送
    UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sendButton.frame = CGRectMake(260, 38, 45, 30);
    sendButton.tag = 100000000;
    [sendButton setBackgroundImage:[UIImage imageNamed:@"fasong"] forState:UIControlStateNormal];
    [sendButton setBackgroundImage:[UIImage imageNamed:@"fasongdianji"] forState:UIControlStateHighlighted];
    [sendButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_inputView addSubview:sendButton];
    //改昵称到意见反馈
    whiteView = [[UIView alloc]initWithFrame:CGRectMake(320, View.frame.size.height-169, 100, 125)];
    whiteView.backgroundColor = [UIColor clearColor];
    whiteView.layer.borderColor = [UIColor grayColor].CGColor;
    whiteView.layer.borderWidth = 0.3;
    whiteView.layer.cornerRadius = 0;
    [View addSubview:whiteView];
    for (int i = 0; i<4; i++) {
        UIImageView *hImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 24.5+25*i, whiteView.frame.size.width, 0.5)];
        hImageView.backgroundColor = [UIColor lightGrayColor];
        [whiteView addSubview:hImageView];
    }
    //循环创建
    for (int j = 0; j < 5; j++) {
        UIButton *NYButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0+25*j, whiteView.frame.size.width, 24.5)];
        NYButton.tag = 900+j;
        [NYButton setImage:[UIImage imageNamed:[imageArray objectAtIndex:j]] forState:UIControlStateNormal];
        [NYButton setImageEdgeInsets:UIEdgeInsetsMake(10, -40, 10, 0)];
        [NYButton setTitle:[titleArray objectAtIndex:j] forState:UIControlStateNormal];
        [NYButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        NYButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [NYButton setContentEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
        if (j == 0) {
            [NYButton setImageEdgeInsets:UIEdgeInsetsMake(10, -10, 10, 0)];
            [NYButton setContentEdgeInsets:UIEdgeInsetsMake(10, -5, 10, 10)];
        } else if (j == 4) {
            [NYButton setImageEdgeInsets:UIEdgeInsetsMake(10, -10, 10, 0)];
            [NYButton setContentEdgeInsets:UIEdgeInsetsMake(10, 5, 10, 10)];
        } else {
            [NYButton setImageEdgeInsets:UIEdgeInsetsMake(10, -10, 10, 0)];
            [NYButton setContentEdgeInsets:UIEdgeInsetsMake(10, -20, 10, 10)];
        }
        [NYButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [whiteView addSubview:NYButton];
    }

    
    //快捷礼物
    UIImageView *shortcutGifImageView = [[UIImageView alloc]initWithFrame:CGRectMake(285, 190, 30, 30)];
    shortcutGifImageView.image = [UIImage imageNamed:@"luwu"];
    [View addSubview:shortcutGifImageView];
    UILabel *shortLabel = [[UILabel alloc]initWithFrame:CGRectMake(7, 20, 18, 9)];
    shortLabel.text = @"x10";
    shortLabel.font = [UIFont systemFontOfSize:10];
    shortLabel.textColor = [UIColor whiteColor];
    shortLabel.backgroundColor = [UIColor clearColor];
    [shortcutGifImageView addSubview:shortLabel];
    //羽毛
    UIImageView *featherImageView = [[UIImageView alloc]initWithFrame:CGRectMake(285, 225, 30, 30)];
    featherImageView.image = [UIImage imageNamed:@"yumao@"];
    [View addSubview:featherImageView];
    UILabel *featherLabel = [[UILabel alloc]initWithFrame:CGRectMake(7, 18, 18, 9)];
    featherLabel.text = @"x10";
    featherLabel.font = [UIFont systemFontOfSize:10];
    featherLabel.textColor = [UIColor whiteColor];
    featherLabel.backgroundColor = [UIColor clearColor];
    [featherImageView addSubview:featherLabel];
    
    /************************************************************************************************/

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
    [homeCourseButton addTarget:self action:@selector(buttonSender:) forControlEvents:UIControlEventTouchUpInside];
    [announcementView addSubview:homeCourseButton];
    //月榜
    monthButton = [UIButton buttonWithType:UIButtonTypeCustom];
    monthButton.frame = CGRectMake(120, 0, 100, 30);
    monthButton.tag = 106;
    [monthButton setTitle:@"月榜" forState:UIControlStateNormal];
    [monthButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [monthButton setBackgroundColor:[UIColor colorWithRed:245/255.0 green:146/255.0 blue:123/255.0 alpha:1]];
    [monthButton addTarget:self action:@selector(buttonSender:) forControlEvents:UIControlEventTouchUpInside];
    [announcementView addSubview:monthButton];
    //总榜
    alwaysButton = [UIButton buttonWithType:UIButtonTypeCustom];
    alwaysButton.frame = CGRectMake(220, 0, 100, 30);
    alwaysButton.tag = 107;
    [alwaysButton setTitle:@"总榜" forState:UIControlStateNormal];
    [alwaysButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [alwaysButton setBackgroundColor:[UIColor colorWithRed:253/255.0 green:193/255.0 blue:176/255.0 alpha:1]];
    [alwaysButton addTarget:self action:@selector(buttonSender:) forControlEvents:UIControlEventTouchUpInside];
    [announcementView addSubview:alwaysButton];
    
    //抢沙发
    _sofaView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight- 130, kScreenWidth, 130)];
    _sofaView.backgroundColor = [UIColor blackColor];
    _sofaView.hidden = YES;
    _sofaView.alpha = 0.6;
    [self.view addSubview:_sofaView];
    
    _backView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight - 130, kScreenWidth, 130)];
    [_backView setBackgroundColor:[UIColor clearColor]];
    [_backView setHidden:YES];
    [self.view addSubview:_backView];
    
    for (int i = 0; i < 4; i++) {
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(i*80, 10, 80, 15)];
        titleLabel.text = @"虚位以待";
        titleLabel.tag = 900 + i;
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont systemFontOfSize:12];
        [_backView addSubview:titleLabel];
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(7.5+i*80, 30, 65, 65)];
        imageView.image = [UIImage imageNamed:@"xuweiyidai"];
        [_backView addSubview:imageView];
        
        UIImageView *headView = [[UIImageView alloc] initWithFrame:CGRectMake(15+i*80, 38, 50, 50)];
        [headView makeBoundImage];
        headView.tag = 400 + i;
        [_backView addSubview:headView];
        
        UIImageView *QImageView = [[UIImageView alloc]initWithFrame:CGRectMake(21+i*80, 100, 38, 18)];
        QImageView.image = [UIImage imageNamed:@"qiangzuo"];
        [_backView addSubview:QImageView];
    }

}
/**********************************************************************************************************/

#pragma mark - 点击事件
- (void)buttonClick:(UIButton *)button
{
    if (button.tag == 100) {
        [mMPayer reset];
        [mMPayer unSetupPlayer];
        [self dismissViewControllerAnimated:YES completion:nil];
    } else if (button.tag == 101) { //关注
        if (button.selected) {
            [self requestWithFollowing:@"del_following" tag:601];
        } else {
            [self requestWithFollowing:@"add_following" tag:600];
        }
    } else if (button.tag == 102) {
        _classifyView.hidden = !_classifyView.hidden;

    } else if (button.tag == 104) {
        if (button.selected) {
            whiteView.frame = CGRectMake(320, View.frame.size.height-169, 100, 125);
            button.selected = NO;
        } else {
            whiteView.frame = CGRectMake(220, View.frame.size.height-169, 100, 125);
            button.selected = YES;
        }
    } else if (button.tag == 1000) {
        if (button.selected) {
            bearButton.frame = CGRectMake(280, 200, 35, 35);
            [bearButton setImage:[UIImage imageNamed:@"shipin"] forState:UIControlStateNormal];
            button.selected = NO;
            bagView.hidden = YES;
            View.frame = CGRectMake(0, kScreenHeight-308, kScreenWidth, kScreenHeight-260);
            _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 28, kScreenWidth, kScreenHeight-333)];
            _scrollView.contentSize = CGSizeMake(kScreenWidth *4, kScreenHeight-333);
        } else {
            bearButton.frame = CGRectMake(280, 120, 35, 35);
           [bearButton setImage:[UIImage imageNamed:@"shipinguanbi"] forState:UIControlStateNormal];
            button.selected = YES;
            bagView.hidden = NO;
            View.frame = CGRectMake(0, kScreenHeight-388, kScreenWidth, kScreenHeight-180);
            _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 28, kScreenWidth, kScreenHeight-253)];
            _scrollView.contentSize = CGSizeMake(kScreenWidth *4, kScreenHeight-253);
        }
    } else {
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
- (void)buttonSender:(UIButton *)button
{
    if (button.selected) {
        return;
    }
    homeCourseButton.selected = NO;
    monthButton.selected = NO;
    alwaysButton.selected = NO;
    button.selected = YES;
    [UIView animateWithDuration:0 animations:^{
        audienceScrollView.contentOffset = CGPointMake(kScreenWidth*(button.tag-105), 0);
        [self announcementchanged];
    }];
}

#pragma mark - 点击播放界面方法
- (void)liveClick:(UITapGestureRecognizer *)sender
{
    if (tap) {
        _navView.hidden = YES;
        _upgradeView.hidden = YES;
        _classifyView.hidden = YES;
        _sofaView.hidden = YES;
        [_backView setHidden:YES];
        _yumaoView.frame = CGRectMake(5, 10, 33, 32);
        tap = NO;
    } else {
        _navView.hidden = NO;
        _upgradeView.hidden = NO;
        _sofaView.hidden = NO;
        [_backView setHidden:NO];
        _yumaoView.frame = CGRectMake(5, 73, 33, 32);
        tap = YES;
    }
}
- (void)gifClick:(UITapGestureRecognizer *)sender
{
    if (tap) {
        gifView.hidden = YES;
        blackView.hidden = YES;
    } else {
        gifView.hidden = NO;
        blackView.hidden = NO;
    }
}
- (void)blackClick:(UITapGestureRecognizer *)sender
{
    if (tap) {
        gifView.hidden = NO;
        blackView.hidden = NO;

    }else {
        gifView.hidden = YES;
        blackView.hidden = YES;
    }
}

- (void)classifyTap:(UITapGestureRecognizer *)sender
{
    _classifyView.hidden = !_classifyView.hidden;
    switch (sender.view.tag) {
        case 1200: { //主播档案
            DatumViewController *datum = [[DatumViewController alloc] init];
            datum.userId = self.allModel._id;
            [self presentViewController:datum animated:YES completion:nil];
        }
            break;
        case 1300:  //分享
            
            break;
        default:
            break;
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
            return 44.0;
        }
            break;
        case 602: {
            return 44.0;
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

#pragma mark - 键盘回收
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    _inputView.hidden = YES;
    [_chatTextField resignFirstResponder];
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    _inputView.hidden = NO;
    chatBView.frame = CGRectMake(5, 38, 250, 30);
    [_inputView addSubview:chatBView];
}

#pragma mark - request
- (void)requestWithParam:(NSString *)param tag:(NSInteger)tag
{
    NSString *urlStr = [NSString stringWithFormat:@"%@rank/%@/%@?size=3456",BaseURL,param,self.allModel._id];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [request setTimeOutSeconds:100];
    request.delegate = self;
    request.tag = tag;
    [request startAsynchronous];
}

- (void)requestWithFollowing:(NSString *)param tag:(NSInteger)tag
{
    if (_model.access_token.length) {
        NSString *urlStr = [NSString stringWithFormat:@"%@user/%@/%@/%@",BaseURL,param,_model.access_token,self.allModel._id];
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
        [request setTimeOutSeconds:100];
        request.delegate = self;
        request.tag = tag;
        [request startAsynchronous];
    }
}

- (void)requestWithInfo:(NSString *)param tag:(NSInteger)tag
{
    NSString *urlStr = [NSString stringWithFormat:@"%@public/%@/%@",BaseURL,param,self.allModel._id];
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
                        [rankModel getRankModelWithDictionary:dic];
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
                        [rankModel getRankModelWithDictionary:dic];
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
                        [rankModel getRankModelWithDictionary:dic];
                        [_alwaysArray addObject:rankModel];
                    }
                }
                [_alwaysTableView reloadData];
            }
        }
            break;
        case 600: { //添加关注
            if ([result isKindOfClass:[NSDictionary class]]) {
                NSNumber *code = [result objectForKey:@"code"];
                if (code.intValue == 1) {
                    attentionButton.selected = YES;
                }
            }
        }
            break;
        case 601: { //取消关注
            if ([result isKindOfClass:[NSDictionary class]]) {
                NSNumber *code = [result objectForKey:@"code"];
                if (code.intValue == 1) {
                    attentionButton.selected = NO;
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
                    if ([self isAttentionWithRoomid:self.allModel._id]) {
                        attentionButton.selected = YES;
                    } else {
                        attentionButton.selected = NO;
                    }
                }
            }
        }
            break;
        case 700: { //主播羽毛
            if ([result isKindOfClass:[NSDictionary class]]) {
                NSNumber *code = [result objectForKey:@"code"];
                if (code.intValue == 1) {
                    NSDictionary *dataDic = [result objectForKey:@"data"];
                    NSDictionary *userDic = [dataDic objectForKey:@"user"];
                    NSDictionary *financeDic = [userDic objectForKey:@"finance"];
                    NSNumber *featherNum = [financeDic objectForKey:@"feather_receive_total"];
                    _quantityLabel.text = featherNum.stringValue;
                }
            }
        }
            break;
        case 800: { //沙发
            if ([result isKindOfClass:[NSDictionary class]]) {
                NSNumber *code = [result objectForKey:@"code"];
                if (code.intValue == 1) {
                    NSDictionary *dataDic = [result objectForKey:@"data"];
                    NSArray *userArr = [dataDic objectForKey:@"user"];
                    for (NSDictionary *dic in userArr) {
                        RankingModel *rankModel = [[RankingModel alloc] init];
                        [rankModel getRankModelWithDictionary:dic];
                        [_sofaArray addObject:rankModel];
                    }
                    [self refreshSofaView];
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

- (void)refreshSofaView
{
    for (int i = 0; i < _sofaArray.count; i++) {
        RankingModel *model = [_sofaArray objectAtIndex:i];
        if (model.nick_name.length) {
            UILabel *nickLab = (UILabel *)[_backView viewWithTag:900 + i];
            [nickLab setText:model.nick_name];
        }
        if (model.pic.length) {
            UIImageView *headImg = (UIImageView *)[_backView viewWithTag:400 + i];
            [headImg setImageWithURL:[NSURL URLWithString:model.pic]];
        }
    }
}

#pragma mark - 
- (void) keyboardWasShown:(NSNotification *) notif
{
    NSDictionary *info = [notif userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    
    NSLog(@"keyBoard:%f", keyboardSize.height);  //216
    _inputView.frame = CGRectMake(0, kScreenHeight-216-75, kScreenWidth, 75);
    ///keyboardWasShown = YES;
}
- (void) keyboardWasHidden:(NSNotification *) notif
{
    NSDictionary *info = [notif userInfo];
    
    NSValue *value = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    NSLog(@"keyboardWasHidden keyBoard:%f", keyboardSize.height);
    _inputView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 75);
    chatBView.frame = CGRectMake(5, 5, 260, 35);
    [chatView addSubview:chatBView];
    // keyboardWasShown = NO;
    
}

@end
