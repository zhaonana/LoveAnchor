//
//  PlayViewController.m
//  LoveAnchor
//
//  Created by zhongqinglongtu on 14-9-18.
//  Copyright (c) 2014年 zhongqinglongtu. All rights reserved.
//

#import "PlayViewController.h"

@interface PlayViewController () <VMediaPlayerDelegate, UITextFieldDelegate>

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
    //观众榜里的button
    UIView *announcementView;
}

@property (nonatomic, strong) UIActivityIndicatorView *activityView;
@property (nonatomic, strong) NSURL                   *videoURL;

@end

@implementation PlayViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self shouwUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
 
    
    NSString *url = @"http://v.17173.com/api/5981245-4.m3u8";
//    NSString *url = [NSString stringWithFormat:@"rtmp://ttvpull.izhubo.com/live/%@",self.allModel._id];
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
    bagView.image = [UIImage imageNamed:@"liaotianbeijing"];
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
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 28)];
    imageView.backgroundColor = [UIColor whiteColor];
    imageView.userInteractionEnabled = YES;
    [View addSubview:imageView];
    
    UIImageView *HXImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 27.5, kScreenWidth, 0.5)];
    HXImageView.backgroundColor = [UIColor lightGrayColor];
    [imageView addSubview:HXImageView];
    
    //button背景
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
    UITableView *synthesizeTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, _scrollView.frame.size.height) style:UITableViewStylePlain];
    synthesizeTableView.delegate = self;
    synthesizeTableView.dataSource = self;
    synthesizeTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [_scrollView addSubview:synthesizeTableView];
    //公聊
    UITableView *publicTableView = [[UITableView alloc]initWithFrame:CGRectMake(kScreenWidth, 0, kScreenWidth, _scrollView.frame.size.height) style:UITableViewStylePlain];
    publicTableView.delegate = self;
    publicTableView.dataSource = self;
    publicTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [_scrollView addSubview:publicTableView];
    //私聊
    UITableView *privateTableView = [[UITableView alloc]initWithFrame:CGRectMake(kScreenWidth*2, 0, kScreenWidth, _scrollView.frame.size.height) style:UITableViewStylePlain];
    privateTableView.delegate = self;
    privateTableView.dataSource = self;
    privateTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [_scrollView addSubview:privateTableView];
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
    [giftButton setImage:[UIImage imageNamed:@"liwu"] forState:UIControlStateNormal];
    [giftButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [chatView addSubview:giftButton];
    //信息档案
    UIButton *manageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    manageButton.frame = CGRectMake(295, 12.5, 15, 20);
    [manageButton setImage:[UIImage imageNamed:@"zhuboxiangqing"] forState:UIControlStateNormal];
    [manageButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [chatView addSubview:manageButton];

    //观众榜
    UIScrollView *audienceScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(kScreenWidth*3, 0, kScreenWidth, _scrollView.frame.size.height)];
    audienceScrollView.contentSize = CGSizeMake(kScreenWidth *3, 0);
    audienceScrollView.showsHorizontalScrollIndicator = NO;
    audienceScrollView.showsVerticalScrollIndicator = NO;
    audienceScrollView.pagingEnabled = YES;
    audienceScrollView.delegate = self;
    [_scrollView addSubview:audienceScrollView];
    //本场观众
    UITableView *homeCourseTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, _scrollView.frame.size.height) style:UITableViewStylePlain];
    homeCourseTableView.delegate = self;
    homeCourseTableView.dataSource = self;
    homeCourseTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [audienceScrollView addSubview:homeCourseTableView];
    //月榜
    UITableView *monthTableView = [[UITableView alloc]initWithFrame:CGRectMake(kScreenWidth, 0, kScreenWidth, _scrollView.frame.size.height) style:UITableViewStylePlain];
    monthTableView.delegate = self;
    monthTableView.dataSource = self;
    monthTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [audienceScrollView addSubview:monthTableView];
    //总榜
    UITableView *alwaysTableView = [[UITableView alloc]initWithFrame:CGRectMake(kScreenWidth*2  , 0, kScreenWidth, _scrollView.frame.size.height) style:UITableViewStylePlain];
    alwaysTableView.delegate = self;
    alwaysTableView.dataSource = self;
    alwaysTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [audienceScrollView addSubview:alwaysTableView];
    
    announcementView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight-30, kScreenWidth, 30)];
    announcementView.userInteractionEnabled = YES;
    announcementView.hidden = YES;
    announcementView.backgroundColor = [UIColor redColor];
    [self.view addSubview:announcementView];
    
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
        NSLog(@"%ld",button.tag);
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
/**********************************************************************************************************/

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
    [UIView animateWithDuration:0 animations:^{
        [self changed];
    }];
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
    } else if (rect.origin.x == 80) {
        publicButton.selected = YES;
        publicButton.backgroundColor = textFontColor;
        audienceButton.backgroundColor = [UIColor clearColor];
        privateButton.backgroundColor = [UIColor clearColor];
        synthesizeButton.backgroundColor = [UIColor clearColor];
    } else if (rect.origin.x == 160) {
        privateButton.selected = YES;
        privateButton.backgroundColor = textFontColor;
        audienceButton.backgroundColor = [UIColor clearColor];
        publicButton.backgroundColor = [UIColor clearColor];
        synthesizeButton.backgroundColor = [UIColor clearColor];
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
/**********************************************************************************************************/
#pragma mark - tableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *idenifier = @"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idenifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idenifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 15;
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


@end
