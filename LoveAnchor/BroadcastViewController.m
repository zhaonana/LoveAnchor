//
//  BroadcastViewController.m
//  LoveAnchor
//
//  Created by zhongqinglongtu on 14-12-22.
//  Copyright (c) 2014年 zhongqinglongtu. All rights reserved.
//

#import "BroadcastViewController.h"

@interface BroadcastViewController ()<UITextFieldDelegate>

@end

@implementation BroadcastViewController

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
    self.view.backgroundColor = [UIColor colorWithRed:232/255.0 green:241/255.0 blue:243/255.0 alpha:1];
    [self showUI];
}
#pragma mark - UI
- (void)showUI
{
    UIButton *titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    titleButton.frame = CGRectMake(0, 0, 50, 44);
    titleButton.tag = 100;
    titleButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [titleButton setTitle:@"返回" forState:UIControlStateNormal];
    [titleButton setTitleColor:textFontColor forState:UIControlStateNormal];
    [titleButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar addSubview:titleButton];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(130, 0, 60, 44)];
    label.text = @"发广播";
    label.font = [UIFont systemFontOfSize:18];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = textFontColor;
    [self.navigationController.navigationBar addSubview:label];

    for (int i = 0; i < 2; i++) {
        UIImageView *HXImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 74+45*i, kScreenWidth, 0.3)];
        HXImageView.backgroundColor = [UIColor lightGrayColor];
        [self.view addSubview:HXImageView];
    }
    //输入框背景
    UIView *textView = [[UIView alloc]initWithFrame:CGRectMake(0, 75, kScreenWidth, 44)];
    textView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:textView];
    //输入框
    UITextField *broadTextField = [[UITextField alloc]initWithFrame:CGRectMake(5, 0, 290, 44)];
    broadTextField.placeholder = @"请输入广播内容";
    broadTextField.font = [UIFont systemFontOfSize:14];
    broadTextField.delegate = self;
    broadTextField.backgroundColor = [UIColor clearColor];
    broadTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    broadTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [textView addSubview:broadTextField];
    //表情
    UIButton *BQButton = [[UIButton alloc]initWithFrame:CGRectMake(295, 12, 20, 20)];
    [BQButton setImage:[UIImage imageNamed:@"biaoqing"] forState:UIControlStateNormal];
    [BQButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [textView addSubview:BQButton];
    //文字
    
    UILabel *WZLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 130, 160, 15)];
    WZLabel.text = @"每条广播500金币,";
    WZLabel.textColor = [UIColor lightGrayColor];
    WZLabel.font = [UIFont systemFontOfSize:14];
    WZLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:WZLabel];
    
    UILabel *WZLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(5, 145, 160, 15)];
    WZLabel1.text = @"每个房间都可以收到哦~";
    WZLabel1.textColor = [UIColor lightGrayColor];
    WZLabel1.font = [UIFont systemFontOfSize:14];
    WZLabel1.backgroundColor = [UIColor clearColor];
    [self.view addSubview:WZLabel1];
    //发送
    UIButton *FSButton = [[UIButton alloc]initWithFrame:CGRectMake(5, 160, kScreenWidth-10, 44)];
    [FSButton setBackgroundColor:[UIColor lightGrayColor]];
    [FSButton setTitle:@"发送" forState:UIControlStateNormal];
    [FSButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [FSButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:FSButton];
    
}
- (void)buttonClick:(UIButton *)button
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
