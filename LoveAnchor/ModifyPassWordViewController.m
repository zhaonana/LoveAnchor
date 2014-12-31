//
//  ModifyPassWordViewController.m
//  LoveAnchor
//
//  Created by zhongqinglongtu on 14-12-25.
//  Copyright (c) 2014年 zhongqinglongtu. All rights reserved.
//

#import "ModifyPassWordViewController.h"

@interface ModifyPassWordViewController ()<UITextFieldDelegate,ASIHTTPRequestDelegate,UIAlertViewDelegate>
{
    UITextField     *_nameTextField;
    UITextField     *_passTextField;
    LoginModel      *model;
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
    model = [CommonUtil getUserModel];
}
- (void)createRightView
{
    self.view.backgroundColor = [UIColor colorWithRed:232/255.0 green:241/255.0 blue:243/255.0 alpha:1];
    UILabel *topTitle = [[UILabel alloc]initWithFrame:CGRectMake(120, 0, 80, 44)];
    topTitle.text = @"修改密码";
    topTitle.font = [UIFont systemFontOfSize:18];
    topTitle.backgroundColor = [UIColor clearColor];
    topTitle.textAlignment = NSTextAlignmentCenter;
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
    //输入旧密码
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
    [loginButton setTitle:@"提交" forState:UIControlStateNormal];
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
        if (_nameTextField.text.length >= 6 && _nameTextField.text.length <= 20) {
            if (_passTextField.text.length >= 6 && _passTextField.text.length <= 20) {
                [self request];
            } else {
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"新密码6-20位，请重新输入！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                [alertView show];
            }
            
        } else {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"旧密码6-20位，请重新输入！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alertView show];
        }
        
    }
}
#pragma mark - 数据解析
- (void)request
{
    NSString *oldPassword = [CommonUtil md5:_nameTextField.text];
    NSString *newPassword = [CommonUtil md5:_passTextField.text];
    NSString *url = [NSString stringWithFormat:@"%@user/changePassword/%@?oldPassword=%@&newPassword=%@",BaseURL,model.access_token,oldPassword,newPassword];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    request.delegate = self;
    [request setTimeOutSeconds:100];
    [request startAsynchronous];
    NSLog(@"token == %@",model.access_token);
}
- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"code == %@",request.responseString);
    id result = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
    if ([result isKindOfClass:[NSDictionary class]]) {
        int code = [[result objectForKey:@"code"] intValue];
        if (code == 1) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"密码修改成功！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        } else {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"密码修改失败！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
@end

