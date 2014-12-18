//
//  PersonageViewController.m
//  LoveAnchor
//
//  Created by zhongqinglongtu on 14-9-5.
//  Copyright (c) 2014年 zhongqinglongtu. All rights reserved.
//

#import "PersonageViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "UIImageView+BoundsAdditions.h"

@interface PersonageViewController ()<UITableViewDataSource,UITableViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate,HZAreaPickerDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UITableView *_tableView;
    NSArray *_titleArray;
    NSArray *_titleArray1;
    NSArray *_titleArray2;
    NSArray *_titleArray3;
    NSArray *_titleArray4;
    NSArray *_titleArray5;
    //性别
    UIView  *_sexView;
    //性别数组
    NSArray *_sexArray;
    //性别上的button
    UIButton *manButton;
    ////性别上的button
    UIButton *womanButton;
    //显示性别的label
    UILabel *label3;
    //性别背景
    UIView *View;
    //性别取消button
    UIButton *QXButton;
    //星座
    UIPickerView *_constellationPickerView;
    //星座VIew
    UIView *_constellationView;
    //星座数组
    NSArray *_constellationArray;
    //显示星座
    UILabel *label4;
    //城市北京
    UIView *_cityView;
    //显示城市
    UILabel *label5;
    LoginModel *model;
    NSDictionary *dict;
    //
    NSMutableDictionary *HZdict;
    //徽章
    NSMutableArray *HZImageArray;
    //徽章ID
    NSMutableArray *HZIDArray;
    //徽章点亮状态ID
    NSArray *HZhightIDArray;
    //徽章点亮状态图片
    NSMutableArray *HZhightImageArray;
    //星座
    NSInteger constellationTag;
    //buttonde 的tag
    NSInteger tag;
    //所有座驾
    NSMutableArray *allSeatArray;
    //拥有座驾
    SeatManageModel *mySeat;
    //头像
    UIImageView *headImgView;
    NSData *imageData;
    UIImagePickerController *picker;
}
@property (nonatomic, strong) NSString *areaValue;
@property (strong, nonatomic) HZAreaPickerView *locatePicker;

-(void)cancelLocatePicker;

@end

@implementation PersonageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _titleArray1 = [[NSArray alloc] initWithObjects:@"昵称",@"ID", nil];
        _titleArray2 = [[NSArray alloc] initWithObjects:@"性别",@"星座",@"城市", nil];
        _titleArray3 = [[NSArray alloc] initWithObjects:@"VIP",@"富豪等级",@"主播等级", nil];
        _titleArray4 = [[NSArray alloc] initWithObjects:@"金币",@"金豆", nil];
        _titleArray5 = [[NSArray alloc] initWithObjects:@"座驾",@"徽章", nil];
        _sexArray    = [NSArray arrayWithObjects:@"男",@"女", nil];
        _titleArray  = [[NSArray alloc] initWithObjects:_titleArray1,_titleArray2,_titleArray3,_titleArray4,_titleArray5, nil];
        _constellationArray = [NSArray arrayWithObjects:@"白羊座",@"金牛座",@"双子座",@"巨蟹座",@"狮子座",@"处女座",@"天秤座",@"天蝎座",@"射手座",@"摩羯座",@"水瓶座",@"双鱼座", nil];
        dict = [NSDictionary dictionary];
        HZImageArray = [NSMutableArray array];
        HZdict = [NSMutableDictionary dictionary];
        HZIDArray = [NSMutableArray array];
        HZhightIDArray = [NSArray array];
        HZhightImageArray = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    model = [CommonUtil getUserModel];
    
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
    UIButton *titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    titleButton.frame = CGRectMake(0, 0, 50, 44);
    titleButton.tag = 100;
    [titleButton setTitle:@"返回" forState:UIControlStateNormal];
    titleButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [titleButton setTitleColor:textFontColor forState:UIControlStateNormal];
    [titleButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar addSubview:titleButton];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(123, 0, 75, 44)];
    label.text = @"个人资料";
    label.font = [UIFont systemFontOfSize:18];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = textFontColor;
    [self.navigationController.navigationBar addSubview:label];
    
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    scrollView.contentSize =  CGSizeMake(kScreenWidth, 750);
    scrollView.backgroundColor = [UIColor colorWithRed:232/255.0 green:241/255.0 blue:243/255.0 alpha:1];
    scrollView.bounces = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:scrollView];
    
    UIImageView *headImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 145)];
    headImageView.image = [UIImage imageNamed:@"gerenxinxibeijing"];
    headImageView.userInteractionEnabled = YES;
    [scrollView addSubview:headImageView];
    
    headImgView = [[UIImageView alloc] initWithFrame:CGRectMake(120, 32.5, 80, 80)];
    [headImgView setImage:[UIImage imageNamed:@"morentouxiang"]];
    headImgView.userInteractionEnabled = YES;
    [headImgView makeBoundImage];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headClick:)];
    [headImgView addGestureRecognizer:tap];
    [headImageView addSubview:headImgView];
    
    UIImageView *photoImage = [[UIImageView alloc] initWithFrame:CGRectMake(178, 88, 22, 22)];
    [photoImage setImage:[UIImage imageNamed:@"xiangji"]];
    [headImageView addSubview:photoImage];
    
    UIButton *cancelButton= [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setTitle:@"注销" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    cancelButton.frame = CGRectMake(15, 697, 290, 44);
    cancelButton.tag = 103;
    cancelButton.layer.borderColor = [UIColor grayColor].CGColor;
    cancelButton.layer.borderWidth = 0.5;
    cancelButton.layer.cornerRadius = 5.0;
    [cancelButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:cancelButton];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 145, kScreenWidth, 544) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [scrollView addSubview:_tableView];
    
}

#pragma mark - 点击事件
- (void)buttonClick:(UIButton *)button
{
    if (button.tag == 100) {
        if (self.firstLogin) {
            UIViewController *viewController = self;
            viewController = viewController.presentingViewController.presentingViewController;
            [viewController dismissViewControllerAnimated:YES completion:nil];
        } else {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    } else if (button.tag == 103) {
        if ([CommonUtil isLogin]) {
            [CommonUtil logout];
            if (self.firstLogin) {
                UIViewController *viewController = self;
                viewController = viewController.presentingViewController.presentingViewController;
                [viewController dismissViewControllerAnimated:YES completion:nil];
            } else {
                [self dismissViewControllerAnimated:YES completion:nil];
            }
            [[SliderViewController sharedSliderController] leftItemClick];
        }
    } else if (button.tag == 109) {
        _constellationView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 200);
        [self constellationRequest];
    } else if (button.tag == 110) {
        [self cityRequest];
        _cityView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 200);
    }else if (button.tag == 1234) {
        _sexView.hidden = YES;
        View.hidden = YES;
        QXButton.frame = CGRectMake(20, kScreenHeight, _sexView.frame.size.width, 30);
    } else {
        NSLog(@"你麻痹");
        _sexView.hidden = YES;
        View.hidden = YES;
        QXButton.frame = CGRectMake(20, kScreenHeight, _sexView.frame.size.width, 30);
        tag = button.tag-1000;
        [self sexRequest];
    }
    
}

- (void)headClick:(UITapGestureRecognizer *)tap
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从相册选择", nil];
    [actionSheet showInView:self.view];
}

#pragma mark - UIActionSheetDelegate methods
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0: {   //拍照
            [self choosePhotoWithSourceType:UIImagePickerControllerSourceTypeCamera];
        }
            break;
        case 1: {   //从相册选择
            [self choosePhotoWithSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
        }
            break;
        default:
            break;
    }
}

- (void)choosePhotoWithSourceType:(UIImagePickerControllerSourceType)type
{
    picker = [[UIImagePickerController alloc] init];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        picker.sourceType = type;
        NSString *temp_MediaType = [[UIImagePickerController availableMediaTypesForSourceType:picker.sourceType] objectAtIndex:0];
        NSArray *temp_MediaTypes = [NSArray arrayWithObject:temp_MediaType];
        picker.mediaTypes = temp_MediaTypes;
        picker.delegate = self;
        picker.allowsEditing = YES;
    }
    
    [self presentViewController:picker animated:YES completion:^{
        
    }];
}

#pragma mark - UIImagePickerControllerDelegate methods
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:YES completion:^{
        NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
        if ([mediaType isEqualToString:@"public.image"]) {
            UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
            headImgView.image = image;
            imageData = UIImageJPEGRepresentation(image, 1.0);
        }
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark - tableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]init];

    if (indexPath.section == 0 && indexPath.row == 0) {
        UILabel *lable0 = [[UILabel alloc]initWithFrame:CGRectMake(66, 0, 190, 42)];
        lable0.font = [UIFont systemFontOfSize:14];
        if ([dict objectForKey:@"nick_name"]) {
            lable0.text = [dict objectForKey:@"nick_name"];
        }
        lable0.textColor = [UIColor lightGrayColor];
        [cell addSubview:lable0];
        UIImageView *modificationImage = [[UIImageView alloc]initWithFrame:CGRectMake(285, 12, 18, 18)];
        modificationImage.image = [UIImage imageNamed:@"bianji"];
        [cell addSubview:modificationImage];
    } else if (indexPath.section == 0 && indexPath.row == 1){
        UILabel *lable1 = [[UILabel alloc]initWithFrame:CGRectMake(66, 0, 190, 42)];
        lable1.font = [UIFont systemFontOfSize:14];
        if ([dict objectForKey:@"_id"]) {
            lable1.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"_id"]];
        }
        lable1.textColor = [UIColor lightGrayColor];
        [cell addSubview:lable1];
        
    } else if (indexPath.section == 1 && indexPath.row == 0) {
        label3 = [[UILabel alloc]initWithFrame:CGRectMake(257, 0, 50, 42)];
        [label3 setBackgroundColor:[UIColor clearColor]];
        label3.font = [UIFont systemFontOfSize:14];
        label3.textAlignment = NSTextAlignmentRight;
        if ([dict objectForKey:@"sex"]) {
            NSNumber *number = [dict objectForKey:@"sex"];
            int num = [number intValue];
            if (num == 0) {
                label3.text = @"女";
            } else if (num == 1) {
                label3.text = @"男";
            } else {
                label3.text = @"保密";
            }
        }
        
        label3.textColor = [UIColor lightGrayColor];
        [cell addSubview:label3];

    } else if (indexPath.section == 1 && indexPath.row == 1) {
        label4 = [[UILabel alloc]initWithFrame:CGRectMake(260, 0, 50, 42)];
        [label4 setBackgroundColor:[UIColor clearColor]];
        label4.font = [UIFont systemFontOfSize:14];
        if ([dict objectForKey:@"constellation"]) {
        NSNumber *number = [dict objectForKey:@"constellation"];
        int num = [number intValue];
            label4.text = [_constellationArray objectAtIndex:num-1];
        }
        label4.textColor = [UIColor lightGrayColor];
        [cell addSubview:label4];
        
    } else if (indexPath.section == 1 && indexPath.row == 2) {
        label5 = [[UILabel alloc]initWithFrame:CGRectMake(180, 0, 120, 42)];
        label5.font = [UIFont systemFontOfSize:14];
        if ([dict objectForKey:@"location"]) {
            label5.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"location"]];
        }
        label5.textColor = [UIColor lightGrayColor];
        label5.backgroundColor = [UIColor clearColor];
        label5.textAlignment = NSTextAlignmentRight;
        [cell addSubview:label5];
        
    } else if (indexPath.section == 2 && indexPath.row == 0) {
        UILabel *label6 = [[UILabel alloc]initWithFrame:CGRectMake(255, 0, 40, 42)];
        label6.font = [UIFont systemFontOfSize:14];
        label6.text = @"续费";
        label6.textColor = textFontColor;
        [cell addSubview:label6];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 0, 150, 42)];
        timeLabel.backgroundColor = [UIColor clearColor];
        timeLabel.font = [UIFont systemFontOfSize:14];
        timeLabel.textColor = [UIColor lightGrayColor];
        NSNumber *time = [dict objectForKey:@"vip_expires"];
        NSLog(@"time = %@",time);
        if (time) {
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:[time doubleValue]/1000];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd"];
            [formatter setTimeZone:[NSTimeZone localTimeZone]];
            NSString *stringFromDate = [formatter stringFromDate:date];
            NSLog(@"stringFromDate-----------%@",stringFromDate);
            timeLabel.text = [NSString stringWithFormat:@"到期时间：%@",stringFromDate];
        }
        [cell addSubview:timeLabel];
        
        UIImageView *VIPImageView = [[UIImageView alloc]initWithFrame:CGRectMake(230, 13, 15, 15)];
        if ([[dict objectForKey:@"vip"] intValue] == 1) {
            VIPImageView.image = [UIImage imageNamed:@"huangV1"];
        } else if ([[dict objectForKey:@"vip"] intValue] == 2) {
            VIPImageView.image = [UIImage imageNamed:@"ziV1"];
        } else {
            VIPImageView.image = [UIImage imageNamed:@"guoqiVIP"];
        }
        
        VIPImageView.backgroundColor = [UIColor clearColor];
        [cell addSubview:VIPImageView];
        
    } else if (indexPath.section == 2 && indexPath.row == 1) {
        UIImageView *image3 = [[UIImageView alloc]initWithFrame:CGRectMake(139, 15, 25, 12)];
        NSDictionary *dic = [dict objectForKey:@"finance"];
        NSNumber *coin = [dic objectForKey:@"coin_spend_total"];
        NSInteger level = [CommonUtil getLevelInfoWithCoin:coin.intValue isRich:YES].level;
        image3.image = [UIImage imageNamed:[NSString stringWithFormat:@"%ldfu",(long)level]];
        [cell addSubview:image3];
        
        UIImageView *image5 = [[UIImageView alloc]initWithFrame:CGRectMake(168, 17, 108, 8)];
        image5.image = [UIImage imageNamed:@"jindutiaokong"];
        [cell addSubview:image5];
        
        UILabel *HZlabel = [[UILabel alloc]initWithFrame:CGRectMake(168, 29, 108, 10)];
        NSInteger nextCoin = [CommonUtil getLevelInfoWithCoin:coin.intValue isRich:YES].nextCoin;
        HZlabel.text = [NSString stringWithFormat:@"还差%ld金币",(long)nextCoin];
        HZlabel.textAlignment = NSTextAlignmentCenter;
        HZlabel.font = [UIFont systemFontOfSize:10];
        HZlabel.textColor = [UIColor lightGrayColor];
        [cell addSubview:HZlabel];
        
        UIImageView *image4 = [[UIImageView alloc]initWithFrame:CGRectMake(280, 15, 25, 12)];
        image4.image = [UIImage imageNamed:[NSString stringWithFormat:@"%ldfu",(long)level + 1]];
        [cell addSubview:image4];
    } else if (indexPath.section == 2 && indexPath.row == 2) {
        UIImageView *image6 = [[UIImageView alloc]initWithFrame:CGRectMake(148, 13, 16, 16)];
        NSDictionary *dic = [dict objectForKey:@"finance"];
        NSNumber *coin = [dic objectForKey:@"bean_count_total"];
        NSInteger level = [CommonUtil getLevelInfoWithCoin:coin.intValue isRich:NO].level;
        image6.image = [UIImage imageNamed:[NSString stringWithFormat:@"%ldzhubo",(long)level]];
        [cell addSubview:image6];
        
        UIImageView *image7 = [[UIImageView alloc]initWithFrame:CGRectMake(168, 17, 108, 8)];
        image7.image = [UIImage imageNamed:@"jindutiaokong"];
        [cell addSubview:image7];
        UILabel *HZlabel1 = [[UILabel alloc]initWithFrame:CGRectMake(168, 29, 108, 10)];
        NSInteger nextCoin = [CommonUtil getLevelInfoWithCoin:coin.intValue isRich:NO].nextCoin;
        HZlabel1.text = [NSString stringWithFormat:@"还差%ld金豆",(long)nextCoin];
        HZlabel1.textAlignment = NSTextAlignmentCenter;
        HZlabel1.font = [UIFont systemFontOfSize:10];
        HZlabel1.textColor = [UIColor lightGrayColor];
        [cell addSubview:HZlabel1];
        
        UIImageView *image8 = [[UIImageView alloc]initWithFrame:CGRectMake(280, 13, 16, 16)];
        image8.image = [UIImage imageNamed:[NSString stringWithFormat:@"%ldzhubo",(long)level + 1]];
        [cell addSubview:image8];
        
    } else if (indexPath.section == 3 && indexPath.row == 0) {
        UILabel *label7 = [[UILabel alloc]initWithFrame:CGRectMake(100, 0, 150, 42)];
        label7.font = [UIFont systemFontOfSize:14];
        label7.backgroundColor = [UIColor clearColor];
        NSDictionary *dic = [dict objectForKey:@"finance"];
        if ([dict objectForKey:@"finance"]) {
            label7.text = [NSString stringWithFormat:@"%d个",[[dic objectForKey:@"coin_count"]intValue]];
        }
        label7.textColor = [UIColor lightGrayColor];
        label7.textAlignment = NSTextAlignmentLeft;
        [cell addSubview:label7];
        
        UILabel *label9 = [[UILabel alloc]initWithFrame:CGRectMake(255, 0, 80, 42)];
        label9.font = [UIFont systemFontOfSize:14];
        label9.text = @"充值";
        label9.textColor = textFontColor;
        [cell addSubview:label9];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else if (indexPath.section == 3 && indexPath.row == 1) {
        UILabel *label8 = [[UILabel alloc]initWithFrame:CGRectMake(100, 0, 150, 42)];
        label8.font = [UIFont systemFontOfSize:14];
        NSDictionary *dic = [dict objectForKey:@"finance"];
        if ([dict objectForKey:@"finance"]) {
            label8.text = [NSString stringWithFormat:@"%d个",[[dic objectForKey:@"coin_count"]intValue]];
        }
        label8.textColor = [UIColor lightGrayColor];
        label8.textAlignment = NSTextAlignmentLeft;
        [cell addSubview:label8];
        
        UILabel *label10 = [[UILabel alloc]initWithFrame:CGRectMake(255, 0, 80, 42)];
        label10.font = [UIFont systemFontOfSize:14];
        label10.text = @"兑换";
        label10.textColor = textFontColor;
        [cell addSubview:label10];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else if (indexPath.section == 4 && indexPath.row == 0) {
        UILabel *label13 = [[UILabel alloc]initWithFrame:CGRectMake(228, 0, 60, 42)];
        label13.font = [UIFont systemFontOfSize:14];
        if (mySeat.pic_url.length) {
            label13.text = @"管理座驾";
        } else {
            label13.text = @"前去购买";
        }
        label13.textColor = textFontColor;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [cell addSubview:label13];
        
        UIImageView *carImageView = [[UIImageView alloc] initWithFrame:CGRectMake(60, 10, 40, 25)];
        NSURL *url = [NSURL URLWithString:mySeat.pic_url];
        [carImageView setImageWithURL:url];
        [cell addSubview:carImageView];
        
    }else if (indexPath.section == 4 && indexPath.row == 1) {
        for (int i = 0; i<HZIDArray.count; i++) {
            UIImageView *HzImageView = [[UIImageView alloc]initWithFrame:CGRectMake(55+20*i, 13.5, 15, 15)];
            [HzImageView setImageWithURL:[NSURL URLWithString:HZImageArray[i]]];
            HzImageView.backgroundColor = [UIColor clearColor];
            for (int j = 0; j < HZhightIDArray.count; j++) {
                if ([HZIDArray[i] intValue] == [HZhightIDArray[j] intValue]) {
                    [HzImageView setImageWithURL:[NSURL URLWithString:HZhightImageArray[i]]];
                }
            }
            [cell addSubview:HzImageView];
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    if (indexPath.section == 3 && indexPath.row == 0) {
        cell.imageView.image = [UIImage imageNamed:@"jinbi"];
    }else if (indexPath.section == 3 && indexPath.row == 1){
        cell.imageView.image = [UIImage imageNamed:@"jindou"];
    }
    cell.textLabel.text = [[_titleArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)setAreaValue:(NSString *)areaValue
{
    if (![_areaValue isEqualToString:areaValue]) {
        label5.text = areaValue;
    }
}

-(void)pickerDidChaneStatus:(HZAreaPickerView *)picker
{
    if (picker.pickerStyle == HZAreaPickerWithStateAndCity) {
        self.areaValue = [NSString stringWithFormat:@"%@ %@", picker.locate.state, picker.locate.city];
    }
}

-(void)cancelLocatePicker
{
    [self.locatePicker cancelPicker];
    self.locatePicker.delegate = nil;
    self.locatePicker = nil;
}
#pragma mark - tabelViewDelegate
//每个返回多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1 || section == 2) {
        return 3;
    } else {
        return 2;
    }
}
//返回几组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}
//每个cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 42;
}
//返回头高
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }else {
        return 10;
    }
}
//
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
    view.backgroundColor = [UIColor colorWithRed:232/255.0 green:241/255.0 blue:243/255.0 alpha:1];
    return view;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        ModificationViewController *modification = [[ModificationViewController alloc]init];
        [modification setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
        UINavigationController *nc = [[UINavigationController alloc]initWithRootViewController:modification];
        [self presentViewController:nc animated:YES completion:nil];
    } else if (indexPath.section == 1 && indexPath.row == 0) {
        View = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        View.alpha = 0.6;
        View.backgroundColor = [UIColor blackColor];
        [self.view addSubview:View];
        _sexView = [[UIView alloc]initWithFrame:CGRectMake(20, kScreenHeight - 170, kScreenWidth - 40, 114)];
        _sexView.backgroundColor = [UIColor whiteColor];
        _sexView.layer.borderColor = [UIColor whiteColor].CGColor;
        _sexView.layer.borderWidth = 0.2;
        _sexView.layer.cornerRadius = 2.0;
        [self.view addSubview:_sexView];
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, _sexView.frame.size.width-10, 38)];
        titleLabel.text = @"性别修改";
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = [UIColor lightGrayColor];
        titleLabel.font = [UIFont systemFontOfSize:12];
        [_sexView addSubview:titleLabel];
        
        womanButton = [UIButton buttonWithType:UIButtonTypeCustom];
        womanButton.frame = CGRectMake(0, 38, _sexView.frame.size.width, 38);
        [womanButton setTitleColor:textFontColor forState:UIControlStateNormal];
        [womanButton setTitle:@"女"forState:UIControlStateNormal];
        womanButton.tag = 1000;
        [womanButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_sexView addSubview:womanButton];
        
        manButton = [UIButton buttonWithType:UIButtonTypeCustom];
        manButton.frame = CGRectMake(0, 76, _sexView.frame.size.width, 38);
        [manButton setTitleColor:textFontColor forState:UIControlStateNormal];
        manButton.tag = 1001;
        [manButton setTitle:@"男" forState:UIControlStateNormal];
        [manButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_sexView addSubview:manButton];
        
        UIImageView *imagescn = [[UIImageView alloc]initWithFrame:CGRectMake(0, 38, _sexView.frame.size.width, 0.3)];
        imagescn.backgroundColor = [UIColor lightGrayColor];
        [_sexView addSubview:imagescn];
        
        UIImageView *imagescn2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 76, _sexView.frame.size.width, 0.5)];
        imagescn2.backgroundColor = [UIColor lightGrayColor];
        [_sexView addSubview:imagescn2];
        
        QXButton = [UIButton buttonWithType:UIButtonTypeCustom];
        QXButton.frame = CGRectMake(20, kScreenHeight-50, _sexView.frame.size.width, 38);
        [QXButton setBackgroundColor:[UIColor whiteColor]];
        [QXButton setTitle:@"取消" forState:UIControlStateNormal];
        QXButton.tag = 1234;
        [QXButton setTitleColor:textFontColor forState:UIControlStateNormal];
        QXButton.layer.borderColor = [UIColor whiteColor].CGColor;
        QXButton.layer.borderWidth = 0.2;
        QXButton.layer.cornerRadius = 2.0;
        [QXButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:QXButton];
    } else if (indexPath.section == 1 && indexPath.row == 1) {
        _constellationView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight-200, kScreenWidth, 200)];
        _constellationView.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:0.6];
        [self.view addSubview:_constellationView];
        
        _constellationPickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 38, kScreenWidth, 162)];
        _constellationPickerView.delegate = self;
        _constellationPickerView.dataSource = self;
        _constellationPickerView.backgroundColor = [UIColor clearColor];
        _constellationPickerView.showsSelectionIndicator = YES;
        [_constellationView addSubview:_constellationPickerView];
        
        UIButton *constellationButton = [UIButton buttonWithType:UIButtonTypeCustom];
        constellationButton.tag = 109;
        constellationButton.frame = CGRectMake(kScreenWidth-65, 0, 65, 38);
        [constellationButton setTitle:@"完成" forState:UIControlStateNormal];
        [constellationButton setTitleColor:textFontColor forState:UIControlStateNormal];
        [constellationButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_constellationView addSubview:constellationButton];
    } else if (indexPath.section == 1 && indexPath.row == 2) {
        _cityView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight- 200, kScreenWidth, 200)];
        _cityView.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:0.6];
        [self.view addSubview:_cityView];
        [self cancelLocatePicker];
        
        UIButton *WCButton = [UIButton buttonWithType:UIButtonTypeCustom];
        WCButton.frame = CGRectMake(kScreenWidth-65, 0, 65, 38);
        WCButton.tag = 110;
        [WCButton setTitle:@"完成" forState:UIControlStateNormal];
        [WCButton setTitleColor:textFontColor forState:UIControlStateNormal];
        [WCButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_cityView addSubview:WCButton];
        
        self.locatePicker = [[HZAreaPickerView alloc] initWithStyle:HZAreaPickerWithStateAndCity delegate:self];
        self.locatePicker.delegate = self;
        self.locatePicker.tag = 100;
        self.locatePicker.frame = CGRectMake(0, 38, kScreenWidth, 162);
        self.locatePicker.backgroundColor = [UIColor clearColor];
        [self.locatePicker showInView:_cityView];
        
    } else if (indexPath.section == 2 && indexPath.row == 0) {
        StoreViewController *store = [[StoreViewController alloc]init];
        UINavigationController *nc = [[UINavigationController alloc]initWithRootViewController:store];
        [self presentViewController:nc animated:YES completion:nil];
    } else if (indexPath.section == 3 && indexPath.row == 0) {
        TopUpViewController *topUp = [[TopUpViewController alloc]init];
        UINavigationController *nc = [[UINavigationController alloc]initWithRootViewController:topUp];
        [self presentViewController:nc animated:YES completion:nil];
    } else if (indexPath.section == 3 && indexPath.row == 1) {
        ConversionViewController *conversion = [[ConversionViewController alloc]init];
        UINavigationController *nc = [[UINavigationController alloc]initWithRootViewController:conversion];
        [self presentViewController:nc animated:YES completion:nil];
    } else if (indexPath.section == 4 && indexPath.row == 0) {
        if (mySeat.pic_url.length) {
            SeatManageViewController *manage = [[SeatManageViewController alloc]init];
            UINavigationController *nc = [[UINavigationController alloc]initWithRootViewController:manage];
            [self presentViewController:nc animated:YES completion:nil];
        } else {
            StoreViewController *store = [[StoreViewController alloc]init];
            UINavigationController *nc = [[UINavigationController alloc]initWithRootViewController:store];
            [self presentViewController:nc animated:YES completion:nil];
        }
        
    } else if (indexPath.section == 4 && indexPath.row == 1) {
//        [self badgeRequest];
    }
}

//UIPickerViewDataSource协议方法
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView//返回选择器有多少个组件
{
    return 1;
    
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component//每个组件中有多少个选项
{
    return [_constellationArray count];
}
//-------------------------------------------------------------------
//UIPickerViewDelegate协议方法
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [_constellationArray objectAtIndex:row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    constellationTag = row;
}
-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *showLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f,0.0f,kScreenWidth,20.0f)];
    showLabel.text = [_constellationArray objectAtIndex:row];
    showLabel.backgroundColor = [UIColor clearColor];
    showLabel.textColor = textFontColor;
    showLabel.textAlignment = NSTextAlignmentCenter;
    return showLabel;
}
#pragma mark - 数据解析
//所有数据
- (void)request
{
    NSString *urlStr = [NSString stringWithFormat:@"%@user/info/%@",BaseURL,model.access_token];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
    request.delegate = self;
    request.tag = 100;
    [request setTimeOutSeconds:30];
    [request startAsynchronous];
}
//徽章
- (void)badgeRequest
{
    NSString *urlStr = [NSString stringWithFormat:@"%@zone/user_medal/%@",BaseURL,[dict objectForKey:@"_id"]];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
    request.delegate = self;
    request.tag = 101;
    [request setTimeOutSeconds:30];
    [request startAsynchronous];
}
//座驾
- (void)seatRequest
{
    NSString *urlStr = [NSString stringWithFormat:@"%@user/car_info/%@",BaseURL,model.access_token];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
    request.delegate = self;
    request.tag = 102;
    [request setTimeOutSeconds:30];
    [request startAsynchronous];
}
//全部座驾
- (void)allSeatRequest
{
    NSString *urlStr = [NSString stringWithFormat:@"%@show/cars_list",BaseURL];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
    request.delegate = self;
    request.tag = 106;
    [request setTimeOutSeconds:30];
    [request startAsynchronous];
}

//性别
- (void)sexRequest
{
    NSString *urlStr = [NSString stringWithFormat:@"%@user/edit/%@",BaseURL,model.access_token];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlStr]];
    request.delegate = self;
    request.tag = 103;
    [request setPostValue:[NSString stringWithFormat:@"%ld",(long)tag] forKey:@"sex"];
    [request startAsynchronous];
}
//星座
- (void)constellationRequest
{
    NSString *urlStr = [NSString stringWithFormat:@"%@user/edit/%@",BaseURL,model.access_token];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlStr]];
    request.delegate = self;
    request.tag = 104;
    [request setPostValue:[NSString stringWithFormat:@"%ld",(long)constellationTag+1] forKey:@"constellation"];
    [request startAsynchronous];
}
//城市
- (void)cityRequest
{
    NSString *urlStr = [NSString stringWithFormat:@"%@user/edit/%@",BaseURL,model.access_token];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlStr]];
    request.delegate = self;
    request.tag = 105;
    [request setPostValue:label5.text forKey:@"location"];
    [request startAsynchronous];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    if (request.tag == 100) {
        id result = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        if ([result isKindOfClass:[NSDictionary class]]) {
            dict = [result objectForKey:@"data"];
            NSDictionary *array1 = [dict objectForKey:@"medals"];  //个人徽章字典
            
            HZhightIDArray = [array1 allKeys];
            
            [self badgeRequest];
            [self allSeatRequest];
            [self seatRequest];
        }
        [_tableView reloadData];
    } else if (request.tag == 101) {
        id result = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        if ([result isKindOfClass:[NSDictionary class]]) {
            NSArray *array = [result objectForKey:@"data"];  //全部徽章
            [HZImageArray removeAllObjects];
            [HZhightImageArray removeAllObjects];
            [HZIDArray removeAllObjects];
            for (NSDictionary *dict1 in array) {
                [HZImageArray addObject:[dict1 objectForKey:@"grey_pic"]];
                [HZIDArray addObject:[dict1 objectForKey:@"_id"]];
                [HZhightImageArray addObject:[dict1 objectForKey:@"pic_url"]];
            }
        }
        [_tableView reloadData];
    } else if (request.tag == 102) {
        id result = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        if ([result isKindOfClass:[NSDictionary class]]) {
            NSDictionary *seatDict = [result objectForKey:@"data"];
            NSDictionary *dic = [seatDict objectForKey:@"car"];
            NSNumber *currId = [dic objectForKey:@"curr"];
            mySeat = [[SeatManageModel alloc] init];
            for (SeatManageModel *seat in allSeatArray) {
                if (seat._id.intValue == currId.intValue) {
                    mySeat._id = currId;
                    mySeat.pic_url = seat.pic_url;
                }
            }
        }
        [_tableView reloadData];
    } else if (request.tag ==103) {
        [self request];
    } else if (request.tag ==104) {
        [self request];
    } else if (request.tag == 105) {
        [self request];
    } else if (request.tag == 106) {
        id result = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        if ([result isKindOfClass:[NSDictionary class]]) {
            NSArray *dataArray = [result objectForKey:@"data"];
            allSeatArray = [NSMutableArray array];
            for (NSDictionary *dic in dataArray) {
                SeatManageModel *allSeat = [[SeatManageModel alloc] init];
                allSeat.pic_url = [dic objectForKey:@"pic_url"];
                allSeat._id = [dic objectForKey:@"_id"];
                [allSeatArray addObject:allSeat];
            }
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
