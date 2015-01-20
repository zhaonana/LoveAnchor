//
//  VerifyViewController.m
//  LoveAnchor
//
//  Created by zhongqinglongtu on 14-10-10.
//  Copyright (c) 2014年 zhongqinglongtu. All rights reserved.
//

#import "VerifyViewController.h"

@interface VerifyViewController ()<ASIHTTPRequestDelegate,UIAlertViewDelegate>
{
    UITextField *passTextField;
    UITextField *nameTextField;
}

@end

@implementation VerifyViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
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

    UIButton *returnButton = [UIButton buttonWithType:UIButtonTypeCustom];
    returnButton.frame = CGRectMake(10, 0, 50, 44);
    returnButton.tag = 100;
    [returnButton setTitle:@"返回" forState:UIControlStateNormal];
    [returnButton setTitleColor:textFontColor forState:UIControlStateNormal];
    returnButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [returnButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar addSubview:returnButton];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(110, 0, 100, 44)];
    titleLabel.text = @"手机号验证";
    titleLabel.textColor = textFontColor;
    titleLabel.font = [UIFont systemFontOfSize:15];
    [self.navigationController.navigationBar addSubview:titleLabel];
    
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
    
    nameTextField = [[UITextField alloc]init];
    nameTextField.frame = CGRectMake(50, 0, 270, 42);
    nameTextField.placeholder = @"请输入短信验证码";
    nameTextField.borderStyle = UITextBorderStyleNone;
    nameTextField.delegate = self;
    [bagImageView addSubview:nameTextField];
    
    UIImageView *nameImage=[[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 20, 20)];
    nameImage.image = [UIImage imageNamed:@"zhanghao"];
    [bagImageView addSubview:nameImage];
    
    passTextField = [[UITextField alloc]init];
    passTextField.frame = CGRectMake(50, 42, 270, 42);
    passTextField.placeholder = @"请输入您的密码";
    passTextField.borderStyle = UITextBorderStyleNone;
    passTextField.secureTextEntry = YES;
    passTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    passTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    passTextField.delegate = self;
    [bagImageView addSubview:passTextField];
    
    UIImageView *passImage = [[UIImageView alloc] initWithFrame:CGRectMake(20, 52, 20, 20)];
    passImage.image = [UIImage imageNamed:@"mima"];
    [bagImageView addSubview:passImage];
    
    UILabel *sanLabel = [[UILabel alloc]initWithFrame:CGRectMake(64, 180, 120, 15)];
    sanLabel.text = @"已将短信验证码发送到";
    sanLabel.font = [UIFont systemFontOfSize:12];
    sanLabel.textColor = [UIColor lightGrayColor];
    [self.view addSubview:sanLabel];
    
    UILabel *telLabel = [[UILabel alloc]initWithFrame:CGRectMake(185, 180, 100, 15)];
    telLabel.text = self.tel;
    telLabel.textColor = [UIColor lightGrayColor];
    telLabel.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:telLabel];
    
    UIButton *registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    registerButton.frame = CGRectMake(15, 200, 140, 44);
    registerButton.tag = 101;
    [registerButton setTitle:@"完成" forState:UIControlStateNormal];
    [registerButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [registerButton setBackgroundColor:[UIColor whiteColor]];
    [registerButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    registerButton.layer.borderColor = textFontColor.CGColor;
    registerButton.layer.borderWidth = 0.2;
    registerButton.layer.cornerRadius = 5.0;
    [self.view addSubview:registerButton];
    
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    loginButton.frame = CGRectMake(165, 200, 140, 44);
    loginButton.tag = 102;
    [loginButton setTitle:@"重新发送" forState:UIControlStateNormal];
    [loginButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [loginButton setBackgroundColor:[UIColor whiteColor]];
    [loginButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    loginButton.layer.borderColor = textFontColor.CGColor;
    loginButton.layer.borderWidth = 0.2;
    loginButton.layer.cornerRadius = 5.0;
    [self.view addSubview:loginButton];


}

#pragma mark - 点击事件
- (void)buttonClick:(UIButton *)button
{
    switch (button.tag) {
        case 100:
            [self dismissViewControllerAnimated:YES completion:nil];
            break;
        case 101: {
            if (passTextField.text.length >= 6 && passTextField.text.length <= 20) {
                [self mobilePhoneRegisteredRequest];
            } else {
                UIAlertView *alert = [[UIAlertView alloc]init];
                alert.title = @"提示";
                alert.message = @"密码为6~20位！";
                [alert addButtonWithTitle:@"确定"];
                alert.delegate = self;
                [alert show];
            }
            
        }
            break;
        case 102: {
            [self requst];
        }
        default:
            break;
    }
}
#pragma mark - 数据
- (void)mobilePhoneRegisteredRequest
{
    NSInteger time = [[NSDate date] timeIntervalSince1970];
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"yyyyMMddHHmm"];
	[formatter setTimeZone:[NSTimeZone localTimeZone]];
	NSString *stringFromDate = [formatter stringFromDate:date];
    NSLog(@"date1:%@",stringFromDate);
    
    NSString *str = @"izhubo_ios";
    NSString *izhuboStr = [NSString stringWithFormat:@"izhubo_%@",stringFromDate];

    NSString *urlStr = [NSString stringWithFormat:@"%@ttus/registerMobile2?user_name=%@&password=%@&qd=%@&nick_name=%@&checkNo=%@",BaseURL,self.tel,passTextField.text,str,izhuboStr,nameTextField.text];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
    request.delegate = self;
    request.tag = 100;
    [request setTimeOutSeconds:100];
    [request startAsynchronous];
}
- (void)requst
{
    NSString *urlStr = [NSString stringWithFormat:@"%@ttus/registerMobile?user_name=%@&auth_code=%@&auth_key=%@",BaseURL,self.tel,self.text,self.auto_key];
    ASIHTTPRequest *request8 = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [request8 setTimeOutSeconds:100];
    
    request8.delegate = self;
    [request8 startAsynchronous];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"hehe == %@",request.responseString);
    id result = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
    if ([result isKindOfClass:[NSDictionary class]]) {
        if (request.tag == 100) {
            int code = [[result objectForKey:@"code"]intValue];
            if (code == 1) {
                UIAlertView *alert = [[UIAlertView alloc]init];
                alert.title = @"提示";
                alert.message = @"注册成功！";
                [alert addButtonWithTitle:@"确定"];
                alert.delegate = self;
                [alert show];
            }else if (code == 31510) {
                NSLog(@"验证码过期");
            } else if (code == 31512) {
                NSLog(@"手机号已被注册");
            }
        } else {
            int code = [[result objectForKey:@"code"]intValue];
            if (code == 1) {
                UIAlertView *alert = [[UIAlertView alloc]init];
                alert.title = @"提示";
                alert.message = @"发送成功！";
                [alert addButtonWithTitle:@"确定"];
                [alert show];
            }
        }
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
@end
