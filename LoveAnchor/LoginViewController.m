//
//  LoginViewController.m
//  LoveAnchor
//
//  Created by zhongqinglongtu on 14-9-16.
//  Copyright (c) 2014年 zhongqinglongtu. All rights reserved.
//

#import "LoginViewController.h"
#import <ShareSDK/ShareSDK.h>
#import <CommonCrypto/CommonDigest.h>

#define REFRESH_LEFTMENU_NOTIFITION @"refreshLeftMenuNotifition"
#define REFRESH_PLAYVIEW_NOTIFITION @"refreshPlayViewNotifition"

@interface LoginViewController ()<ASIHTTPRequestDelegate>
{
    UITextField *_nameTextField;
    UITextField *_passTextField;
    UITextField *_validationTextField;
    UIImageView *_imageView;
    
    NSString *_imageURL;
    NSString *_getAuth_key;
    LoginModel *model;
    NSString *_access_token;
}

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _imageURL = [[NSString alloc]init];
        _getAuth_key = [[NSString alloc]init];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    model = [CommonUtil getUserModel];

    [self showUI];
    [self getVerificationCode];
    [ShareSDK cancelAuthWithType:ShareTypeSinaWeibo];
    [ShareSDK cancelAuthWithType:ShareTypeQQSpace];
}

#pragma mark - UI
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
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(135, 0, 50, 44)];
    label.text = @"登陆";
    label.font = [UIFont systemFontOfSize:18];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = textFontColor;
    [self.navigationController.navigationBar addSubview:label];
    
    UIImageView *bagImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 84, kScreenWidth, 84)];
    bagImageView.backgroundColor = [UIColor whiteColor];
    bagImageView.userInteractionEnabled = YES;
    [self.view addSubview:bagImageView];
    
    UIImageView *hengxianImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 83, kScreenWidth, 0.5)];
    hengxianImage.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:hengxianImage];
    
    UIImageView *zhongHengxianImage = [[UIImageView alloc]initWithFrame:CGRectMake(20, 42, kScreenWidth-20, 0.5)];
    zhongHengxianImage.backgroundColor = [UIColor lightGrayColor];
    [bagImageView addSubview:zhongHengxianImage];
    
    UIImageView *diHengxianImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 168, kScreenWidth, 0.5)];
    diHengxianImage.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:diHengxianImage];
    
    _nameTextField = [[UITextField alloc]init];
    _nameTextField.frame = CGRectMake(50, 0, 270, 42);
    _nameTextField.placeholder = @"请输入您的用户名";
    _nameTextField.text = model.userName;
    _nameTextField.borderStyle = UITextBorderStyleNone;//圆角
    [_nameTextField setAutocorrectionType:UITextAutocorrectionTypeNo];//联想
    [_nameTextField setAutocapitalizationType:UITextAutocapitalizationTypeNone];//关闭首字母大写
    _nameTextField.delegate = self;
    [bagImageView addSubview:_nameTextField];
    
    UIImageView *nameImage=[[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 20, 20)];
    nameImage.image = [UIImage imageNamed:@"zhanghao"];
    [bagImageView addSubview:nameImage];
    
    _passTextField = [[UITextField alloc]init];
    _passTextField.frame = CGRectMake(50, 42, 270, 42);
    _passTextField.placeholder = @"请输入您的密码";
    _passTextField.secureTextEntry = YES;
    _passTextField.borderStyle = UITextBorderStyleNone;
    [_passTextField setAutocorrectionType:UITextAutocorrectionTypeNo];
    [_passTextField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    _passTextField.delegate = self;
    [bagImageView addSubview:_passTextField];
    
    UIImageView *passImage = [[UIImageView alloc] initWithFrame:CGRectMake(20, 52, 20, 20)];
    passImage.image = [UIImage imageNamed:@"mima"];
    [bagImageView addSubview:passImage];
    
    UIImageView *YZImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 176, kScreenWidth, 44)];
    YZImageView.backgroundColor = [UIColor whiteColor];
    YZImageView.userInteractionEnabled = YES;
    [self.view addSubview:YZImageView];
    
    _validationTextField = [[UITextField alloc]init];
    _validationTextField.frame = CGRectMake(20, 0, 100, 44);
    _validationTextField.placeholder = @"请输入验证码";
    _validationTextField.font = [UIFont systemFontOfSize:14];
    _validationTextField.borderStyle = UITextBorderStyleNone;
    _validationTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _validationTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    _validationTextField.tag = 100;
    _validationTextField.delegate = self;
    [YZImageView addSubview:_validationTextField];
    
    _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(240, 12, 55, 20)];
    _imageView.userInteractionEnabled = YES;
    _imageView.tag = 6;
    [YZImageView addSubview:_imageView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(topClick:)];
    [_imageView addGestureRecognizer:tap];
    
    UIButton *registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    registerButton.frame = CGRectMake(13, 226, 140, 44);
    registerButton.tag = 101;
    registerButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [registerButton setTitle:@"注册新用户" forState:UIControlStateNormal];
    [registerButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [registerButton setBackgroundColor:[UIColor whiteColor]];
    [registerButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    registerButton.layer.borderColor = textFontColor.CGColor;
    registerButton.layer.borderWidth = 0.2;
    registerButton.layer.cornerRadius = 5.0;
    [self.view addSubview:registerButton];
    
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    loginButton.frame = CGRectMake(167, 226, 140, 44);
    loginButton.tag = 102;
    [loginButton setTitle:@"登陆" forState:UIControlStateNormal];
    loginButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [loginButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [loginButton setBackgroundColor:[UIColor whiteColor]];
    [loginButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    loginButton.layer.borderColor = textFontColor.CGColor;
    loginButton.layer.borderWidth = 0.2;
    loginButton.layer.cornerRadius = 5.0;
    [self.view addSubview:loginButton];
    
    UIButton *forgetButton = [[UIButton alloc]initWithFrame:CGRectMake(200, 275, 100, 20)];
    [forgetButton setTitle:@"忘记密码？" forState:UIControlStateNormal];
    [forgetButton setTitleColor:textFontColor forState:UIControlStateNormal];
    forgetButton.tag = 105;
    forgetButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [forgetButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:forgetButton];
    
    UILabel *sanLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 310, 112, 15)];
    sanLabel.text = @"使用第三方账户登陆";
    sanLabel.font = [UIFont systemFontOfSize:12];
    sanLabel.textColor = [UIColor lightGrayColor];
    [self.view addSubview:sanLabel];
    
    UIButton *QQButton = [UIButton buttonWithType:UIButtonTypeCustom];
    QQButton.frame = CGRectMake(15, 330, kScreenWidth-30, 45);
    QQButton.tag = 103;
    [QQButton setTitle:@"QQ账号登陆" forState:UIControlStateNormal];
    QQButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [QQButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [QQButton setBackgroundColor:[UIColor colorWithRed:15/255.0 green:122/255.0 blue:189/255.0 alpha:1]];
    [QQButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [QQButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 14, 0, 0)];
    [self.view addSubview:QQButton];
    
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(72, 11, 20, 20)];
    image.image = [UIImage imageNamed:@"xiaoqie"];
    [QQButton addSubview:image];
    
    UIButton *WBButton = [UIButton buttonWithType:UIButtonTypeCustom];
    WBButton.frame = CGRectMake(15, 390, kScreenWidth-30, 45);
    WBButton.tag = 104;
    [WBButton setTitle:@"新浪微博账户登陆" forState:UIControlStateNormal];
    WBButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [WBButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [WBButton setBackgroundColor:[UIColor colorWithRed:251/255.0 green:48/255.0 blue:58/255.0 alpha:1]];
    [WBButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [WBButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 50, 0, 0)];
    [self.view addSubview:WBButton];

    UIImageView *image1 = [[UIImageView alloc]initWithFrame:CGRectMake(72, 11, 20, 20)];
    image1.image = [UIImage imageNamed:@"weibo"];
    [WBButton addSubview:image1];
}

- (void)topClick:(UITapGestureRecognizer *)sender
{
    [self updateTheVerificationCode];
}

#pragma mark - 点击事件
- (void)buttonClick:(UIButton *)button
{
    switch (button.tag) {
        case 100: {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
            break;
        case 101: {
            RegisterViewController *registerController = [[RegisterViewController alloc]init];
            UINavigationController *nc = [[UINavigationController alloc]initWithRootViewController:registerController];
            [self presentViewController:nc animated:NO completion:nil];
        }
            break;
        case 102: {
            if ((_nameTextField.text.length >=6 && _nameTextField.text.length <= 18) &&(_passTextField.text.length >= 6 && _passTextField.text.length <= 20)) {
                [self verifyTheVerificationCode];
            } else {
                UIAlertView *alert = [[UIAlertView alloc]init];
                alert.title = @"提示";
                alert.message = @"用户名或密码不正确，请重新输入";
                [alert addButtonWithTitle:@"确定"];
                [alert show];
            }
        }
            break;
        case 103: {
            [ShareSDK getUserInfoWithType:ShareTypeQQSpace authOptions:nil result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
                if (result) {
                    [self otherLoginRequestWithUsertoken:[[userInfo credential] token] userid:[userInfo uid] t3pf:@"mqq" nickname:[userInfo nickname] picurl:[userInfo profileImage]];
                    [ShareSDK cancelAuthWithType:ShareTypeQQSpace];
                }
            }];
        }
            break;
        case 104: {
            if ([ShareSDK hasAuthorizedWithType:ShareTypeSinaWeibo]) {
                NSLog(@"已经授权~");
            } else {
                [ShareSDK authWithType:ShareTypeSinaWeibo options:[ShareSDK authOptionsWithAutoAuth:YES allowCallback:YES scopes:nil powerByHidden:YES followAccounts:nil authViewStyle:SSAuthViewStyleFullScreenPopup viewDelegate:nil authManagerViewDelegate:nil] result:^(SSAuthState state, id<ICMErrorInfo> error) {
                    if (state == SSAuthStateSuccess) {
                        NSLog(@"授权成功~");
                        [ShareSDK getUserInfoWithType:ShareTypeSinaWeibo authOptions:nil result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
                            if (result) {
                                [self otherLoginRequestWithUsertoken:[[userInfo credential] token] userid:[userInfo uid] t3pf:@"mqq" nickname:[userInfo nickname] picurl:[userInfo profileImage]];
                                [ShareSDK cancelAuthWithType:ShareTypeSinaWeibo];
                            }
                        }];
                    } else if (state == SSAuthStateFail) {
                        NSLog(@"授权失败~");
                    }
                }];
            }
        }
            break;
        case 105: {
            BackViewController *back = [[BackViewController alloc]init];
            UINavigationController *nc = [[UINavigationController alloc]initWithRootViewController:back];
            [self presentViewController:nc animated:YES completion:nil];
        }
        default:
            break;
    }
    
}

//第三方登录
- (void)otherLoginRequestWithUsertoken:(NSString *)usertoken userid:(NSString *)userid t3pf:(NSString *)t3pf nickname:(NSString *)nickname picurl:(NSString *)picurl
{
    NSString *md5token = [self md5:usertoken];
    NSString *encodingNickname = [nickname stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *encodingPicurl = [picurl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *urlStr = [NSString stringWithFormat:@"%@/ttus/t3login?userid=%@&usertoken=%@&via=iphone&t3pf=%@&nickname=%@&picurl=%@",BaseURL,userid,md5token,t3pf,encodingNickname,encodingPicurl];
    ASIHTTPRequest *logRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
    logRequest.delegate = self;
    logRequest.tag = 4;
    [logRequest setTimeOutSeconds:10];
    [logRequest startAsynchronous];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

//所有数据
- (void)allRequestWithToken:(NSString *)access_token
{
    NSString *urlStr = [NSString stringWithFormat:@"%@user/info/%@",BaseURL,access_token];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
    request.delegate = self;
    request.tag = 5;
    [request setTimeOutSeconds:30];
    [request startAsynchronous];
}

#pragma mark - 登陆
- (void)LoginRequest
{
    NSString *urlStr = [NSString stringWithFormat:@"%@ttus/login?user_name=%@&password=%@&auth_code=%@&auth_key=%@",BaseURL,_nameTextField.text,_passTextField.text,_validationTextField.text,_getAuth_key];
    ASIHTTPRequest *logRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
    logRequest.delegate = self;
    logRequest.tag = 3;
    [logRequest setTimeOutSeconds:10];
    [logRequest startAsynchronous];
}

#pragma mark - 获取验证码
- (void)getVerificationCode
{
    NSString *urlStr = [NSString stringWithFormat:@"%@ttus/authcode_image",BaseURL];
    ASIHTTPRequest *getRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [getRequest setTimeOutSeconds:10];
    getRequest.delegate = self;
    getRequest.tag = 0;
    [getRequest startAsynchronous];
    
}

#pragma mark - 验证验证码
- (void)verifyTheVerificationCode
{
    NSString *urlStr = [NSString stringWithFormat:@"%@ttus/checkCodeVeri?auth_code=%@&auth_key=%@",BaseURL,_validationTextField.text,_getAuth_key];
    ASIHTTPRequest *verifyRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
    verifyRequest.delegate = self;
    verifyRequest.tag = 1;
    [verifyRequest setTimeOutSeconds:10];
    [verifyRequest startAsynchronous];
}
#pragma mark - 更新验证码
- (void)updateTheVerificationCode
{
    NSString *urlStr = [NSString stringWithFormat:@"%@ttus/authcode?id1=%@",BaseURL,_getAuth_key];
    ASIHTTPRequest *updateRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
    updateRequest.delegate = self;
    updateRequest.tag = 2;
    [updateRequest setTimeOutSeconds:10];
    [updateRequest startAsynchronous];
}

#pragma mark - 获取成功返回
- (void)requestFinished:(ASIHTTPRequest *)request
{
    id result = [NSJSONSerialization JSONObjectWithData:request.responseData
                                                  options:NSJSONReadingMutableContainers
                                                    error:nil];
    switch (request.tag) {
        case 0: {
            if ([result isKindOfClass:[NSDictionary class]]) {
                NSDictionary *getJson = [result objectForKey:@"data"];
                _imageURL = [getJson objectForKey:@"auth_url"];
                [_imageView setImageWithURL:[NSURL URLWithString:_imageURL]];
                _getAuth_key = [getJson objectForKey:@"auth_key"];
            }
        }
            break;
        case 1: {
            if ([result isKindOfClass:[NSDictionary class]]) {
                int verifyJson = [[result objectForKey:@"code"] intValue];
                if (verifyJson == 1) {
                    [self LoginRequest];
                } else {
                    [self updateTheVerificationCode];
                    UIAlertView *alert = [[UIAlertView alloc]init];
                    alert.title = @"提示";
                    alert.message = @"验证码输入错误";
                    [alert addButtonWithTitle:@"确定"];
                    [alert show];
                }
            }
        }
            break;
        case 2: {
            NSData *data = [request responseData];
            UIImage *image = [[UIImage alloc] initWithData:data];
            _imageView.image = image;
        }
            break;
        case 3: {
            if ([result isKindOfClass:[NSDictionary class]]) {
                NSDictionary *loginJson = [result objectForKey:@"data"];
                int code = [[result objectForKey:@"code"] intValue];
                if (code == 1) {
//                    LoginModel *loginModel = [[LoginModel alloc] init];
//                    loginModel.access_token = [loginJson objectForKey:@"access_token"];
//                    loginModel.passWord = [loginJson objectForKey:@"password"];
//                    loginModel.userName = [loginJson objectForKey:@"username"];
                    _access_token = [loginJson objectForKey:@"access_token"];
                    [self allRequestWithToken:_access_token];

//                    [self loginSuccessedWithLoginModel:loginModel];
                } else if (code == 30312) {
                    UIAlertView *alert = [[UIAlertView alloc]init];
                    alert.title = @"提示";
                    alert.message = @"用户名不存在";
                    [alert addButtonWithTitle:@"确定"];
                    [alert show];
                } else if (code == 30302) {
                    UIAlertView *alert = [[UIAlertView alloc]init];
                    alert.title = @"提示";
                    alert.message = @"用户名或密码不正确";
                    [alert addButtonWithTitle:@"确定"];
                    [alert show];
                }
            }
        }
            break;
        case 4: {
            if ([result isKindOfClass:[NSDictionary class]]) {
                NSNumber *code = [result objectForKey:@"code"];
                if (code.intValue == 1) {
                    NSDictionary *otherDic = [result objectForKey:@"data"];
                    _access_token = [otherDic objectForKey:@"access_token"];
                    [self allRequestWithToken:_access_token];
                }
            }
        }
            break;
        case 5: {
            if ([result isKindOfClass:[NSDictionary class]]) {
                NSNumber *code = [result objectForKey:@"code"];
                if (code.intValue == 1) {
                    NSDictionary *dict = [result objectForKey:@"data"];
                    LoginModel *loginModel = [[LoginModel alloc] init];
                    loginModel.userName = [dict objectForKey:@"nick_name"];
                    loginModel.finance = [dict objectForKey:@"finance"];
                    loginModel.access_token = _access_token;
                    
                    [self loginSuccessedWithLoginModel:loginModel];
                }
            }
        }
            break;
        default:
            break;
    }
}

- (void)loginSuccessedWithLoginModel:(LoginModel *)loginModel
{
    //存储用户信息
    [CommonUtil saveUserModel:loginModel];
    [[NSNotificationCenter defaultCenter] postNotificationName:REFRESH_LEFTMENU_NOTIFITION object:nil];
    switch (self.controllerType) {
        case registerType:
        case leftmenuType: {
            PersonageViewController *personage = [[PersonageViewController alloc] init];
            personage.firstLogin = YES;
            [personage setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
            UINavigationController *nc = [[UINavigationController alloc]initWithRootViewController:personage];
            [self presentViewController:nc animated:YES completion:nil];
        }
            break;
        case livehallType:
        case dynamicType:
        case rankingType: {
            [self dismissViewControllerAnimated:YES completion:^{
                
            }];
        }
            break;
        case playType: {
            [[NSNotificationCenter defaultCenter] postNotificationName:REFRESH_PLAYVIEW_NOTIFITION object:nil];
            [self dismissViewControllerAnimated:YES completion:^{
                
            }];
        }
            break;
        default:
            break;
    }
}

#pragma mark - md5
- (NSString *)md5:(NSString *)str
{
    const char *concat_str = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(concat_str, strlen(concat_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++){
        [hash appendFormat:@"%02X", result[i]];
    }
    return [hash lowercaseString];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
