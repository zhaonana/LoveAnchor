//
//  ModificationViewController.m
//  LoveAnchor
//
//  Created by zhongqinglongtu on 14-11-3.
//  Copyright (c) 2014年 zhongqinglongtu. All rights reserved.
//

#import "ModificationViewController.h"


@interface ModificationViewController ()<UIAlertViewDelegate,UITextFieldDelegate>
{
    UITextField *_modificationTextField;
    LoginModel *model;
    UIButton *QDButton;
}

@end

@implementation ModificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    model = [CommonUtil getUserModel];
    
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
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(123, 0, 75, 44)];
    label.text = @"修改昵称";
    label.font = [UIFont systemFontOfSize:18];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = textFontColor;
    [self.navigationController.navigationBar addSubview:label];
    
    UIView *leftInputView = [[UIView alloc]initWithFrame:CGRectMake(0, 72, kScreenWidth, 44)];
    leftInputView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:leftInputView];
    
    UIImageView *hengxianImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5)];
    hengxianImage.backgroundColor = [UIColor lightGrayColor];
    [leftInputView addSubview:hengxianImage];
    
    UIImageView *diHengxianImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 44, kScreenWidth, 0.5)];
    diHengxianImage.backgroundColor = [UIColor lightGrayColor];
    [leftInputView addSubview:diHengxianImage];
    
    _modificationTextField = [[UITextField alloc]initWithFrame:CGRectMake(15, 0, kScreenWidth-30, 44)];
    _modificationTextField.placeholder = @"请输入修改后的昵称";
    _modificationTextField.delegate = self;
    [_modificationTextField addTarget:self action:@selector(textFieldClick:) forControlEvents:UIControlEventEditingChanged];
    [_modificationTextField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    _modificationTextField.font = [UIFont systemFontOfSize:15];
    _modificationTextField.borderStyle = UITextBorderStyleNone;
    _modificationTextField.clearButtonMode = UITextFieldViewModeAlways;
    _modificationTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    _modificationTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [leftInputView addSubview:_modificationTextField];
    
    UILabel *promptLabel = [[UILabel alloc]initWithFrame:CGRectMake(18, 121, 170, 13)];
    promptLabel.text = @"好昵称可以让主播更容易记住你";
    promptLabel.font = [UIFont systemFontOfSize:12];
    promptLabel.textColor = [UIColor lightGrayColor];
    [self.view addSubview:promptLabel];
    
    QDButton = [UIButton buttonWithType:UIButtonTypeCustom];
    QDButton.frame = CGRectMake(15, 139, 290, 42);
    [QDButton setTitle:@"确定" forState:UIControlStateNormal];
    [QDButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [QDButton setBackgroundColor:[UIColor colorWithRed:207/255.0 green:207/255.0 blue:207/255.0 alpha:1]];
    //218 76 51
    [QDButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:QDButton];
}

#pragma mark - 点击事件
- (void)buttonClick:(UIButton *)button
{
    if (button.tag == 100) {
        NSLog(@"回不去了，怎么办呢");
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        NSLog(@"真改啊");
        if (button.selected) {
            [QDButton setBackgroundColor:[UIColor colorWithRed:218/255.0 green:76/255.0 blue:51/255.0 alpha:1]];
        } else {
            [QDButton setBackgroundColor:textFontColor];
        }
        if ((_modificationTextField.text.length <= 18) && (_modificationTextField.text.length >= 2)) {
            [self nickRequest];
        }else{
            UIAlertView *alert = [[UIAlertView alloc]init];
            alert.title = @"修改失败";
            alert.message = @"昵称长度为2-18位，请重新输入";
            [alert addButtonWithTitle:@"确定"];
            alert.delegate = self;
            [alert show];
        }
    }
}

#pragma mark - 修改昵称
- (void)nickRequest
{
    NSString *urlStr = [NSString stringWithFormat:@"%@user/edit/%@",BaseURL,model.access_token];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlStr]];
    request.delegate = self;
    NSString *str = [NSString stringWithFormat:@"%@",_modificationTextField.text];
    [request setPostValue:str forKey:@"nick_name"];
    [request startAsynchronous];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"昵称 == %@",request.responseString);
    id result = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
    if ([result isKindOfClass:[NSDictionary class]]) {
        int code = [[result objectForKey:@"code"] intValue];
        NSLog(@"code == %d",code);
        if (code == 1) {
            UIAlertView *alert = [[UIAlertView alloc]init];
            alert.title = @"修改昵称提示";
            alert.message = @"修改成功";
            [alert addButtonWithTitle:@"确定"];
            alert.tag = 100;
            alert.delegate = self;
            [alert show];
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 100 && buttonIndex == 0) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}
- (void)textFieldClick:(UITextField *)field
{
    if (_modificationTextField.text.length > 0) {
        [QDButton setBackgroundColor:textFontColor];
    }else {
        [QDButton setBackgroundColor:[UIColor lightGrayColor]];
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
