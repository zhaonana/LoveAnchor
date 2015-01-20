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
#import "ShareView.h"
#import "ChatSelectView.h"

#define REFRESH_PLAYVIEW_NOTIFITION @"refreshPlayViewNotifition"

@interface PlayViewController () <VMediaPlayerDelegate, UITextFieldDelegate, SocketIODelegate, ASIHTTPRequestDelegate,UIAlertViewDelegate>

{
    BOOL tap;
    UIScrollView *_scrollView;
    //导航
    UIView       *_navView;
    //视频部分
    UIView       *_liveView;
    UIImageView  *_liveImgView;
    //升级
    UIImageView  *_upgradeView;
    //羽毛
    UIImageView  *_yumaoView;
    UILabel      *_quantityLabel;
    UILabel      *_featherLabel;
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
    //修改昵称的背景
    UIView       *nameView;
    //改昵称背景
    UIView       *nickView;
    UIScrollView *_gifScrollView;
    //改昵称输入框
    UITextField  *GTextField;
    //点击抢座背景
    UIView       *robSofaBagView;
    //点击抢座的选项
    UIView       *robSofaView;
    //显示金币
    UILabel      *JBLabel;
    //记录金币的
    int          JBStr;

}

@property (nonatomic, strong) UIActivityIndicatorView *activityView;
@property (nonatomic, strong) LoginModel              *model;
@property (nonatomic, strong) NSURL                   *videoURL;
//抢座
@property (nonatomic, assign) NSInteger               grabTag;
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
//user
@property (nonatomic, strong) NSMutableArray          *userArray;
//直播id
@property (nonatomic, strong) NSNumber                *live_id;
//分享
@property (nonatomic, strong) ShareView               *shareView;
//聊天选框
@property (nonatomic, strong) UITableView             *chooseTableView;
//聊天对象
@property (nonatomic, strong) NSMutableArray          *chooseArray;
//聊天对象
@property (nonatomic, strong) UILabel                 *chatPeopleLabel;
//点击昵称弹框
@property (nonatomic, strong) ChatSelectView          *chatSelectView;
//个人信息model
@property (nonatomic, strong) UserInfoModel           *userModel;
//徽章
@property (nonatomic, strong) NSMutableArray          *badgeArray;
//聊天输入框
@property (nonatomic, strong) UITextField             *chatTextField;
//悄悄话
@property (nonatomic, assign) BOOL                    isPrivateis;
@property (nonatomic, strong) UIButton                *privateBtn;

@end

@implementation PlayViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    imageArray = [NSArray arrayWithObjects:@"xiugainicheng",@"guangbo",@"diange",@"shezhix",@"yijianfankui", nil];
    titleArray = [NSArray arrayWithObjects:@"改昵称",@"广播",@"点歌",@"设置",@"意见反馈", nil];
    
    _dataArray       = [[NSMutableArray alloc] init];
    _publicDataArray = [[NSMutableArray alloc] init];
    _privateArray    = [[NSMutableArray alloc] init];
    _homeCourseArray = [[NSMutableArray alloc] init];
    _monthArray      = [[NSMutableArray alloc] init];
    _alwaysArray     = [[NSMutableArray alloc] init];
    _attentionArray  = [[NSMutableArray alloc] init];
    _sofaArray       = [[NSMutableArray alloc] init];
    _userArray       = [[NSMutableArray alloc] init];
    
    UserInfoModel *all = [[UserInfoModel alloc] init];
    all.nick_name = @"所有人";
    
    UserInfoModel *user = [[UserInfoModel alloc] init];
    user._id = self.allModel._id;
    user.nick_name = self.allModel.nick_name;
    user.finance = self.allModel.finance;
    _chooseArray     = [[NSMutableArray alloc] initWithObjects:all, user, nil];
    _badgeArray      = [[NSMutableArray alloc] init];
    
    JBStr = 100;
    _model = [CommonUtil getUserModel];
    
    //socket
    _socketIO = [[SocketIO alloc] initWithDelegate:self];
    NSDictionary *dic = @{@"room_id": self.allModel._id,
                          @"access_token": _model ? _model.access_token : @""};
    [_socketIO connectToHost:BaseHost onPort:80 withParams:dic];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self shouwUI];
    
    //键盘通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(keyboardWasHidden:) name:UIKeyboardDidHideNotification object:nil];
    
    //mmPlayer
    NSString *url = [NSString stringWithFormat:@"rtmp://ttvpull.izhubo.com/live/%@",self.allModel._id];
    
    self.videoURL = [NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    [mMPayer setDataSource:self.videoURL];
    [mMPayer prepareAsync];
    if (self.allModel.live.intValue == 1) {
        [self.activityView setHidden:NO];
        [_liveImgView setHidden:NO];
        [self.activityView startAnimating];
    } else {
        [self.activityView setHidden:YES];
    }
    //分享
    _shareView = [[[NSBundle mainBundle] loadNibNamed:@"ShareView" owner:self options:nil] lastObject];
    [_shareView setFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    
    //聊天选框
    _chooseTableView = [[UITableView alloc] initWithFrame:CGRectMake(5, kScreenHeight, 130, 130) style:UITableViewStylePlain];
    _chooseTableView.tag = 500;
    _chooseTableView.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1];
    _chooseTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_chooseTableView setDelegate:self];
    [_chooseTableView setDataSource:self];
    [self.view addSubview:_chooseTableView];
    [_chooseTableView setHidden:YES];
    
    //聊天弹框
    _chatSelectView = [[[NSBundle mainBundle] loadNibNamed:@"ChatSelectView" owner:self options:nil] lastObject];
    [_chatSelectView setFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    _model = [CommonUtil getUserModel];

    [self requestWithParam:@"room_user_live" tag:500];
    [self requestWithParam:@"room_user_month" tag:501];
    [self requestWithParam:@"room_user_total" tag:502];
    [self requestWithFollowing:@"following_list" tag:602];
    [self requestWithInfo:@"room_star"tag:700];
    [self requestWithInfo:@"room_sofa" tag:800];
    [self requestWithFeather:@"user/info" tag:900];
}

#pragma mark - shouUI
- (void)shouwUI
{
    //视频播放
    _liveView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, kScreenWidth, 240)];
    _liveView.userInteractionEnabled = YES;
    _liveView.tag = 100;
    tap = NO;
    _liveView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:_liveView];
    
    _liveImgView = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth-148)/2, (240-77)/2, 148, 77)];
    [_liveImgView setImage:[UIImage imageNamed:@"aizhubo"]];
    [_liveView addSubview:_liveImgView];
    
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
    
    UILabel *shengjiLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 8, 90, 16)];
    NSNumber *coin = [self.allModel.finance objectForKey:@"bean_count_total"];
    NSInteger nextCoin = [CommonUtil getLevelInfoWithCoin:coin.intValue isRich:YES].nextCoin;
    shengjiLabel.text = [NSString stringWithFormat:@"差%ld经验升级",(long)nextCoin];
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
    NSString *imageName = [NSString stringWithFormat:@"%ldzhubo",(long)level];
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
    recordView.tag = 101;
    [_classifyView addSubview:recordView];
    
    UITapGestureRecognizer *recordTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(liveClick:)];
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
    shareView.tag = 102;
    [_classifyView addSubview:shareView];
    
    UITapGestureRecognizer *shareTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(liveClick:)];
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
    _chatTextField.placeholder = @"点此输入文字聊天";
    _chatTextField.delegate = self;
    [chatBView addSubview:_chatTextField];
    
    //礼物按钮
    UIImageView *giftImageView = [[UIImageView alloc]initWithFrame:CGRectMake(270, 12.5, 20, 20)];
    giftImageView.image = [UIImage imageNamed:@"liwu"];
    giftImageView.userInteractionEnabled = YES;
    giftImageView.tag = 103;
    tap = NO;
    [chatView addSubview:giftImageView];
    
    UITapGestureRecognizer *gifTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(liveClick:)];
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
    blackView.tag = 104;
    [self.view addSubview:blackView];
    UITapGestureRecognizer *blackTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(liveClick:)];
    [blackView addGestureRecognizer:blackTap];
    
    //礼物背景
    gifView = [[UIView alloc]initWithFrame:CGRectMake(0, 260, kScreenWidth, kScreenHeight-260)];
    gifView.backgroundColor = [UIColor whiteColor];
    gifView.userInteractionEnabled = YES;
    gifView.hidden = YES;
    [self.view addSubview:gifView];
    //不要删
//    _gifScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 30, kScreenWidth, 140)];
//    _gifScrollView.contentSize = CGSizeMake(kScreenWidth*7, 140);
    
    
    
    
    //横线
    UIImageView *gifHXImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 30, kScreenWidth, 0.5)];
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
    _inputView.userInteractionEnabled = YES;
    [self.view addSubview:_inputView];
    //箭头
    UIImageView *arrowsView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 130, 20)];
    arrowsView.image = [UIImage imageNamed:@"xiala"];
    arrowsView.tag = 200;
    arrowsView.userInteractionEnabled = YES;
    [_inputView addSubview:arrowsView];
    //所有人
    _chatPeopleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 110, 20)];
    _chatPeopleLabel.text = @"所有人";
    _chatPeopleLabel.backgroundColor = [UIColor clearColor];
    _chatPeopleLabel.textAlignment = NSTextAlignmentCenter;
    _chatPeopleLabel.font = [UIFont systemFontOfSize:14];
    _chatPeopleLabel.textColor = [UIColor lightGrayColor];
    [arrowsView addSubview:_chatPeopleLabel];
    
    UITapGestureRecognizer *chooseTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureTap:)];
    [arrowsView addGestureRecognizer:chooseTap];
    
    //悄悄话
    UIView *QQHView = [[UIView alloc]initWithFrame:CGRectMake(146, 5, 80, 20)];
    QQHView.backgroundColor = [UIColor clearColor];
    [_inputView addSubview:QQHView];
    //悄悄话
     _privateBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [_privateBtn setBackgroundImage:[UIImage imageNamed:@"qiaoqiaohuaweixuanzhong"] forState:UIControlStateNormal];
    [_privateBtn setBackgroundImage:[UIImage imageNamed:@"qiaoqiaohuaxuanzhong"] forState:UIControlStateSelected];
    [_privateBtn setTag:1200];
    [_privateBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [QQHView addSubview:_privateBtn];
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
    sendButton.tag = 1300;
    [sendButton setBackgroundImage:[UIImage imageNamed:@"fasong"] forState:UIControlStateNormal];
    [sendButton setBackgroundImage:[UIImage imageNamed:@"fasongdianji"] forState:UIControlStateHighlighted];
    [sendButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_inputView addSubview:sendButton];
    //改昵称到意见反馈
    whiteView = [[UIView alloc]initWithFrame:CGRectMake(320, View.frame.size.height-169, 100, 125)];
    whiteView.backgroundColor = [UIColor whiteColor];
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
        [NYButton addTarget:self action:@selector(buttonTap:) forControlEvents:UIControlEventTouchUpInside];
        [whiteView addSubview:NYButton];
    }
    
    //改昵称背景
    nickView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    nickView.alpha = 0.3;
    nickView.backgroundColor = [UIColor blackColor];
    nickView.hidden = YES;
    nickView.tag = 105;
    [self.view addSubview:nickView];
    UITapGestureRecognizer *nickTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(liveClick:)];
    [nickView addGestureRecognizer:nickTap];
    
    //修改昵称的背景
    nameView = [[UIView alloc]initWithFrame:CGRectMake(10, 250, kScreenWidth-20, 120)];
    nameView.backgroundColor = [UIColor whiteColor];
    nameView.hidden = YES;
    nameView.layer.borderColor = [UIColor clearColor].CGColor;
    nameView.layer.borderWidth = 0.2;
    nameView.layer.cornerRadius = 5;
    [self.view addSubview:nameView];
    //原昵称
    UILabel *YNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, 60, 15)];
    YNameLabel.text = @"原昵称：";
    YNameLabel.font = [UIFont systemFontOfSize:14];
    YNameLabel.textColor = [UIColor lightGrayColor];
    YNameLabel.backgroundColor = [UIColor clearColor];
    [nameView addSubview:YNameLabel];
    
    UILabel *MGNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(90, 10, 190, 15)];
    MGNameLabel.text = [NSString stringWithFormat:@"%@",self.allModel.nick_name];
    MGNameLabel.font = [UIFont systemFontOfSize:14];
    MGNameLabel.textColor = [UIColor lightGrayColor];
    MGNameLabel.textAlignment = NSTextAlignmentRight;
    MGNameLabel.backgroundColor = [UIColor clearColor];
    [nameView addSubview:MGNameLabel];
    
    UIView *bagNameView = [[UIView alloc]initWithFrame:CGRectMake(10, 35, 280, 35)];
    bagNameView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    bagNameView.layer.borderWidth = 0.3;
    [nameView addSubview:bagNameView];
    //改昵称输入框
    GTextField = [[UITextField alloc]initWithFrame:CGRectMake(5, 0, 270, 35)];
    GTextField.delegate = self;
    GTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [bagNameView addSubview:GTextField];
    
    UIImageView *GImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 85, 300, 0.3)];
    GImageView.backgroundColor = [UIColor lightGrayColor];
    [nameView addSubview:GImageView];
    UIImageView *SimageView = [[UIImageView alloc]initWithFrame:CGRectMake(150, 85, 0.3, 35)];
    SimageView.backgroundColor = [UIColor lightGrayColor];
    [nameView addSubview:SimageView];
    //取消button
    UIButton *QxButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 85, 150, 35)];
    [QxButton setTitle:@"取消" forState:UIControlStateNormal];
    [QxButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [QxButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    QxButton.titleLabel.font = [UIFont systemFontOfSize:14];
    QxButton.tag = 112;
    [QxButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [nameView addSubview:QxButton];
    //确定button
    UIButton *QdButton = [[UIButton alloc]initWithFrame:CGRectMake(150, 85, 150, 35)];
    [QdButton setTitle:@"确定修改" forState:UIControlStateNormal];
    [QdButton setTitleColor:textFontColor forState:UIControlStateNormal];
    QdButton.titleLabel.font = [UIFont systemFontOfSize:14];
    QdButton.tag = 111;
    [QdButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [nameView addSubview:QdButton];
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

    //快捷礼物
    UIImageView *shortcutGifImageView = [[UIImageView alloc]initWithFrame:CGRectMake(285, 450, 30, 30)];
    shortcutGifImageView.image = [UIImage imageNamed:@"luwu"];
    [self.view addSubview:shortcutGifImageView];
    UILabel *shortLabel = [[UILabel alloc]initWithFrame:CGRectMake(7, 20, 18, 9)];
    shortLabel.text = @"x10";
    shortLabel.font = [UIFont systemFontOfSize:10];
    shortLabel.textColor = [UIColor whiteColor];
    shortLabel.backgroundColor = [UIColor clearColor];
    [shortcutGifImageView addSubview:shortLabel];
    //羽毛
    UIImageView *featherImageView = [[UIImageView alloc]initWithFrame:CGRectMake(285, 485, 30, 30)];
    featherImageView.userInteractionEnabled = YES;
    featherImageView.tag = 1000;
    featherImageView.image = [UIImage imageNamed:@"yumao@"];
    [self.view addSubview:featherImageView];
    
    UITapGestureRecognizer *featherTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(liveClick:)];
    [featherImageView addGestureRecognizer:featherTap];
    
    _featherLabel = [[UILabel alloc]initWithFrame:CGRectMake(7, 18, 28, 9)];
    _featherLabel.textAlignment = NSTextAlignmentCenter;
    _featherLabel.text = @"x0";
    _featherLabel.font = [UIFont systemFontOfSize:10];
    _featherLabel.textColor = [UIColor whiteColor];
    _featherLabel.backgroundColor = [UIColor clearColor];
    [featherImageView addSubview:_featherLabel];
    
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
        //标题名字
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(i*80, 10, 80, 15)];
        titleLabel.text = @"虚位以待";
        titleLabel.tag = 900 + i;
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont systemFontOfSize:12];
        [_backView addSubview:titleLabel];
        //头像圈
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(7.5+i*80, 30, 65, 65)];
        imageView.image = [UIImage imageNamed:@"xuweiyidai"];
        imageView.backgroundColor = [UIColor clearColor];
        [_backView addSubview:imageView];
        //头像
        UIImageView *headView = [[UIImageView alloc] initWithFrame:CGRectMake(15+i*80, 38, 50, 50)];
        [headView makeBoundImage];
        headView.tag = 400 + i;
        headView.backgroundColor = [UIColor clearColor];
        [_backView addSubview:headView];
        //抢座图片
        UIImageView *QImageView = [[UIImageView alloc]initWithFrame:CGRectMake(21+i*80, 100, 38, 18)];
        QImageView.tag = 1 + i;
        QImageView.userInteractionEnabled = YES;
        QImageView.image = [UIImage imageNamed:@"qiangzuo"];
        [_backView addSubview:QImageView];
        
        UITapGestureRecognizer *grabTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(liveClick:)];
        [QImageView addGestureRecognizer:grabTap];
    }
    
}
/**********************************************************************************************************/
#pragma mark - UIAlertViewDelegate methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (alertView.tag) {
        case 100: {
            nickView.hidden = YES;
            nameView.hidden = YES;
            [self textFieldShouldReturn:GTextField];
        }
            break;
        case 120:
            break;
        default: {
            switch (buttonIndex) {
                case 0:
                    [self requestWithGrab:1];
                    break;
                case 1: {
                    if ([mMPayer isPlaying]) {
                        [mMPayer reset];
                        [mMPayer setVideoShown:NO];
                    }
                    LoginViewController *loginViewController = [[LoginViewController alloc] init];
                    loginViewController.controllerType = playType;
                    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:loginViewController];
                    [self presentViewController:navigationController animated:YES completion:^{
                        
                    }];
                }
                    break;
                default:
                    break;
            }
        }
            break;
    }
}

#pragma mark - 点击事件
- (void)buttonClick:(UIButton *)button
{
    if (button.tag == 100) {
        [mMPayer reset];
        [mMPayer unSetupPlayer];
        [self dismissViewControllerAnimated:YES completion:nil];
    } else if (button.tag == 101) { //关注
        if ([CommonUtil isLogin]) {
            if (button.selected) {
                [self requestWithFollowing:@"del_following" tag:601];
            } else {
                [self requestWithFollowing:@"add_following" tag:600];
            }
        } else {
            [CommonUtil loginAlertViewShow:self];
        }
    } else if (button.tag == 1200) { //悄悄话
        button.selected = !button.selected;
        if (button.selected) {
            _isPrivateis = YES;
        } else {
            _isPrivateis = NO;
        }
        [self refreshChatTextField:_chatPeopleLabel.text];
    } else if (button.tag == 1300) { //发送消息
        if (_chatTextField.text.length && _chatTextField.text) {
            NSDictionary *message = [NSDictionary dictionary];
            NSRange range = [_chatTextField.placeholder rangeOfString:@"悄悄"];
            if ([_chatTextField.placeholder isEqualToString:@"对所有人说"] || [_chatTextField.placeholder isEqualToString:@"点此输入文字聊天"]) { //公聊
                message = @{@"msg": @{@"content": _chatTextField.text,
                                                    @"level": [self getUserLevel:_model.finance],
                                                    @"from_medals": @"{}"
                                                    }};
            } else if (range.location != NSNotFound) { //对某人私聊
                NSDictionary *peopleJson = @{@"private": @"1",
                                             @"_id": _userModel._id,
                                             @"nick_name": _userModel.nick_name,
                                             @"level": [self getUserLevel:_userModel.finance]
                                             };
                message = @{@"msg": @{@"content": _chatTextField.text,
                                      @"level": [self getUserLevel:_model.finance],
                                      @"from_medals": @"{}",
                                      @"to": peopleJson
                                      }};
            } else { //对某人公聊
                NSDictionary *peopleJson = @{@"private": @"0",
                                             @"_id": _userModel._id,
                                             @"nick_name": _userModel.nick_name,
                                             @"level": [self getUserLevel:_userModel.finance]
                                             };
                message = @{@"msg": @{@"content": _chatTextField.text,
                                      @"level": [self getUserLevel:_model.finance],
                                      @"from_medals": @"{}",
                                      @"to": peopleJson
                                      }};
            }
            [self sendMessage:message];
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
    } else if (button.tag == 111) {
        if ((GTextField.text.length <= 18) && (GTextField.text.length >= 2)) {
            [self requestGname];
        }else{
            UIAlertView *alert = [[UIAlertView alloc]init];
            alert.title = @"修改失败";
            alert.message = @"昵称长度为2-18位，请重新输入";
            [alert addButtonWithTitle:@"确定"];
            alert.delegate = self;
            [alert show];
        }
    } else if (button.tag == 112) {
        nickView.hidden = YES;
        nameView.hidden = YES;
    } else if (button.tag == 120) {
        robSofaBagView.hidden = YES;
        robSofaView.hidden = YES;
    } else if (button.tag == 121) {
        [self requestWithGrab:JBStr/100];
        robSofaBagView.hidden = YES;
        robSofaView.hidden = YES;
    } else if (button.tag == 122) {
        JBStr = JBStr+100;
        JBLabel.text = [NSString stringWithFormat:@"%d金币",JBStr];
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
- (void)buttonTap:(UIButton *)button
{
    switch (button.tag) {
        case 900: {
            if (button.selected) {
                nickView.hidden = YES;
                nameView.hidden = YES;
            }else {
                nickView.hidden = NO;
                nameView.hidden = NO;
            }
        }
            break;
        case 901: {
            BroadcastViewController *broadcast = [[BroadcastViewController alloc]init];
            UINavigationController *nc = [[UINavigationController alloc]initWithRootViewController:broadcast];
            [self presentViewController:nc animated:YES completion:nil];
        }
            break;
        case 902: {
            SongViewController *song = [[SongViewController alloc]init];
            song.userId = self.allModel._id;
            song.live_id = _live_id;
            UINavigationController *nc = [[UINavigationController alloc]initWithRootViewController:song];
            [self presentViewController:nc animated:YES completion:nil];
        }
            break;
        case 903: {
            SetViewController *set = [[SetViewController alloc]init];
            UINavigationController *nc = [[UINavigationController alloc]initWithRootViewController:set];
            [self presentViewController:nc animated:YES completion:nil];
        }
            break;
        case 904: {
            FeedbackViewController *feed = [[FeedbackViewController alloc]init];
            UINavigationController *nc = [[UINavigationController alloc]initWithRootViewController:feed];
            [self presentViewController:nc animated:YES completion:nil];
        }
            break;
        default:
            break;
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

- (void)gestureTap:(UITapGestureRecognizer *)tap
{
    _chooseTableView.hidden = !_chooseTableView.hidden;
}

#pragma mark - 点击播放界面方法
- (void)liveClick:(UITapGestureRecognizer *)sender
{
    switch (sender.view.tag) {
        case 100: {
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
            break;
        case 101: {
            if ([mMPayer isPlaying]) {
                [mMPayer reset];
                [mMPayer setVideoShown:NO];
            }
            _classifyView.hidden = !_classifyView.hidden;
            DatumViewController *datum = [[DatumViewController alloc] init];
            datum.userId = self.allModel._id;
            [self presentViewController:datum animated:YES completion:nil];
        }
            break;
        case 102: {
            [self.view addSubview:_shareView];
            NSString *liveAddress = [NSString stringWithFormat:@"http://www.izhubo.com/%@",self.allModel._id];
            NSString *shareText = [NSString stringWithFormat:@"我正在%@的直播间玩耍,小伙伴快快加入吧! %@",self.allModel.nick_name,liveAddress];
            [_shareView shareWithText:shareText shareImageUrl:self.allModel.pic shareUrl:liveAddress controller:self];
        }
            break;
        case 103: {
            if (tap) {
                gifView.hidden = YES;
                blackView.hidden = YES;
            } else {
                gifView.hidden = NO;
                blackView.hidden = NO;
            }
        }
            break;
        case 104: {
            if (tap) {
                gifView.hidden = NO;
                blackView.hidden = NO;
                
            }else {
                gifView.hidden = YES;
                blackView.hidden = YES;
            }

        }
            break;
        case 105: {
            nickView.hidden = YES;
            nameView.hidden = YES;
            [self textFieldShouldReturn:GTextField];
        }
            break;
        case 106: {
            robSofaBagView.hidden = YES;
            robSofaView.hidden = YES;
        }
            break;
        case 1000: {    //增加羽毛
            if ([CommonUtil isLogin]) {
                [self requestWithFeather:@"feather/amass" tag:1000];
            } else {
                [CommonUtil loginAlertViewShow:self];
            }
        }
            break;
        case 1:
        case 2:
        case 3:
        case 4: {
            _grabTag = sender.view.tag;
            [self robSofa];
        }
            break;
        default:
            break;
    }
    
}
//抢沙发
-  (void)robSofa
{
    robSofaBagView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    robSofaBagView.alpha = 0.5;
    robSofaBagView.tag = 106;
    robSofaBagView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:robSofaBagView];
    
    UITapGestureRecognizer *sofatap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(liveClick:)];
    [robSofaBagView addGestureRecognizer:sofatap];
    
    robSofaView = [[UIView alloc]initWithFrame:CGRectMake(15, 220, kScreenWidth-30, 150)];
    robSofaView.backgroundColor = [UIColor whiteColor];
    robSofaView.layer.cornerRadius = 5;
    [self.view addSubview:robSofaView];
    
    UILabel *sofaLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 150, 15)];
    sofaLabel.text = @"抢占该座位最少需要";
    sofaLabel.textColor = [UIColor lightGrayColor];
    sofaLabel.font = [UIFont systemFontOfSize:12];
    [robSofaView addSubview:sofaLabel];
    
    UIImageView *JBImageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 65, 23, 23)];
    JBImageView.image = [UIImage imageNamed:@"jinbi"];
    [robSofaView addSubview:JBImageView];
    
    JBLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 65, 100, 23)];
    JBLabel.text = [NSString stringWithFormat:@"%d金币",100];
    JBLabel.textColor = [UIColor lightGrayColor];
    JBLabel.font = [UIFont systemFontOfSize:13];
    [robSofaView addSubview:JBLabel];
    
    UIButton *JJButton = [[UIButton alloc]initWithFrame:CGRectMake(180, 65, 100, 23)];
    [JJButton setTitle:@"我要加价" forState:UIControlStateNormal];
    [JJButton setTitleColor:textFontColor forState:UIControlStateNormal];
    JJButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:13];
    JJButton.tag = 122;
    [JJButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [robSofaView addSubview:JJButton];
    
    UIImageView *HXXImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 108, robSofaView.frame.size.width, 0.3)];
    HXXImageView.backgroundColor = [UIColor lightGrayColor];
    [robSofaView addSubview:HXXImageView];
    
    UIImageView *SxxImageView = [[UIImageView alloc]initWithFrame:CGRectMake(robSofaView.frame.size.width/2, 112, 0.3, 35)];
    SxxImageView.backgroundColor = [UIColor lightGrayColor];
    [robSofaView addSubview:SxxImageView];
    
    UIButton *songQXButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 110, robSofaView.frame.size.width/2-1, 40)];
    [songQXButton setTitle:@"取消" forState:UIControlStateNormal];
    [songQXButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    songQXButton.titleLabel.font = [UIFont systemFontOfSize:13];
    songQXButton.tag = 120;
    [songQXButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [robSofaView addSubview:songQXButton];
    
    UIButton *songQDButton = [[UIButton alloc]initWithFrame:CGRectMake(robSofaView.frame.size.width/2+1, 110, robSofaView.frame.size.width/2-1, 40)];
    [songQDButton setTitle:@"确定" forState:UIControlStateNormal];
    [songQDButton setTitleColor:textFontColor forState:UIControlStateNormal];
    songQDButton.titleLabel.font = [UIFont systemFontOfSize:13];
    songQDButton.tag = 121;
    [songQDButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [robSofaView addSubview:songQDButton];
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
            [self tapNickWithCell:cell chatModel:chatModel];
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
            [self tapNickWithCell:cell chatModel:chatModel];
            return cell;
        }
            break;
        case 1002: {    //私聊
            ChatCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChatCell"];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"ChatCell" owner:self options:nil] lastObject];
            }
            ChatModel *chatModel = [_privateArray objectAtIndex:indexPath.row];
            [cell loadContentWithModel:chatModel];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [self tapNickWithCell:cell chatModel:chatModel];
            return cell;
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
        case 500: {     //聊天对象
            static NSString *identifier = @"cell";
            UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1];
            cell.textLabel.text = [[_chooseArray objectAtIndex:indexPath.row] nick_name];
            cell.textLabel.font = [UIFont systemFontOfSize:13.0];
            return cell;
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
        case 500:
            return _chooseArray.count;
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
            ChatModel *chatModel = [_privateArray objectAtIndex:indexPath.row];
            CGRect rect = [chatModel.content boundingRectWithSize:CGSizeMake(304.0, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0]} context:nil];
            return rect.size.height + 30.0;
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
        case 500: {
            return 24.0;
        }
            break;
        default:
            break;
    }
    
    return 0.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (tableView.tag) {
        case 500: {
            UserInfoModel *user = [_chooseArray objectAtIndex:indexPath.row];
            [self requestUserInfo:@"user_info" userId:user._id tag:300];
            _chatPeopleLabel.text = user.nick_name;
            [_chooseTableView setHidden:YES];
            [self refreshChatTextField:user.nick_name];
        }
            break;
            
        default:
            break;
    }
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
    [def addObserver:self
            selector:@selector(refreshPlayView:)
                name:REFRESH_PLAYVIEW_NOTIFITION
              object:nil];
}

- (void)applicationDidEnterForeground:(NSNotification *)notification
{
//    [mMPayer setVideoShown:YES];
    if (![mMPayer isPlaying]) {
        [mMPayer setDataSource:self.videoURL];
        [mMPayer prepareAsync];
        [self.activityView setHidden:NO];
        [_liveImgView setHidden:NO];
    }
}

- (void)applicationDidEnterBackground:(NSNotification *)notification
{
    if ([mMPayer isPlaying]) {
        [mMPayer reset];
//        [mMPayer setVideoShown:NO];
    }
}

- (void)refreshPlayView:(NSNotification *)notifition
{
//    [mMPayer setVideoShown:YES];
    if (![mMPayer isPlaying]) {
        [mMPayer setDataSource:self.videoURL];
        [mMPayer prepareAsync];
        [self.activityView setHidden:NO];
        [_liveImgView setHidden:NO];
    }
}

#pragma mark VMediaPlayerDelegate Implement / Required

- (void)mediaPlayer:(VMediaPlayer *)player didPrepared:(id)arg
{
    [self.activityView setHidden:YES];
    [_liveImgView setHidden:YES];
    [player start];
}

- (void)mediaPlayer:(VMediaPlayer *)player playbackComplete:(id)arg
{
    
}

- (void)mediaPlayer:(VMediaPlayer *)player error:(id)arg
{
    [self.activityView setHidden:YES];
    [_liveImgView setHidden:YES];
}

# pragma mark - socket.IO-objc delegate methods
- (void)socketIODidConnect:(SocketIO *)socket
{
    NSLog(@"socket.io connected.");
}

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
                    NSNumber *_id = [data_d objectForKey:@"_id"];
                    if (nick_name.length) {
                        chatModel.nick_name = nick_name;
                    }
                    chatModel._id = _id;
                }
                [self reloadDataWithTableView:_synthesizeTableView dataArray:_dataArray chatModel:chatModel];
            } else if ([action isEqualToString:@"gift.notify"]) {
                chatModel.chatType = giftType;
                id data_d = [result objectForKey:@"data_d"];
                if ([data_d isKindOfClass:[NSDictionary class]]) {
                    NSDictionary *fromDic = [data_d objectForKey:@"from"];
                    NSString *fromNick = [[fromDic objectForKey:@"nick_name"] stringByTrimmingLeftCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                    NSNumber *_id = [fromDic objectForKey:@"_id"];
                    if (fromNick.length) {
                        chatModel.nick_name = fromNick;
                    }
                    chatModel._id = _id;
                    NSDictionary *toDic = [data_d objectForKey:@"to"];
                    NSString *toNick = [[toDic objectForKey:@"nick_name"] stringByTrimmingLeftCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                    NSNumber *to_id = [toDic objectForKey:@"_id"];
                    if (toNick.length) {
                        chatModel.toNick_name = toNick;
                    }
                    chatModel.to_id = to_id;
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
                NSNumber *_id = [data_d objectForKey:@"_id"];
                if (nick_name.length) {
                    chatModel.nick_name = nick_name;
                }
                chatModel._id = _id;
                [self reloadDataWithTableView:_synthesizeTableView dataArray:_dataArray chatModel:chatModel];
            }
        } else {
            NSNumber *private = [[NSNumber alloc] init];
            NSString *content = [result objectForKey:@"content"];
            NSNumber *level = [result objectForKey:@"level"];
            NSDictionary *fromDic = [result objectForKey:@"from"];
            NSString *nick_name = [[fromDic objectForKey:@"nick_name"] stringByTrimmingLeftCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            NSNumber *_id = [fromDic objectForKey:@"_id"];
            NSDictionary *toDic = [result objectForKey:@"to"];
            if (toDic) {
                chatModel.chatType = tellTAType;
                NSString *toNick = [[toDic objectForKey:@"nick_name"] stringByTrimmingLeftCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                NSNumber *to_id = [toDic objectForKey:@"_id"];
                chatModel.toNick_name = toNick;
                chatModel.to_id = to_id;
                private = [toDic objectForKey:@"private"];
            } else {
                chatModel.chatType = contentType;
                private = [NSNumber numberWithInt:0];
            }
            if (nick_name.length) {
                chatModel.nick_name = nick_name;
                chatModel._id = _id;
                chatModel.content = content;
                chatModel.level = level;
            }
            if (private.intValue == 1) {
                [self reloadDataWithTableView:_privateTableView dataArray:_privateArray chatModel:chatModel];
            } else {
                [self reloadDataWithTableView:_synthesizeTableView dataArray:_dataArray chatModel:chatModel];
                [self reloadDataWithTableView:_publicTableView dataArray:_publicDataArray chatModel:chatModel];
            }
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
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_chooseTableView setHidden:YES];
    [_chatTextField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSRange range = [_chatTextField.placeholder rangeOfString:@"悄悄"];
    if (range.location != NSNotFound) {
        _privateBtn.selected = YES;
        _isPrivateis = YES;
    } else {
        _privateBtn.selected = NO;
        _isPrivateis = NO;
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if ([CommonUtil isLogin]) {
        return YES;
    } else {
        [CommonUtil loginAlertViewShow:self];
        return NO;
    }
}

#pragma mark - 键盘通知
- (void)keyboardWasShown:(NSNotification *)notif
{
    NSDictionary *info = [notif userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    
    NSLog(@"keyBoard:%f", keyboardSize.height);  //216 184 252
    _inputView.frame = CGRectMake(0, kScreenHeight-keyboardSize.height - 75, kScreenWidth, 75);
    chatBView.frame = CGRectMake(5, 38, 250, 30);
    [_inputView addSubview:chatBView];
    _chooseTableView.frame = CGRectMake(5, _inputView.frame.origin.y - 130, 130, 130);
    chatView.hidden = YES;
}

- (void)keyboardWasHidden:(NSNotification *)notif
{
    NSDictionary *info = [notif userInfo];
    
    NSValue *value = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    NSLog(@"keyboardWasHidden keyBoard:%f", keyboardSize.height);
    _inputView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 75);
    chatBView.frame = CGRectMake(5, 5, 260, 35);
    [chatView addSubview:chatBView];
    chatView.hidden = NO;
}

#pragma mark - request
- (void)requestUserInfo:(NSString *)param userId:(NSNumber *)userId tag:(NSInteger)tag
{
    NSString *urlStr = [NSString stringWithFormat:@"%@zone/%@/%@",BaseURL,param,userId];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [request setTimeOutSeconds:100];
    request.delegate = self;
    request.tag = tag;
    [request startAsynchronous];
}

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

- (void)requestWithFeather:(NSString *)param tag:(NSInteger)tag
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/%@",BaseURL,param,_model.access_token];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [request setTimeOutSeconds:100];
    request.delegate = self;
    request.tag = tag;
    [request startAsynchronous];
}

- (void)requestWithGrab:(NSInteger)num
{
    NSString *urlStr = [NSString stringWithFormat:@"%@live/grab_sofa%ld/%@/%@/%ld",BaseURL,(long)_grabTag,_model.access_token,self.allModel._id,(long)num];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [request setTimeOutSeconds:100];
    request.delegate = self;
    request.tag = _grabTag;
    [request startAsynchronous];
}
- (void)requestGname
{
    NSString *strUrl = [NSString stringWithFormat:@"%@user/edit/%@",BaseURL,_model.access_token];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:strUrl]];
    request.delegate = self;
    NSString *str = [NSString stringWithFormat:@"%@",GTextField.text];
    [request setPostValue:str forKey:@"nick_name"];
    [request startAsynchronous];
    request.tag = 400;
    
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    id result = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
    if ([result isKindOfClass:[NSDictionary class]]) {
        NSNumber *code = [result objectForKey:@"code"];
        if (code.intValue == 1) {
            switch (request.tag) {
                case 300: { //个人信息
                    NSDictionary *dataDic = [result objectForKey:@"data"];
                     _userModel = [[UserInfoModel alloc] init];
                    [_userModel getUserInfoWithDictionary:dataDic];
                    [self requestUserInfo:@"user_medal" userId:_userModel._id tag:301];
                }
                    break;
                case 301: { //徽章信息
                    NSArray *dataArr = [result objectForKey:@"data"];
                    for (NSDictionary *dic in dataArr) {
                        BadgeModel *badgeModel = [[BadgeModel alloc] init];
                        [badgeModel getBadgeModelWithDictionary:dic];
                        [_badgeArray addObject:badgeModel];
                    }
                    [self refreshChatSelectView:_userModel];
                }
                    break;
                case 500: { //本场观众
                    NSArray *dataArr = [result objectForKey:@"data"];
                    for (NSDictionary *dic in dataArr) {
                        RankingModel *rankModel = [[RankingModel alloc] init];
                        [rankModel getRankModelWithDictionary:dic];
                        [_homeCourseArray addObject:rankModel];
                    }
                    [_homeCourseTableView reloadData];
                }
                    break;
                case 501: { //月榜
                    if ([result isKindOfClass:[NSDictionary class]]) {
                        NSArray *dataArr = [result objectForKey:@"data"];
                        for (NSDictionary *dic in dataArr) {
                            RankingModel *rankModel = [[RankingModel alloc] init];
                            [rankModel getRankModelWithDictionary:dic];
                            [_monthArray addObject:rankModel];
                        }
                        [_monthTableView reloadData];
                    }
                }
                    break;
                case 502: { //总榜
                    if ([result isKindOfClass:[NSDictionary class]]) {
                        NSArray *dataArr = [result objectForKey:@"data"];
                        for (NSDictionary *dic in dataArr) {
                            RankingModel *rankModel = [[RankingModel alloc] init];
                            [rankModel getRankModelWithDictionary:dic];
                            [_alwaysArray addObject:rankModel];
                        }
                        [_alwaysTableView reloadData];
                    }
                }
                    break;
                case 600: { //添加关注
                    attentionButton.selected = YES;
                }
                    break;
                case 601: { //取消关注
                    attentionButton.selected = NO;
                }
                    break;
                case 602: { //关注列表
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
                    break;
                case 700: { //主播羽毛
                    NSDictionary *dataDic = [result objectForKey:@"data"];
                    NSDictionary *userDic = [dataDic objectForKey:@"user"];
                    NSDictionary *financeDic = [userDic objectForKey:@"finance"];
                    NSNumber *featherNum = [financeDic objectForKey:@"feather_receive_total"];
                    _quantityLabel.text = featherNum.stringValue;
                    NSDictionary *roomDic = [dataDic objectForKey:@"room"];
                    _live_id = [roomDic objectForKey:@"live_id"];
                }
                    break;
                case 800: { //沙发
                    NSDictionary *dataDic = [result objectForKey:@"data"];
                    NSArray *userArr = [dataDic objectForKey:@"user"];
                    NSArray *sofaArr = [dataDic objectForKey:@"sofa"];
                    for (NSDictionary *dic in userArr) {
                        RankingModel *rankModel = [[RankingModel alloc] init];
                        [rankModel getRankModelWithDictionary:dic];
                        [_userArray addObject:rankModel];
                    }
                    for (NSDictionary *dic in sofaArr) {
                        RankingModel *rankModel = [[RankingModel alloc] init];
                        [rankModel getRankModelWithDictionary:dic];
                        [_sofaArray addObject:rankModel];
                    }
                    [self refreshSofaView];
                    
                }
                    break;
                case 900: { //自己羽毛数量
                    NSDictionary *dataDic = [result objectForKey:@"data"];
                    NSDictionary *financeDic = [dataDic objectForKey:@"finance"];
                    NSNumber *feather_count = [financeDic objectForKey:@"feather_count"];
                    if (feather_count) {
                        _featherLabel.text = [NSString stringWithFormat:@"x%@",feather_count];
                    }
                }
                    break;
                case 1000: { //增加羽毛数

                }
                    break;
                case 1:
                case 2:
                case 3:
                case 4: {
                    [self requestWithInfo:@"room_sofa" tag:800];
                }
                    break;
                case 400: {
                    UIAlertView *alert = [[UIAlertView alloc]init];
                    alert.title = @"修改昵称提示";
                    alert.message = @"修改成功";
                    [alert addButtonWithTitle:@"确定"];
                    alert.tag = 100;
                    alert.delegate = self;
                    [alert show];
                }
                    break;
            default:
                break;
            }
        } else {
            switch (code.intValue) {
                case 30412: {
                    [self showGrabErrorAlert:@"余额不足，请充值" requestTag:_grabTag];
                }
                    break;
                case 30420: {
                    [self showGrabErrorAlert:@"沙发已经被捷足先登了，来！再战一次！" requestTag:_grabTag];
                }
                    break;
                case 30415: {
                    [self showGrabErrorAlert:@"房间已经关闭直播" requestTag:_grabTag];
                }
                    break;
                default:
                    break;
            }
        }
    }
}

#pragma mark - show/refreshView
//点击cell上昵称
- (void)tapNickWithCell:(ChatCell *)cell chatModel:(ChatModel *)chatModel
{
    __block PlayViewController *playVC = self;
    cell.nickTapBlock = ^(NSInteger tag) {
        switch (tag) {
            case 50: {  //第一个昵称
                if ([playVC.model.userName isEqualToString:chatModel.nick_name]) {
                    [[[UIAlertView alloc] initWithTitle:@"提示" message:@"不能对自己操作" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
                } else {
                    [playVC requestUserInfo:@"user_info" userId:chatModel._id tag:300];
                    [playVC.view addSubview:_chatSelectView];
                }
            }
                break;
            case 60: {  //第二个昵称
                if ([playVC.model.userName isEqualToString:chatModel.toNick_name]) {
                    [[[UIAlertView alloc] initWithTitle:@"提示" message:@"不能对自己操作" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
                } else {
                    [playVC requestUserInfo:@"user_info" userId:chatModel.to_id tag:300];
                    [playVC.view addSubview:_chatSelectView];
                }
            }
                break;
            default:
                break;
        }
    };
}
//弹出alertView
- (void)showGrabErrorAlert:(NSString *)message requestTag:(NSInteger)tag
{
    switch (tag) {
        case 1:
        case 2:
        case 3:
        case 4: {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            alertView.tag = 120;
            [alertView show];
        }
            break;
        default:
            break;
    }
}

//是否关注
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

//刷新聊天选框
- (void)refreshChatSelectView:(UserInfoModel *)userModel
{
    [_chatSelectView.headImgView makeBoundImage];
    [_chatSelectView.headImgView setImageWithURL:[NSURL URLWithString:userModel.pic] placeholderImage:[UIImage imageNamed:@"xuweiyidaitouxiang"]];
    if (userModel.nick_name.length) {
        [_chatSelectView.nickNameLab setText:userModel.nick_name];
    }
    if (userModel.finance) {
        NSInteger richCoin = [[userModel.finance objectForKey:@"coin_spend_total"] intValue];
        NSInteger richLevel = [CommonUtil getLevelInfoWithCoin:richCoin isRich:YES].level;
        NSString *richImage = [NSString stringWithFormat:@"%ldfu",(long)richLevel];
        [_chatSelectView.levelImgView setImage:[UIImage imageNamed:richImage]];
    }
    NSInteger count = _badgeArray.count;
    if (count > 6) {
        count = 6;
    }
    for (int i = 0; i <count; i++) {
        UIImageView *HzImageView = [[UIImageView alloc] initWithFrame:CGRectMake(65 + 25 * i, 48, 15, 15)];
        NSString *greyPic = [_badgeArray[i] grey_pic];
        [HzImageView setImageWithURL:[NSURL URLWithString:greyPic]];
        for (NSString *ids in _userModel.medals.allKeys) {
            if (ids.intValue == [_badgeArray[i] ID].intValue) {
                NSString *picUrl = [_badgeArray[i] pic_url];
                [HzImageView setImageWithURL:[NSURL URLWithString:picUrl]];
            }
        }
        [_chatSelectView.backView addSubview:HzImageView];
    }
    
    __block PlayViewController *playVC = self;
    _chatSelectView.selectTypeBlock = ^(NSInteger tag) {
        switch (tag) {
            case 10: {  //资料
                DatumViewController *datum = [[DatumViewController alloc] init];
                datum.userId = userModel._id;
                [playVC presentViewController:datum animated:YES completion:nil];
            }
                break;
            case 20: {  //公聊
                playVC.chatTextField.placeholder = [NSString stringWithFormat:@"对%@说",userModel.nick_name];
                for (UserInfoModel *users in playVC.chooseArray) {
                    if ([users.nick_name isEqualToString:userModel.nick_name]) {
                        [playVC.chooseArray removeObject:users];
                        break;
                    }
                }
                playVC.chatPeopleLabel.text = userModel.nick_name;
                [playVC.chooseArray addObject:userModel];
                [playVC.chooseTableView reloadData];
                [playVC.chatTextField becomeFirstResponder];
            }
                break;
            case 30: {  //私聊
                playVC.chatTextField.placeholder = [NSString stringWithFormat:@"悄悄对%@说",userModel.nick_name];
                for (UserInfoModel *users in playVC.chooseArray) {
                    if ([users.nick_name isEqualToString:userModel.nick_name]) {
                        [playVC.chooseArray removeObject:users];
                        break;
                    }
                }
                playVC.chatPeopleLabel.text = userModel.nick_name;
                [playVC.chooseArray addObject:userModel];
                [playVC.chooseTableView reloadData];
                [playVC.chatTextField becomeFirstResponder];
            }
                break;
            case 40: {  //送礼
                
            }
                break;
            default:
                break;
        }
    };
}

//刷新沙发
- (void)refreshSofaView
{
    for (int j = 0; j < _sofaArray.count; j++) {
        RankingModel *model = [_sofaArray objectAtIndex:j];
        switch (model.i.intValue) {
            case 1: {
                for (RankingModel *userModel in _userArray) {
                    if (model.xy_user_id.intValue == userModel._id.intValue) {
                        UILabel *nickLab = (UILabel *)[_backView viewWithTag:900];
                        [nickLab setText:userModel.nick_name];
                        if (userModel.pic.length) {
                            UIImageView *headImg = (UIImageView *)[_backView viewWithTag:400];
                            [headImg setImageWithURL:[NSURL URLWithString:userModel.pic]];
                        }
                    }
                }
            }
                break;
            case 2: {
                for (RankingModel *userModel in _userArray) {
                    if (model.xy_user_id.intValue == userModel._id.intValue) {
                        UILabel *nickLab = (UILabel *)[_backView viewWithTag:901];
                        [nickLab setText:userModel.nick_name];
                        if (userModel.pic.length) {
                            UIImageView *headImg = (UIImageView *)[_backView viewWithTag:401];
                            [headImg setImageWithURL:[NSURL URLWithString:userModel.pic]];
                        }
                    }
                }
            }
                break;
            case 3: {
                for (RankingModel *userModel in _userArray) {
                    if (model.xy_user_id.intValue == userModel._id.intValue) {
                        UILabel *nickLab = (UILabel *)[_backView viewWithTag:902];
                        [nickLab setText:userModel.nick_name];
                        if (userModel.pic.length) {
                            UIImageView *headImg = (UIImageView *)[_backView viewWithTag:402];
                            [headImg setImageWithURL:[NSURL URLWithString:userModel.pic]];
                        }
                    }
                }
            }
                break;
            case 4: {
                for (RankingModel *userModel in _userArray) {
                    if (model.xy_user_id.intValue == userModel._id.intValue) {
                        UILabel *nickLab = (UILabel *)[_backView viewWithTag:903];
                        [nickLab setText:userModel.nick_name];
                        if (userModel.pic.length) {
                            UIImageView *headImg = (UIImageView *)[_backView viewWithTag:403];
                            [headImg setImageWithURL:[NSURL URLWithString:userModel.pic]];
                        }
                    }
                }
            }
                break;
            default:
                break;
        }
    }
}

//刷新聊天输入框
- (void)refreshChatTextField:(NSString *)nick_name
{
    if (_isPrivateis) {
        _chatTextField.placeholder = [NSString stringWithFormat:@"悄悄对%@说",nick_name];
    } else {
        _chatTextField.placeholder = [NSString stringWithFormat:@"对%@说",nick_name];
    }
}

#pragma mark - sendMessage methods
//聊天
- (void)sendMessage:(NSDictionary *)message
{
    NSData *msgData = [CommonUtil toJSONData:message];
    NSString *msgJson = [[NSString alloc] initWithData:msgData
                                                 encoding:NSUTF8StringEncoding];
    [_socketIO sendMessage:msgJson];
    
    [_chooseTableView setHidden:YES];
    [_chatTextField resignFirstResponder];
    _chatTextField.text = @"";
}

- (NSString *)getUserLevel:(NSDictionary *)finance
{
    NSNumber *coinNum = [finance objectForKey:@"coin_spend_total"];
    NSString *level = [NSString stringWithFormat:@"%ld",(long)[CommonUtil getLevelInfoWithCoin:coinNum.intValue isRich:YES].level];
    return level;
}

@end
