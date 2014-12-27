//
//  ModifyPassWordViewController.m
//  LoveAnchor
//
//  Created by zhongqinglongtu on 14-12-25.
//  Copyright (c) 2014年 zhongqinglongtu. All rights reserved.
//

#import "ModifyPassWordViewController.h"

@interface ModifyPassWordViewController ()<UITextFieldDelegate>
{
    UITextField *_nameTextField;
    UITextField *_passTextField;
    
}

@end

@implementation ModifyPassWordViewController

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
    [self createRightView];
}
- (void)createRightView
{
    self.view.backgroundColor = [UIColor colorWithRed:232/255.0 green:241/255.0 blue:243/255.0 alpha:1];
    UILabel *topTitle = [[UILabel alloc]initWithFrame:CGRectMake(140, 0, 40, 44)];
    topTitle.text = @"设置";
    topTitle.font = [UIFont systemFontOfSize:18];
    topTitle.textColor = textFontColor;
    [self.navigationController.navigationBar addSubview:topTitle];
    
    UIButton *returnButton = [UIButton buttonWithType:UIButtonTypeCustom];
    returnButton.frame = CGRectMake(0, 0, 65, 44);
    returnButton.tag = 100;
    [returnButton setTitle:@"返回" forState:UIControlStateNormal];
    [returnButton setTitleColor:textFontColor forState:UIControlStateNormal];
    returnButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [returnButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar addSubview:returnButton];
    
    //输入框背景
    UIImageView *bagImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0.5, 80, kScreenWidth, 84)];
    bagImageView.backgroundColor = [UIColor whiteColor];
    bagImageView.userInteractionEnabled = YES;
    [self.view addSubview:bagImageView];
    //输入框上横线
    UIImageView *hengxianImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5)];
    hengxianImage.backgroundColor = [UIColor lightGrayColor];
    [bagImageView addSubview:hengxianImage];
    //输入框中横线
    UIImageView *zhongHengxianImage = [[UIImageView alloc]initWithFrame:CGRectMake(20, 42, kScreenWidth-20, 0.5)];
    zhongHengxianImage.backgroundColor = [UIColor lightGrayColor];
    [bagImageView addSubview:zhongHengxianImage];
    //输入框下横线
    UIImageView *diHengxianImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 84, kScreenWidth, 0.5)];
    diHengxianImage.backgroundColor = [UIColor lightGrayColor];
    [bagImageView addSubview:diHengxianImage];
    //账号头像
    UIImageView *nameImage=[[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 20, 20)];
    nameImage.image = [UIImage imageNamed:@"zhanghao"];
    [bagImageView addSubview:nameImage];
    //密码头像
    UIImageView *passImage = [[UIImageView alloc] initWithFrame:CGRectMake(20, 52, 20, 20)];
    passImage.image = [UIImage imageNamed:@"mima"];
    [bagImageView addSubview:passImage];
    //用户名输入框
    _nameTextField = [[UITextField alloc]init];
    _nameTextField.frame = CGRectMake(50, 0, 270, 42);
    _nameTextField.placeholder = @"请输入旧密码";
    _nameTextField.borderStyle = UITextBorderStyleNone;
    _nameTextField.delegate = self;
    _nameTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    _nameTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [bagImageView addSubview:_nameTextField];
    //密码输入框
    _passTextField = [[UITextField alloc]init];
    _passTextField.frame = CGRectMake(50, 42, 270, 42);
    _passTextField.placeholder = @"请输入新密码";
    _passTextField.borderStyle = UITextBorderStyleNone;
    _passTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    _passTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _passTextField.delegate = self;
    [bagImageView addSubview:_passTextField];
    
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    loginButton.frame = CGRectMake(10, 180, kScreenWidth-20, 44);
    loginButton.tag = 101;
    [loginButton setTitle:@"注册" forState:UIControlStateNormal];
    loginButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginButton setBackgroundColor:[UIColor lightGrayColor]];
    [loginButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    loginButton.layer.borderColor = textFontColor.CGColor;
    loginButton.layer.borderWidth = 0.2;
    loginButton.layer.cornerRadius = 0;
    [self.view addSubview:loginButton];
    
}

- (void)buttonClick:(UIButton *)button
{
    if (button.tag == 100) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else if (button.tag == 101) {
        NSLog(@"haole ");
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
@end
