//
//  StoreViewController.m
//  LoveAnchor
//
//  Created by zhongqinglongtu on 14-10-11.
//  Copyright (c) 2014年 zhongqinglongtu. All rights reserved.
//

#import "StoreViewController.h"

@interface StoreViewController ()
{
    UISegmentedControl *_segmented;
    NSArray *_labelTitle;
    NSArray *_labelTitleH;
    NSArray *_imageArray;
    NSArray *_namaLabelArray;
    NSArray *_moneyLabelArray;
    LoginModel *loginModel;
    NSArray *_TimeArray;
    NSArray *_purpleVMoneyArray;
    NSArray *_yellowVMoneyArray;
    int type;
    NSMutableArray *imageArray;
    NSMutableArray *namaArray;
    NSMutableArray *moneyArray;
    NSMutableArray *IDArray;
    UICollectionView *seatButtonView;
    LoginModel *model;
}

@property (nonatomic,strong)UIScrollView *bgScrollVIew;
@property (nonatomic,strong)UIScrollView *extremeScrollVIew;
@property (nonatomic,strong)UIScrollView *VipScrollVIew;
@property (nonatomic,strong)UIScrollView *seatScrollVIew;

@end

@implementation StoreViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        loginModel = [[LoginModel alloc]init];
        
        _labelTitle = [[NSArray alloc] initWithObjects:@"财富等级在10富及以上才能购买或拥有尊贵VIP勋章",@"尊贵VIP勋章，炫彩紫色昵称，彰显身份",@"发言限制100字，让你畅所欲言",@"可购买VIP专属礼物",@"除房主以外，防止被禁言",@"可进入已达到观众人数上限的房间",@"房间排位升至所有玩家之前",@"可隐身进入房间，观众列表不显示昵称", nil];
        
        _labelTitleH = [[NSArray alloc] initWithObjects:@"财富等级在3富及以上才能购买或拥有",@"尊贵VIP勋章，彰显身份",@"发言限制70字，让你畅所欲言",@"可购买VIP专属礼物",@"除房主以外，防止被禁言",@"可进入已达到观众人数上限的房间",@"房间排位升至10富玩家之前", nil];
        _purpleVMoneyArray = [NSArray arrayWithObjects:@"30000金币",@"82800金币",@"158400金币",@"216000金币", nil];
        _TimeArray = [NSArray arrayWithObjects:@"1个月",@"3个月",@"6个月",@"12个月", nil];
        _yellowVMoneyArray = [NSArray arrayWithObjects:@"10000金币",@"24000金币",@"42000金币",@"72000金币", nil];
        imageArray = [NSMutableArray array];
        namaArray = [NSMutableArray array];
        moneyArray = [NSMutableArray array];
        IDArray = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSData *myEncodedObject = [[NSUserDefaults standardUserDefaults] objectForKey:@"books"];
    model = [NSKeyedUnarchiver unarchiveObjectWithData: myEncodedObject];
    
    [self shouwUI];
    [self creadteView];
    
}
#pragma mark - 界面
- (void)shouwUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    titleButton.frame = CGRectMake(0, 0, 50, 44);
    titleButton.tag = 100;
    titleButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [titleButton setTitle:@"返回" forState:UIControlStateNormal];
    [titleButton setTitleColor:textFontColor forState:UIControlStateNormal];
    [titleButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar addSubview:titleButton];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(135, 0, 50, 44)];
    label.text = @"商城";
    label.font = [UIFont systemFontOfSize:18];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = textFontColor;
    [self.navigationController.navigationBar addSubview:label];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, 44)];
    imageView.backgroundColor = [UIColor whiteColor];
    imageView.userInteractionEnabled = YES;
    [self.view addSubview:imageView];
    
    NSArray *buttonArray = [NSArray arrayWithObjects:@"至尊VIP",@"VIP",@"座驾", nil];
    
    _segmented = [[UISegmentedControl alloc]initWithItems:buttonArray];
    [_segmented setFrame:CGRectMake(10, 8, 300, 28)];
    [_segmented setTintColor:textFontColor];
    _segmented.selectedSegmentIndex = 0;
    [_segmented addTarget:self action:@selector(segmentedClick:) forControlEvents:UIControlEventValueChanged];
    [imageView addSubview:_segmented];
    
    UIImageView *segImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 108, kScreenWidth, 0.5)];
    segImageView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:segImageView];
}

- (void)creadteView
{
    self.bgScrollVIew = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 109, kScreenWidth, 490)];
    self.bgScrollVIew.backgroundColor = [UIColor clearColor];
    self.bgScrollVIew.contentSize = CGSizeMake(kScreenWidth * 3, kScreenHeight *2);
    self.bgScrollVIew.scrollEnabled = NO;
    [self.view addSubview:self.bgScrollVIew];
    //紫V
    self.extremeScrollVIew = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight- 64- 44)];
    self.extremeScrollVIew.contentSize = CGSizeMake(kScreenWidth, 500);
    [self.bgScrollVIew addSubview:self.extremeScrollVIew];
    
    UIImageView *segImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 130)];
    segImageView.image = [UIImage imageNamed:@"ziV"];
    [self.extremeScrollVIew addSubview:segImageView];
    
    UILabel *tilLAbel = [[UILabel alloc]initWithFrame:CGRectMake(13, 260, 120, 13)];
    tilLAbel.text = @"至尊VIP专属特权：";
    tilLAbel.textColor = [UIColor purpleColor];
    tilLAbel.font = [UIFont systemFontOfSize:12];
    [self.extremeScrollVIew addSubview:tilLAbel];
    
    for (int i = 0; i < _labelTitle.count; i++) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(30, 280+i*28, kScreenWidth, 13)];
        label.text = [_labelTitle objectAtIndex:i];
        label.font = [UIFont systemFontOfSize:12];
        [self.extremeScrollVIew addSubview:label];
        
        UIImageView *starImageView = [[UIImageView alloc]initWithFrame:CGRectMake(13, 280+i*28, 10, 10)];
        starImageView.image = [UIImage imageNamed:@"xing"];
        [self.extremeScrollVIew addSubview:starImageView];
    }
    
    UICollectionViewFlowLayout *purpleFlowLayout = [[UICollectionViewFlowLayout alloc]init];
    purpleFlowLayout.itemSize = CGSizeMake(140, 44);//设置大小
    purpleFlowLayout.minimumInteritemSpacing = 0;//设置横向间距大小
    purpleFlowLayout.minimumLineSpacing = 10;//每列间距
    purpleFlowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;//布局改成从上到下 默认从左到右
    purpleFlowLayout.sectionInset = UIEdgeInsetsMake(15, 10, 10, 15);//Section Inset就是某个section中cell的边界范围
    
    UICollectionView *purpleButtonView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 130, kScreenWidth, 130) collectionViewLayout:purpleFlowLayout];
    purpleButtonView.backgroundColor = [UIColor whiteColor];
    purpleButtonView.delegate = self;
    purpleButtonView.dataSource = self;
    purpleButtonView.tag = 1000;
    [purpleButtonView registerClass:[YellowVCollectionViewCell class] forCellWithReuseIdentifier:@"purpleVCell"];
    [self.extremeScrollVIew addSubview:purpleButtonView];
    //黄V
    self.VipScrollVIew = [[UIScrollView alloc]initWithFrame:CGRectMake(kScreenWidth, 0, kScreenWidth, kScreenHeight- 64- 44)];
    self.VipScrollVIew.contentSize = CGSizeMake(kScreenWidth, 470);
    [self.bgScrollVIew addSubview:self.VipScrollVIew];
    
    UIImageView *VIPImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 130)];
    VIPImageView.image = [UIImage imageNamed:@"huangv"];
    [self.VipScrollVIew addSubview:VIPImageView];
    
    UILabel *tilLabel = [[UILabel alloc]initWithFrame:CGRectMake(13, 260, 120, 13)];
    tilLabel.text = @"VIP专属特权：";
    tilLabel.textColor = [UIColor orangeColor];
    tilLabel.font = [UIFont systemFontOfSize:12];
    [self.VipScrollVIew addSubview:tilLabel];
    
    for (int i = 0; i < _labelTitleH.count; i++) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(30, 280+i*28, kScreenWidth, 13)];
        label.text = [_labelTitleH objectAtIndex:i];
        label.font = [UIFont systemFontOfSize:12];
        [self.VipScrollVIew addSubview:label];
        
        UIImageView *starImageView = [[UIImageView alloc]initWithFrame:CGRectMake(13, 280+i*28, 10, 10)];
        starImageView.image = [UIImage imageNamed:@"xing"];
        [self.VipScrollVIew addSubview:starImageView];
    }
    
    UICollectionViewFlowLayout *yellowFlowLayout = [[UICollectionViewFlowLayout alloc]init];
    yellowFlowLayout.itemSize = CGSizeMake(140, 44);//设置大小
    yellowFlowLayout.minimumInteritemSpacing = 0;//设置横向间距大小
    yellowFlowLayout.minimumLineSpacing = 10;//每列间距
    yellowFlowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;//布局改成从上到下 默认从左到右
    yellowFlowLayout.sectionInset = UIEdgeInsetsMake(15, 10, 10, 15);//Section Inset就是某个section中cell的边界范围
    
    UICollectionView *yellowButtonView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 130, kScreenWidth, 130) collectionViewLayout:yellowFlowLayout];
    yellowButtonView.backgroundColor = [UIColor whiteColor];
    yellowButtonView.delegate = self;
    yellowButtonView.dataSource = self;
    yellowButtonView.tag = 1001;
    [yellowButtonView registerClass:[YellowVCollectionViewCell class] forCellWithReuseIdentifier:@"yellowVCell"];
    [self.VipScrollVIew addSubview:yellowButtonView];
    
    //座驾
    self.seatScrollVIew = [[UIScrollView alloc]initWithFrame:CGRectMake(kScreenWidth * 2, 0, kScreenWidth, self.bgScrollVIew.frame.size.height)];
    self.seatScrollVIew.scrollEnabled = NO;
    [self.bgScrollVIew addSubview:self.seatScrollVIew];
    
    UICollectionViewFlowLayout *seatFlowLayout = [[UICollectionViewFlowLayout alloc]init];
    seatFlowLayout.itemSize = CGSizeMake(80, 90);//设置大小
    seatFlowLayout.minimumInteritemSpacing = 0;//设置横向间距大小
    seatFlowLayout.minimumLineSpacing = 10;//每列间距
    seatFlowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;//布局改成从上到下 默认从左到右
    seatFlowLayout.sectionInset = UIEdgeInsetsMake(10, 15, 15, 15);//Section Inset就是某个section中cell的边界范围
    
    seatButtonView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, self.seatScrollVIew.frame.size.height) collectionViewLayout:seatFlowLayout];
    seatButtonView.backgroundColor = [UIColor clearColor];
    seatButtonView.delegate = self;
    seatButtonView.dataSource = self;
    seatButtonView.tag = 1003;
    [seatButtonView registerClass:[StorecollectionVIewCell class] forCellWithReuseIdentifier:@"seatCell"];
    [self.seatScrollVIew addSubview:seatButtonView];
}
#pragma mark - 点击事件
- (void)buttonClick:(UIButton *)button
{
    NSLog(@"11");
    if (button.tag == 100) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)segmentedClick:(UISegmentedControl *)seg
{
    NSLog(@"22");
    switch (seg.selectedSegmentIndex) {
        case 0:
            self.bgScrollVIew.contentOffset = CGPointMake(0, 0);
            break;
        case 1:
            self.bgScrollVIew.contentOffset = CGPointMake(kScreenWidth, 0);
            break;
        case 2:
            self.bgScrollVIew.contentOffset = CGPointMake(kScreenWidth *2, 0);
            [self seatRequest];
            break;
            
        default:
            break;
    }
}

#pragma mark - collectionView
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    switch (collectionView.tag) {
        case 1000: {
            NSLog(@"紫v");
            YellowVCollectionViewCell *purpleVCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"purpleVCell" forIndexPath:indexPath];
            purpleVCell.timeLabel.text = [_TimeArray objectAtIndex:indexPath.row];
            purpleVCell.timeLabel.textColor = [UIColor purpleColor];
            purpleVCell.moneyLabel.text = [_purpleVMoneyArray objectAtIndex:indexPath.row];
            NSLog(@"紫v%@",[_purpleVMoneyArray objectAtIndex:indexPath.row]);
            purpleVCell.moneyLabel.textColor = [UIColor purpleColor];
            return purpleVCell;
        }
            break;
        case 1001: {
            NSLog(@"黄v");
            YellowVCollectionViewCell *yellowVCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"yellowVCell" forIndexPath:indexPath];
            yellowVCell.timeLabel.text = [_TimeArray objectAtIndex:indexPath.row];
            yellowVCell.timeLabel.textColor = [UIColor orangeColor];
            yellowVCell.moneyLabel.text = [_yellowVMoneyArray objectAtIndex:indexPath.row];
            NSLog(@"黄v%@",[_yellowVMoneyArray objectAtIndex:indexPath.row]);
            yellowVCell.moneyLabel.textColor = [UIColor orangeColor];
            yellowVCell.bagImageView.layer.borderColor = [UIColor orangeColor].CGColor;
            return yellowVCell;
        }
            break;
        case 1003: {
            NSLog(@"座驾");
            StorecollectionVIewCell *collecCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"seatCell" forIndexPath:indexPath];
            [collecCell.bgImageView setImageWithURL:[NSURL URLWithString:[imageArray objectAtIndex:indexPath.row]]];
            collecCell.titleLabel.text = [namaArray objectAtIndex:indexPath.row];
            collecCell.moneyLabel.text = [NSString stringWithFormat:@"%@金币/月",[moneyArray objectAtIndex:indexPath.row]];
            return collecCell;
        }
            break;
        default:
            break;
    }
        return nil;

}
//每个分区有多少个cell
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    switch (collectionView.tag) {
        case 1000:
            return 4;
            break;
        case 1001:
            return 4;
            break;
        case 1003:
            return moneyArray.count;
            break;
        default:
            break;
    }
    return 0;
}
//有几个分区
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView.tag == 1000) {
        if (indexPath.row == 0) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"购买道具确认" message:@"道具名称：至尊VIP\n购买天数：30天\n价格：30000金币" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alert.tag = 100;
            [alert show];
            type = 1;
        } else if (indexPath.row == 1) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"购买道具确认" message:@"道具名称：至尊VIP\n购买天数：90天\n价格：82800金币" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alert.tag = 100;
            [alert show];
            type = 2;
        } else if (indexPath.row == 2) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"购买道具确认" message:@"道具名称：至尊VIP\n购买天数：180天\n价格：158400金币" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alert.tag = 100;
            [alert show];
            type = 3;
        } else {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"购买道具确认" message:@"道具名称：至尊VIP\n购买天数：360天\n价格：216000金币" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alert.tag = 100;
            [alert show];
            type = 4;
        }
    } else if (collectionView.tag == 1001){
        if (indexPath.row == 0) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"购买道具确认" message:@"道具名称：VIP\n购买天数：30天\n价格：10000金币" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alert.tag = 102;
            [alert show];
            type = 1;
        } else if (indexPath.row == 1) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"购买道具确认" message:@"道具名称：VIP\n购买天数：90天\n价格：24000金币" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alert.tag = 102;
            [alert show];
            type = 2;
        } else if (indexPath.row == 2) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"购买道具确认" message:@"道具名称：VIP\n购买天数：180天\n价格：42000金币" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alert.tag = 102;
            [alert show];
            type = 3;
        } else {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"购买道具确认" message:@"道具名称：VIP\n购买天数：360天\n价格：72000金币" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alert.tag = 102;
            [alert show];
            type = 4;
        }
    } else if (collectionView.tag == 1003) {
        switch (indexPath.row) {
            case 0: {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"购买道具确认" message:@"道具名称：乌龟\n购买天数：30天\n价格：3000金币" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                alert.tag = 300;
                [alert show];
            }
                break;
            case 1: {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"购买道具确认" message:@"道具名称：毛驴\n购买天数：30天\n价格：5000金币" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                alert.tag = 301;
                [alert show];
            }
                break;
            case 2: {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"购买道具确认" message:@"道具名称：南瓜车\n购买天数：30天\n价格：8000金币" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                alert.tag = 302;
                [alert show];
            }
                break;
            case 3: {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"购买道具确认" message:@"道具名称：青牛\n购买天数：30天\n价格：12000金币" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                alert.tag = 303;
                [alert show];
            }
                break;
            case 4: {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"购买道具确认" message:@"道具名称：金色飞马\n购买天数：30天\n价格：15000金币" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                alert.tag = 304;
                [alert show];
            }
                break;
            case 5: {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"购买道具确认" message:@"道具名称：法拉利\n购买天数：30天\n价格：25000金币" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                alert.tag = 305;
                [alert show];
            }
                break;
            case 6: {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"购买道具确认" message:@"道具名称：玛莎拉蒂\n购买天数：30天\n价格：30000金币" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                alert.tag = 306;
                [alert show];
            }
                break;
            case 7: {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"购买道具确认" message:@"道具名称：年兽\n购买天数：30天\n价格：40000金币" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                alert.tag = 307;
                [alert show];
            }
                break;
            case 8: {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"购买道具确认" message:@"道具名称：貔貅\n购买天数：30天\n价格：50000金币" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                alert.tag = 308;
                [alert show];
            }
                break;
            case 9: {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"购买道具确认" message:@"道具名称：狼骑士\n购买天数：30天\n价格：60000金币" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                alert.tag = 309;
                [alert show];
            }
                break;
                
            default:
                break;
        }
    }
}

#pragma mark - alertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 100) {
        if (buttonIndex == 1) {
            [self purpleVRequest];
            
        }
    } else if (alertView.tag == 102) {
        if (buttonIndex == 1) {
            [self yellowVRequest];
        }
    } else if (alertView.tag == 200) {
        //调到左菜单
    }else if (alertView.tag == 201) {
        if (buttonIndex == 1) {
            //调到充值界面
            TopUpViewController *top = [[TopUpViewController alloc]init];
            UINavigationController *nc = [[UINavigationController alloc]initWithRootViewController:top];
            [self presentViewController:nc animated:YES completion:nil];
        }
    }
    switch (alertView.tag ) {
        case 300: {
            if (buttonIndex == 1) {
                [self purchaseSeatRequest:[IDArray objectAtIndex:0]];
            }
        }
            break;
        case 301:{
            if (buttonIndex == 1) {
                [self purchaseSeatRequest:[IDArray objectAtIndex:1]];
            }
        }
            break;
        case 302:{
            if (buttonIndex == 1) {
                [self purchaseSeatRequest:[IDArray objectAtIndex:2]];
            }
        }
            break;
        case 303:{
            if (buttonIndex == 1) {
                [self purchaseSeatRequest:[IDArray objectAtIndex:3]];
            }
        }
            break;
        case 304:{
            if (buttonIndex == 1) {
                [self purchaseSeatRequest:[IDArray objectAtIndex:4]];
            }
        }
            break;
        case 305:{
            if (buttonIndex == 1) {
                [self purchaseSeatRequest:[IDArray objectAtIndex:5]];
            }
        }
            break;
        case 306:{
            if (buttonIndex == 1) {
                [self purchaseSeatRequest:[IDArray objectAtIndex:6]];
            }
        }
            break;
        case 307:{
            if (buttonIndex == 1) {
                [self purchaseSeatRequest:[IDArray objectAtIndex:7]];
            }
        }
            break;
        case 308:{
            if (buttonIndex == 1) {
                [self purchaseSeatRequest:[IDArray objectAtIndex:8]];
            }
        }
            break;
        case 309:{
            if (buttonIndex == 1) {
                [self purchaseSeatRequest:[IDArray objectAtIndex:9]];
            }
        }
            break;
            
        default:
            break;
    }
    
}

#pragma mark - 数据解析
//紫V
- (void)purpleVRequest
{
    ASIHTTPRequest *purpleRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://ttapi.izhubo.com/shop/buy_vip2/%@/%d?roomid=%@",model.access_token,type,nil]]];
    purpleRequest.delegate = self;
    purpleRequest.tag = 100;
    [purpleRequest setTimeOutSeconds:10];
    [purpleRequest startAsynchronous];
}
//黄V
- (void)yellowVRequest
{
    ASIHTTPRequest *yellowRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://ttapi.izhubo.com/shop/buy_vip/%@/%d?roomid=%@",model.access_token,type,nil]]];
    yellowRequest.delegate = self;
    yellowRequest.tag = 101;
    [yellowRequest setTimeOutSeconds:10];
    [yellowRequest startAsynchronous];
}
//座驾
- (void)seatRequest
{
    ASIHTTPRequest *seatRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://ttapi.izhubo.com/show/cars_list"]]];
    seatRequest.delegate = self;
    seatRequest.tag = 102;
    [seatRequest setTimeOutSeconds:30];
    [seatRequest startAsynchronous];
}
//够买座驾
- (void)purchaseSeatRequest:(id)sender
{
    ASIHTTPRequest *purchaseRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://ttapi.izhubo.com/shop/buy_car/%@/%@",model.access_token,sender]]];
    purchaseRequest.delegate = self;
    purchaseRequest.tag = 103;
    [purchaseRequest setTimeOutSeconds:20];
    [purchaseRequest startAsynchronous];
}

-(void)requestFinished:(ASIHTTPRequest *)request
{
    if (request.tag == 100) {
        NSLog(@"rsult == %@",request.responseString);
        id result = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        if ([result isKindOfClass:[NSDictionary class]]) {
            int purple1 = [[result objectForKey:@"code"] intValue];
            if (purple1 == 1) {
                UIAlertView *alert = [[UIAlertView alloc]init];
                alert.title = @"道具购买成功";
                [alert addButtonWithTitle:@"确定"];
                alert.tag = 200;
                [alert show];
            } else if (purple1 == 30412) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"购买失败" message:@"您的金币不足" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"充值", nil];
                alert.tag = 201;
                [alert show];
            }else {
                UIAlertView *alert = [[UIAlertView alloc]init];
                alert.title = @"购买失败";
                alert.message = @"您的财富等级低于道具购买要求";
                [alert addButtonWithTitle:@"确定"];
                [alert show];
            }
        }
    } else if (request.tag == 101) {
        NSLog(@"rsult == %@",request.responseString);
        id result = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        if ([result isKindOfClass:[NSDictionary class]]) {
            int yellow1 = [[result objectForKey:@"code"] intValue];
            if (yellow1 == 1) {
                UIAlertView *alert = [[UIAlertView alloc]init];
                alert.title = @"道具购买成功";
                [alert addButtonWithTitle:@"确定"];
                alert.tag = 200;
                [alert show];
            } else if (yellow1 == 30412) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"购买失败" message:@"您的金币不足" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"充值", nil];
                alert.tag = 201;
                [alert show];
            }else {
                UIAlertView *alert = [[UIAlertView alloc]init];
                alert.title = @"购买失败";
                alert.message = @"您的财富等级低于道具购买要求";
                [alert addButtonWithTitle:@"确定"];
                [alert show];
            }
        }
    } else if (request.tag == 102) {
        NSLog(@"座驾 == %@",request.responseString);
        id result = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        [imageArray removeAllObjects];
        [namaArray removeAllObjects];
        [moneyArray removeAllObjects];
        [IDArray removeAllObjects];
        if ([result isKindOfClass:[NSDictionary class]]) {
            NSArray *seatArray = [result objectForKey:@"data"];
            for (NSDictionary *dic in seatArray) {
                [imageArray addObject:[dic objectForKey:@"pic_url"]];
                [namaArray addObject:[dic objectForKey:@"name"]];
                [moneyArray addObject:[dic objectForKey:@"coin_price"]];
                [IDArray addObject:[dic objectForKey:@"_id"]];
            }
        }
        [seatButtonView reloadData];
    } else if (request.tag == 103) {
        NSLog(@"购买座驾 == %@",request.responseString);
        id result = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        if ([result isKindOfClass:[NSDictionary class]]) {
            int purchase = [[result objectForKey:@"code"] intValue];
            if (purchase == 1) {
                UIAlertView *alert = [[UIAlertView alloc]init];
                alert.title = @"道具购买成功";
                [alert addButtonWithTitle:@"确定"];
                alert.tag = 200;
                [alert show];
            } else if (purchase == 30412) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"购买失败" message:@"您的金币不足" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"充值", nil];
                alert.tag = 201;
                [alert show];
            }
        }
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
@end
