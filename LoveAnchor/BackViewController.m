//
//  BackViewController.m
//  LoveAnchor
//
//  Created by zhongqinglongtu on 15-1-10.
//  Copyright (c) 2015年 zhongqinglongtu. All rights reserved.
//

#import "BackViewController.h"

@interface BackViewController ()
{
    UITextField *_telTextField;
    UITextField *_YZTextField;
    UIImageView *_validationImageView1;
}


@end

@implementation BackViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self showUI];
}
#pragma mark - 界面

- (void)showUI
{
    self.view.backgroundColor = [UIColor colorWithRed:232/255.0 green:241/255.0 blue:243/255.0 alpha:1];

    UIButton *titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    titleButton.frame = CGRectMake(0, 0, 50, 44);
    titleButton.tag = 100;
    [titleButton setTitle:@"返回" forState:UIControlStateNormal];
    titleButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [titleButton setTitleColor:textFontColor forState:UIControlStateNormal];
    [titleButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar addSubview:titleButton];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(120, 0, 80, 44)];
    label.text = @"找回密码";
    label.font = [UIFont systemFontOfSize:18];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = textFontColor;
    label.textAlignment = NSTextAlignmentCenter;
    [self.navigationController.navigationBar addSubview:label];
    
    UIView *leftInputView = [[UIView alloc]initWithFrame:CGRectMake(0, 80, kScreenWidth-0.5, 44)];
    leftInputView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:leftInputView];
    
    UIImageView *hengxianImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5)];
    hengxianImage.backgroundColor = [UIColor lightGrayColor];
    [leftInputView addSubview:hengxianImage];
    
    UIImageView *diHengxianImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 44, kScreenWidth, 0.5)];
    diHengxianImage.backgroundColor = [UIColor lightGrayColor];
    [leftInputView addSubview:diHengxianImage];
    
    UIImageView *heardImage  = [[UIImageView alloc]initWithFrame:CGRectMake(22, 10, 15, 24)];
    heardImage.image = [UIImage imageNamed:@"shouji"];
    [leftInputView addSubview:heardImage];
    
    _telTextField = [[UITextField alloc]initWithFrame:CGRectMake(50, 0, kScreenWidth-50, 44)];
    _telTextField.placeholder = @"+86";
    [_telTextField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    _telTextField.font = [UIFont systemFontOfSize:15];
    _telTextField.borderStyle = UITextBorderStyleNone;
    [leftInputView addSubview:_telTextField];
    
    UILabel *hintLabel = [[UILabel alloc]initWithFrame:CGRectMake(25, 255, kScreenWidth-45, 12)];
    hintLabel.text = @"若您的账号不是使用手机号注册或未绑定过手机号";
    hintLabel.textColor = [UIColor grayColor];
    hintLabel.font = [UIFont systemFontOfSize:12];
    hintLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:hintLabel];
    UILabel *hintLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(25, 268, kScreenWidth-50, 12)];
    hintLabel1.text = @"请联系客服：2055320190 找回密码。";
    hintLabel1.textColor = [UIColor grayColor];
    hintLabel1.font = [UIFont systemFontOfSize:12];
    hintLabel1.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:hintLabel1];
    
    UIView *leftInputView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 134, kScreenWidth-0.5, 44)];
    leftInputView1.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:leftInputView1];
    
    UIImageView *hengxianImage1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5)];
    hengxianImage1.backgroundColor = [UIColor lightGrayColor];
    [leftInputView1 addSubview:hengxianImage1];
    
    UIImageView *diHengxianImage1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 44, kScreenWidth, 0.5)];
    diHengxianImage1.backgroundColor = [UIColor lightGrayColor];
    [leftInputView1 addSubview:diHengxianImage1];
    
    _YZTextField = [[UITextField alloc]initWithFrame:CGRectMake(20, 0, kScreenWidth/2, 44)];
    _YZTextField.placeholder = @"请输入验证码";
    [_YZTextField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    _YZTextField.font = [UIFont systemFontOfSize:15];
    _YZTextField.borderStyle = UITextBorderStyleNone;
    [leftInputView1 addSubview:_YZTextField];
    
    //验证码图片
    _validationImageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(220, 12, 55, 20)];
    _validationImageView1.backgroundColor = [UIColor clearColor];
    _validationImageView1.userInteractionEnabled = YES;
    [leftInputView1 addSubview:_validationImageView1];
    
    //点击手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(judgeClick:)];
    [_validationImageView1 addGestureRecognizer:tap];
    
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    nextButton.frame = CGRectMake(15, 190, 290, 44);
    [nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    [nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nextButton setBackgroundColor:[UIColor lightGrayColor]];
    nextButton.tag = 103;
    nextButton.selected = NO;
    [nextButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextButton];
    
}
- (void)buttonClick:(UIButton *)button
{
    if (button.tag == 100) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
-(void)judgeClick:(UITapGestureRecognizer *)tap
{
    
}
#pragma mark - 数据


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
@end
