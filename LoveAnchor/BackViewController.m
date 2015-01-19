//
//  BackViewController.m
//  LoveAnchor
//
//  Created by zhongqinglongtu on 15-1-10.
//  Copyright (c) 2015年 zhongqinglongtu. All rights reserved.
//

#import "BackViewController.h"

@interface BackViewController ()<ASIHTTPRequestDelegate>
{
    UITextField *_telTextField;
    UITextField *_YZTextField;
    UIImageView *_validationImageView1;
    
    NSString    *_auth_key;
    NSString    *_auth_url;
}


@end

@implementation BackViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _auth_key = [[NSString alloc]init];
        _auth_url = [[NSString alloc]init];
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
    nextButton.tag = 101;
    nextButton.selected = NO;
    [nextButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextButton];
    
}
- (void)buttonClick:(UIButton *)button
{
    if (button.tag == 100) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        if (_telTextField.text.length == 11) {
            [self verification];
        } else {
            UIAlertView *alert = [[UIAlertView alloc]init];
            alert.title = @"提示";
            alert.message = @"手机号码为11位，请重新输入";
            [alert addButtonWithTitle:@"确定"];
            [alert show];

        }
        
    }
    
}
-(void)judgeClick:(UITapGestureRecognizer *)tap
{
    NSLog(@"111111");
    [self updateTheVerificationCode];
}
#pragma mark - 数据
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
    NSString *urlStr = [NSString stringWithFormat:@"%@ttus/checkCodeVeri?auth_code=%@&auth_key=%@",BaseURL,_YZTextField.text,_auth_key];
    ASIHTTPRequest *request8 = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [request8 setTimeOutSeconds:10];
    request8.tag = 1;
    request8.delegate = self;
    [request8 startAsynchronous];
    
}
#pragma mark - 更新验证码
- (void)updateTheVerificationCode
{
    NSString *urlStr = [NSString stringWithFormat:@"%@ttus/authcode?id1=%@",BaseURL,_auth_key];
    ASIHTTPRequest *updateRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
    updateRequest.delegate = self;
    updateRequest.tag = 2;
    [updateRequest setTimeOutSeconds:100];
    [updateRequest startAsynchronous];
}
#pragma mark - 获得忘记密码验证码
- (void)forgotPasswordRequest
{
    NSString *urlStr = [NSString stringWithFormat:@"%@public/forgotPassword?mobileNo=%@&auth_code=%@&auth_key=%@",BaseURL,_telTextField.text,_YZTextField.text,_auth_key];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
    request.tag = 3;
    request.delegate = self;
    [request setTimeOutSeconds:100];
    [request startAsynchronous];
}
- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"111 = %@",request.responseString);
    id result = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];

        switch (request.tag) {
            //获取验证码
            case 0:
            {
                if ([result isKindOfClass:[NSDictionary class]]) {
                    NSDictionary *dict = [result objectForKey:@"data"];
                    _auth_key = [dict objectForKey:@"auth_key"];
                    _auth_url = [dict objectForKey:@"auth_url"];
                    [_validationImageView1 setImageWithURL:[NSURL URLWithString:_auth_url]];
                }
            }
                break;
            //验证验证码
            case 1:
            {
                int code = [[result objectForKey:@"code"]intValue];
                if (code == 1) {
                    [self forgotPasswordRequest];
                } else {
                    UIAlertView *alert = [[UIAlertView alloc]init];
                    alert.title = @"提示";
                    alert.message = @"验证码验证失败";
                    [alert addButtonWithTitle:@"重新输入"];
                    [alert show];
                    
                }
            }
                break;
            //更新验证码
            case 2:
            {
                NSData *data = [request responseData];
                NSLog(@"123 == %@",data);
                UIImage *image = [[UIImage alloc]initWithData:data];
                _validationImageView1.image = image;
            }
                break;
            //获得忘记密码验证码
            case 3:
            {
                int code = [[result objectForKey:@"code"]intValue];
                if (code == 1) {
                    NSLog(@"调到下一页");
                    RetrieveViewController *retrieve = [[RetrieveViewController alloc]init];
                    retrieve.tel = _telTextField.text;
                    UINavigationController *nc = [[UINavigationController alloc]initWithRootViewController:retrieve];
                    [self presentViewController:nc animated:YES completion:nil];
                } else if (code == 31509) {
                    UIAlertView *alert = [[UIAlertView alloc]init];
                    alert.title = @"提示";
                    alert.message = @"手机号还没有绑定！";
                    [alert addButtonWithTitle:@"确定"];
                    [alert show];
                }
            }
                break;
                
            default:
                break;
        }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
@end
