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
    UITextField *_YZTextField;
    
    UITextField *_nameTextField;
    UITextField *_passTextField;
    UITextField *_validationTextField;
    UIImageView *_validationImageView;
    UIImageView *_validationImageView1;
    
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
    
    UILabel *hintLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 60, 200, 15)];
    hintLabel.text = @"通过手机号注册，方便随时找回密码";
    hintLabel.textColor = [UIColor grayColor];
    hintLabel.font = [UIFont systemFontOfSize:12];
    [self.leftView addSubview:hintLabel];
    
    UIView *leftInputView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 80, kScreenWidth-0.5, 44)];
    leftInputView1.backgroundColor = [UIColor whiteColor];
    [self.leftView addSubview:leftInputView1];
    
    UIImageView *hengxianImage1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5)];
    hengxianImage1.backgroundColor = [UIColor lightGrayColor];
    [leftInputView1 addSubview:hengxianImage1];
    
    UIImageView *diHengxianImage1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 44, kScreenWidth, 0.5)];
    diHengxianImage1.backgroundColor = [UIColor lightGrayColor];
    [leftInputView1 addSubview:diHengxianImage1];
    
    _YZTextField = [[UITextField alloc]initWithFrame:CGRectMake(10, 0, kScreenWidth/2, 44)];
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
    _nameTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    _nameTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [bagImageView addSubview:_nameTextField];
    //密码输入框
    _passTextField = [[UITextField alloc]init];
    _passTextField.frame = CGRectMake(50, 42, 270, 42);
    _passTextField.placeholder = @"请输入您的密码";
    _passTextField.secureTextEntry = YES;
    _passTextField.borderStyle = UITextBorderStyleNone;
    _passTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    _passTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
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
    _validationTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    _validationTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [YZImageView addSubview:_validationTextField];
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
/***************************************************************/
#pragma mark - 注册
- (void)request
{
    NSString *urlStr = [NSString stringWithFormat:@"%@ttus/register?nick_name=%@&user_name=%@&password=%@&auth_code=%@&auth_key=%@",BaseURL,_nameTextField.text,_nameTextField.text,_passTextField.text,_validationTextField.text,auth_key];
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc]initWithURL:[NSURL URLWithString:urlStr]];
    [request setTimeOutSeconds:10];
    request.tag = 1;
    request.delegate = self;
    [request startAsynchronous];
}
#pragma mark - 获取验证码
- (void)information
{
    NSString *urlStr = [NSString stringWithFormat:@"%@ttus/authcode_image",BaseURL];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
    request.tag = 0;
    [request setTimeOutSeconds:10];
    request.delegate = self;
    [request startAsynchronous];
}
#pragma mark - 验证验证码
- (void)verification
{
    NSString *urlStr = [NSString stringWithFormat:@"%@ttus/checkCodeVeri?auth_code=%@&auth_key=%@",BaseURL,_validationTextField.text,auth_key];
    ASIHTTPRequest *request8 = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [request8 setTimeOutSeconds:10];
    request8.tag = 2;
    request8.delegate = self;
    [request8 startAsynchronous];
    
}
#pragma mark - 更新验证码
- (void)updateTheVerificationCode
{
    NSString *urlStr = [NSString stringWithFormat:@"%@ttus/authcode?id1=%@",BaseURL,auth_key];
    ASIHTTPRequest *updateRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
    updateRequest.delegate = self;
    updateRequest.tag = 4;
    [updateRequest setTimeOutSeconds:10];
    [updateRequest startAsynchronous];
}

#pragma mark - 登陆
- (void)login
{
    NSString *urlStr = [NSString stringWithFormat:@"%@ttus/login?user_name=%@&password=%@&auth_code=%@&auth_key=%@",BaseURL,_nameTextField.text,_passTextField.text,_validationTextField.text,auth_key];
    ASIHTTPRequest *loginRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [loginRequest setTimeOutSeconds:10];
    loginRequest.tag = 3;
    loginRequest.delegate = self;
    [loginRequest startAsynchronous];
}
/***************************************************************/
#pragma mark - 验证验证码
- (void)verificationtel
{
    NSString *urlStr = [NSString stringWithFormat:@"%@ttus/checkCodeVeri?auth_code=%@&auth_key=%@",BaseURL,_YZTextField.text,auth_key];
    ASIHTTPRequest *request8 = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [request8 setTimeOutSeconds:10];
    request8.tag = 5;
    request8.delegate = self;
    [request8 startAsynchronous];
    
}
//下一步
- (void)nextRequest
{
    NSString *urlStr = [NSString stringWithFormat:@"%@ttus/registerMobile?user_name=%@&auth_code=%@&auth_key=%@",BaseURL,_telTextField.text,_YZTextField.text,auth_key];
    ASIHTTPRequest *request8 = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [request8 setTimeOutSeconds:100];
    request8.tag = 6;
    request8.delegate = self;
    [request8 startAsynchronous];
}

/***************************************************************/
- (void)requestFinished:(ASIHTTPRequest *)request
{
    if (request.tag == 0) {
        id result = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        if ([result isKindOfClass:[NSDictionary class]]) {
            NSDictionary *allDTjson = [result objectForKey:@"data"];
            _str = [allDTjson objectForKey:@"auth_url"];
            auth_key = [allDTjson objectForKey:@"auth_key"];
            [_validationImageView setImageWithURL:[NSURL URLWithString:_str]];
            [_validationImageView1 setImageWithURL:[NSURL URLWithString:_str]];
        }
    } else if (request.tag == 1) {
        id result1 = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        if ([result1 isKindOfClass:[NSDictionary class]]) {
            int allDtjson1 = [[result1 objectForKey:@"code"] intValue];
            if (allDtjson1 == 30306) {
                UIAlertView *alert = [[UIAlertView alloc]init];
                alert.title = @"提示";
                alert.message = @"用户名已存在";
                [alert addButtonWithTitle:@"确定"];
                [alert show];
            } else if (allDtjson1 == 1) {
                [self login];
            }
        }
    } else if (request.tag == 2) {
        id result2 = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        if ([result2 isKindOfClass:[NSDictionary class]]) {
            int allDTjson2 = [[result2 objectForKey:@"code"] intValue];
            if (allDTjson2 == 1) {
                NSLog(@"注册成功");
                [self request];
            } else {
                UIAlertView *alert = [[UIAlertView alloc]init];
                alert.title = @"提示";
                alert.message = @"验证码输入错误";
                [alert addButtonWithTitle:@"确定"];
                [alert show];
                [self updateTheVerificationCode];
            }
        }
    } else if (request.tag == 3) {
        id result3 = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        if ([result3 isKindOfClass:[NSDictionary class]]) {
            NSDictionary *loginJson = [result3 objectForKey:@"data"];
            //存储用户信息
            LoginModel *loginModel = [[LoginModel alloc] init];
            loginModel.access_token = [loginJson objectForKey:@"access_token"];
            loginModel.userName = [loginJson objectForKey:@"username"];
            [CommonUtil saveUserModel:loginModel];
            UIViewController *viewController = self;
            viewController = viewController.presentingViewController.presentingViewController;
            [viewController dismissViewControllerAnimated:YES completion:nil];
        }
        
    } else if (request.tag == 4) {
        NSData *data = [request responseData];
        UIImage *image = [[UIImage alloc]initWithData:data];
        _validationImageView.image = image;
        _validationImageView1.image = image;
    } else if (request.tag == 5) {
        id result2 = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        if ([result2 isKindOfClass:[NSDictionary class]]) {
            int allDTjson2 = [[result2 objectForKey:@"code"] intValue];
            if (allDTjson2 == 1) {
                [self nextRequest];
            } else {
                UIAlertView *alert = [[UIAlertView alloc]init];
                alert.title = @"提示";
                alert.message = @"验证码输入错误";
                [alert addButtonWithTitle:@"确定"];
                [alert show];
                [self updateTheVerificationCode];
            }
        }
    } else if (request.tag == 6) {
        id result2 = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        if ([result2 isKindOfClass:[NSDictionary class]]) {
            int code = [[result2 objectForKey:@"code"]intValue];
            if (code == 1) {
                VerifyViewController *verify = [[VerifyViewController alloc]init];
                verify.tel = _telTextField.text;
                UINavigationController *nc = [[UINavigationController alloc]initWithRootViewController:verify];
                [self presentViewController:nc animated:YES completion:nil];
            } else {
                UIAlertView *alert = [[UIAlertView alloc]init];
                alert.title = @"提示";
                alert.message = @"该手机号码已被注册！";
                [alert addButtonWithTitle:@"确定"];
                [alert show];
            }
        }
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
        if (_telTextField.text.length == 11) {
            [self verificationtel];
        } else {
            UIAlertView *alart = [[UIAlertView alloc]init];
            alart.title = @"提示";
            alart.message = @"手机号码格式不正确，请重新输入！";
            [alart addButtonWithTitle:@"确定"];
            [alart show];
        }
    }
    //用户名注册
    else if (button.tag == 102) {
        if (_nameTextField.text.length == 0 || _passTextField.text.length == 0) {
            NSLog(@"用户名或密码不能为空");
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"失败" message:@"用户名或密码不能为空" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
            [alertView show];
        } else if ((_nameTextField.text.length <= 18 && _nameTextField.text.length >= 6) && (_passTextField.text.length >= 6 && _passTextField.text.length <= 20)) {
            if (_validationTextField.text.length == 0) {
                UIAlertView *alart = [[UIAlertView alloc]init];
                alart.title = @"失败";
                alart.message = @"请输入验证码";
                [alart addButtonWithTitle:@"确定"];
                [alart show];
            } else {
                [self verification];
            }
        } else {
        NSLog(@"用户名或密码为6-18位，请重新输入");
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"失败" message:@"用户名或密码为6-18位，请重新输入" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        [alertView show];
        }
    }else if (button.tag == 101) {
        LoginViewController *login = [[LoginViewController alloc] init];
        login.controllerType = registerType;
        UINavigationController *nc = [[UINavigationController alloc]initWithRootViewController:login];
        [self presentViewController:nc animated:YES completion:nil];
    } else {
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
