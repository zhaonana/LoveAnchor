//
//  RegisterViewController.m
//  LoveAnchor
//
//  Created by zhongqinglongtu on 14-10-10.
//  Copyright (c) 2014年 zhongqinglongtu. All rights reserved.
//

#import "RegisterViewController.h"

@interface RegisterViewController ()<UIScrollViewDelegate,UITextFieldDelegate,ASIHTTPRequestDelegate> {
    UIScrollView *_rootScrollView;
    UIView *_lineVIew;
    UIButton *_leftButton;
    UIButton *_rightButton;
    UITextField *_telTextField;
    
    UITextField *_nameTextField;
    UITextField *_passTextField;
    UITextField *_validationTextField;
    UIImageView *_validationImageView;
    UIImageView *_judgeImage;
    
    NSString *_str;
    NSString *auth_key;
    RegisterModel *_registerModel;
}

@property (nonatomic,strong)UIView *leftView;
@property (nonatomic,strong)UIView *rightView;

@end

@implementation RegisterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _str = [[NSString alloc]init];
        auth_key = [[NSString alloc]init];
        _registerModel = [[RegisterModel alloc]init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self showUI];
    [self information];
}
#pragma mark - 界面
- (void)showUI
{
    self.view.backgroundColor = [UIColor colorWithRed:232/255.0 green:241/255.0 blue:243/255.0 alpha:1];

    UIButton *returnButton = [UIButton buttonWithType:UIButtonTypeCustom];
    returnButton.frame = CGRectMake(10, 0, 50, 44);
    returnButton.tag = 100;
    [returnButton setTitle:@"返回" forState:UIControlStateNormal];
    [returnButton setTitleColor:textFontColor forState:UIControlStateNormal];
    returnButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [returnButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar addSubview:returnButton];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(140, 0, 40, 44)];
    titleLabel.text = @"注册";
    titleLabel.textColor = textFontColor;
    titleLabel.font = [UIFont systemFontOfSize:18];
    [self.navigationController.navigationBar addSubview:titleLabel];
    
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, 38)];
    topView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:topView];
    
    _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _leftButton.frame = CGRectMake(0, 0, kScreenWidth/2, 37);
    [_leftButton setTitle:@"手机号注册" forState:UIControlStateNormal];
    [_leftButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_leftButton setTitleColor:textFontColor forState:UIControlStateSelected];
    [_leftButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    _leftButton.selected = YES;
    _leftButton.tag = 0;
    [topView addSubview:_leftButton];
    
    _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightButton.frame = CGRectMake(kScreenWidth/2, 0, kScreenWidth/2, 37);
    [_rightButton setTitle:@"用户名注册" forState:UIControlStateNormal];
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
    
    _rootScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 102, kScreenWidth, kScreenHeight)];
    _rootScrollView.contentSize = CGSizeMake(kScreenWidth *2, 0);
    _rootScrollView.showsHorizontalScrollIndicator = NO;
    _rootScrollView.showsVerticalScrollIndicator = NO;
    _rootScrollView.pagingEnabled = YES;
    _rootScrollView.delegate = self;
    [self.view addSubview:_rootScrollView];
    
    self.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    self.leftView.backgroundColor = [UIColor colorWithRed:232/255.0 green:241/255.0 blue:243/255.0 alpha:1];
    [_rootScrollView addSubview:self.leftView];
    [self createLeftView];
    
    self.rightView = [[UIView alloc]initWithFrame:CGRectMake(kScreenWidth, 0, kScreenWidth, kScreenHeight)];
    self.rightView.backgroundColor = [UIColor colorWithRed:232/255.0 green:241/255.0 blue:243/255.0 alpha:1];
    [_rootScrollView addSubview:self.rightView];
    [self createRightView];
}
#pragma mark - 手机号注册
- (void)createLeftView
{
    UIView *leftInputView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, kScreenWidth-0.5, 44)];
    leftInputView.backgroundColor = [UIColor whiteColor];
    [self.leftView addSubview:leftInputView];
    
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
    
    UILabel *hintLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 100, 200, 30)];
    hintLabel.text = @"通过手机号注册，方便随时找回密码";
    hintLabel.textColor = [UIColor grayColor];
    hintLabel.font = [UIFont systemFontOfSize:12];
    [self.leftView addSubview:hintLabel];
    
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    nextButton.frame = CGRectMake(15, 130, 290, 44);
    [nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    [nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nextButton setBackgroundColor:[UIColor lightGrayColor]];
    nextButton.tag = 103;
    nextButton.selected = NO;
    [nextButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.leftView addSubview:nextButton];
    
}
#pragma mark - 用户名注册
- (void)createRightView
{
    //输入框背景
    UIImageView *bagImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0.5, 10, kScreenWidth, 84)];
    bagImageView.backgroundColor = [UIColor whiteColor];
    bagImageView.userInteractionEnabled = YES;
    [self.rightView addSubview:bagImageView];
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
    _nameTextField.placeholder = @"请输入您的用户名";
    _nameTextField.borderStyle = UITextBorderStyleNone;
    _nameTextField.delegate = self;
    [bagImageView addSubview:_nameTextField];
    //密码输入框
    _passTextField = [[UITextField alloc]init];
    _passTextField.frame = CGRectMake(50, 42, 270, 42);
    _passTextField.placeholder = @"请输入您的密码";
    _passTextField.borderStyle = UITextBorderStyleNone;
    _passTextField.delegate = self;
    [bagImageView addSubview:_passTextField];
    //验证码背景
    UIImageView *YZImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 105, kScreenWidth, 44)];
    YZImageView.backgroundColor = [UIColor whiteColor];
    YZImageView.userInteractionEnabled = YES;
    [self.rightView addSubview:YZImageView];
    //验证码输入框
    _validationTextField = [[UITextField alloc]init];
    _validationTextField.frame = CGRectMake(20, 0, 100, 44);
    _validationTextField.font = [UIFont systemFontOfSize:14];
    _validationTextField.placeholder = @"请输入验证码";
    _validationTextField.borderStyle = UITextBorderStyleNone;
    _validationTextField.delegate = self;
    [YZImageView addSubview:_validationTextField];
    //判断验证码对错的图片
    _judgeImage = [[UIImageView alloc]initWithFrame:CGRectMake(130, 15, 17, 17)];
    [YZImageView addSubview:_judgeImage];
    //验证码图片
    _validationImageView = [[UIImageView alloc]initWithFrame:CGRectMake(240, 12, 55, 20)];
    _validationImageView.backgroundColor = [UIColor clearColor];
    _validationImageView.userInteractionEnabled = YES;
    [YZImageView addSubview:_validationImageView];
    //点击手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(judgeClick:)];
    [_validationImageView addGestureRecognizer:tap];
    //返回登陆按钮
    UIButton *registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    registerButton.frame = CGRectMake(13, 160, 140, 44);
    registerButton.tag = 101;
    registerButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [registerButton setTitle:@"返回登陆" forState:UIControlStateNormal];
    [registerButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [registerButton setBackgroundColor:[UIColor whiteColor]];
    [registerButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    registerButton.layer.borderColor = textFontColor.CGColor;
    registerButton.layer.borderWidth = 0.2;
    registerButton.layer.cornerRadius = 5.0;
    [self.rightView addSubview:registerButton];
    //注册按钮
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    loginButton.frame = CGRectMake(167, 160, 140, 44);
    loginButton.tag = 102;
    [loginButton setTitle:@"注册" forState:UIControlStateNormal];
    loginButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [loginButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [loginButton setBackgroundColor:[UIColor whiteColor]];
    [loginButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    loginButton.layer.borderColor = textFontColor.CGColor;
    loginButton.layer.borderWidth = 0.2;
    loginButton.layer.cornerRadius = 5.0;
    [self.rightView addSubview:loginButton];
}

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
- (void)judgeClick:(UITapGestureRecognizer *)sender
{
    NSLog(@"12345678");
    [self updateTheVerificationCode];
}

#pragma mark - 注册
- (void)request
{
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc]initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://ttapi.izhubo.com/ttus/register?nick_name=%@&user_name=%@&password=%@&auth_code=%@&auth_key=%@",_nameTextField.text,_nameTextField.text,_passTextField.text,_validationTextField.text,auth_key]]];
    NSLog(@"0000 == %@",request);
    [request setTimeOutSeconds:10];
    request.tag = 1;
    request.delegate = self;
    [request startAsynchronous];
}
#pragma mark - 获取验证码
- (void)information
{
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:@"http://ttapi.izhubo.com/ttus/authcode_image"]];
    request.tag = 0;
    [request setTimeOutSeconds:10];
    request.delegate = self;
    [request startAsynchronous];
}
#pragma mark - 验证验证码
- (void)verification
{
    ASIHTTPRequest *request8 = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://ttapi.izhubo.com/ttus/checkCodeVeri?auth_code=%@&auth_key=%@",_validationTextField.text,auth_key]]];
    [request8 setTimeOutSeconds:10];
    request8.tag = 2;
    request8.delegate = self;
    [request8 startAsynchronous];
    
}
#pragma mark - 更新验证码
- (void)updateTheVerificationCode
{
    ASIHTTPRequest *updateRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://ttapi.izhubo.com/ttus/authcode?id1=%@",auth_key]]];
    updateRequest.delegate = self;
    updateRequest.tag = 4;
    [updateRequest setTimeOutSeconds:10];
    [updateRequest startAsynchronous];
}

#pragma mark - 登陆
- (void)login
{
    ASIHTTPRequest *loginRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://ttapi.izhubo.com/ttus/login?user_name=%@&password=%@&auth_code=%@&auth_key=%@",_registerModel.userName,_registerModel.passWord,_validationTextField.text,auth_key]]];
    [loginRequest setTimeOutSeconds:10];
    loginRequest.tag = 3;
    loginRequest.delegate = self;
    [loginRequest startAsynchronous];
}
- (void)requestFinished:(ASIHTTPRequest *)request
{
    
    if (request.tag == 0) {
        NSLog(@"获取验证码为:%@",request.responseString);
        id result = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        if ([result isKindOfClass:[NSDictionary class]]) {
            NSDictionary *allDTjson = [result objectForKey:@"data"];
            NSLog(@"123 == %@",allDTjson);
            _str = [allDTjson objectForKey:@"auth_url"];
            auth_key = [allDTjson objectForKey:@"auth_key"];
            NSLog(@"456 == %@",_str);
            [_validationImageView setImageWithURL:[NSURL URLWithString:_str]];
            NSLog(@"vvv==%@",auth_key);
        }
    } else if (request.tag == 1) {
        NSLog(@"注册:%@",request.responseString);
        id result1 = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        if ([result1 isKindOfClass:[NSDictionary class]]) {
            int allDtjson1 = [[result1 objectForKey:@"code"] intValue];
            NSLog(@"ooo == %d",allDtjson1);
            if (allDtjson1 == 30306) {
                UIAlertView *alert = [[UIAlertView alloc]init];
                alert.title = @"提示";
                alert.message = @"用户名已存在";
                [alert addButtonWithTitle:@"确定"];
                [alert show];
            }
        }
    } else if (request.tag == 2) {
        id result2 = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        if ([result2 isKindOfClass:[NSDictionary class]]) {
            int allDTjson2 = [[result2 objectForKey:@"code"] intValue];
            NSLog(@"验证验证码 == %d",allDTjson2);
            if (allDTjson2 == 1) {
                _judgeImage.image = [UIImage imageNamed:@"dui"];
            } else {
                UIAlertView *alert = [[UIAlertView alloc]init];
                alert.title = @"提示";
                alert.message = @"验证码输入错误";
                [alert addButtonWithTitle:@"确定"];
                [alert show];
                _judgeImage.image = [UIImage imageNamed:@"cuowu"];
            }
        }
    } else if (request.tag == 3) {
        NSLog(@"登陆 == %@",request.responseString);
        id result3 = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        if ([result3 isKindOfClass:[NSDictionary class]]) {
            NSDictionary *allDTjson3 = [result3 objectForKey:@"code"];
            NSLog(@"登陆 == %@",allDTjson3);
        }
    } else if (request.tag == 4) {
        NSData *data = [request responseData];
        NSLog(@"更新验证码 = %@",data);
        UIImage *image = [[UIImage alloc]initWithData:data];
        _validationImageView.image = image;
    }
}


#pragma mark - 点击事件
- (void)buttonClick:(UIButton *)button
{
    //返回
    if (button.tag == 100) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    //手机号注册下一步
    else if (button.tag == 103) {
        button.backgroundColor = textFontColor;
        button.selected = NO;
        VerifyViewController *verify = [[VerifyViewController alloc]init];
        UINavigationController *nc = [[UINavigationController alloc]initWithRootViewController:verify];
        [self presentViewController:nc animated:YES completion:nil];
    }
    //用户名注册
    else if (button.tag == 102) {
        [self verification];
        [self request];
        if (_nameTextField.text.length == 0 || _passTextField.text.length == 0) {
            NSLog(@"用户名或密码不能为空");
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"失败" message:@"用户名或密码不能为空" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
            [alertView show];
        } else if ((_nameTextField.text.length <= 18 && _nameTextField.text.length >= 6) && (_passTextField.text.length >= 6 && _passTextField.text.length <= 20)) {
            NSLog(@"注册成功");
            [self login];
//            PersonageViewController *personage = [[PersonageViewController alloc]init];
//            [self presentViewController:personage animated:YES completion:nil];
            _registerModel.userName = _nameTextField.text;
            _registerModel.passWord = _passTextField.text;
            NSLog(@"_userName == %@",_registerModel.userName);
            NSLog(@"_passWord == %@",_registerModel.passWord);
        } else {
        NSLog(@"用户名或密码为6-18位，请重新输入");
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"失败" message:@"用户名或密码为6-18位，请重新输入" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        [alertView show];
        }
    }else {
        NSLog(@"%ld",button.tag);
        if (button.selected) {
            return;
        }
        [self information];
        _leftButton.selected = NO;
        _rightButton.selected = NO;
        button.selected = YES;
        [UIView animateWithDuration:0 animations:^{
            _rootScrollView.contentOffset = CGPointMake(kScreenWidth*button.tag, 0);
            [self changed];
            
        }];
    }
}


-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [UIView animateWithDuration:0 animations:^{
        [self changed];
    }];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_telTextField resignFirstResponder];
}
@end
