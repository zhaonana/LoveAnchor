//
//  RetrieveViewController.m
//  LoveAnchor
//
//  Created by zhongqinglongtu on 15-1-14.
//  Copyright (c) 2015年 zhongqinglongtu. All rights reserved.
//

#import "RetrieveViewController.h"

@interface RetrieveViewController ()<UITextFieldDelegate,ASIHTTPRequestDelegate,UIAlertViewDelegate>
{
    UITextField *nameTextField;
    UITextField *passTextField;
    LoginModel  *model;
}

@end

@implementation RetrieveViewController

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
    model = [CommonUtil getUserModel];
    [self showUI];
}
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
    passTextField.placeholder = @"请输入您要设置的密码";
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
- (void)buttonClick:(UIButton *)button
{
    if (button.tag == 100) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else if (button.tag == 101) {
        [self request];
    }
}
#pragma mark - 数据解析
- (void)request
{
    NSString *newPass = [CommonUtil md5:passTextField.text];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@public/resetPw?checkNo=%@&pw=%@",BaseURL,nameTextField.text,newPass];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
    request.delegate = self;
    [request startAsynchronous];
    [request setTimeOutSeconds:100];
    NSLog(@"pass = %@",newPass);
}


- (void)requestFinished:(ASIHTTPRequest *)request
{
    id result = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
    if ([result isKindOfClass:[NSDictionary class]]) {
        int code = [[result objectForKey:@"code"]intValue];
        if (code == 1) {
            UIAlertView *alert = [[UIAlertView alloc]init];
            alert.title = @"提示";
            alert.message = @"密码修改成功！";
            [alert addButtonWithTitle:@"确定"];
            alert.delegate = self;
            [alert show];

        } else if (code == 31510) {
            UIAlertView *alert = [[UIAlertView alloc]init];
            alert.title = @"提示";
            alert.message = @"验证码输入错误！";
            [alert addButtonWithTitle:@"确定"];
            [alert show];
        } else if (code == 31508) {
            UIAlertView *alert = [[UIAlertView alloc]init];
            alert.title = @"提示";
            alert.message = @"修改密码失败！";
            [alert addButtonWithTitle:@"确定"];
            [alert show];
        }
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
@end
