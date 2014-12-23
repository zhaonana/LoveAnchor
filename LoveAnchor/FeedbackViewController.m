//
//  FeedbackViewController.m
//  LoveAnchor
//
//  Created by zhongqinglongtu on 14-12-23.
//  Copyright (c) 2014年 zhongqinglongtu. All rights reserved.
//

#import "FeedbackViewController.h"

@interface FeedbackViewController ()

@end

@implementation FeedbackViewController

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
    self.view.backgroundColor = [UIColor whiteColor];
    [self showUI];
}
- (void)showUI
{
    UIButton *returnButton = [UIButton buttonWithType:UIButtonTypeCustom];
    returnButton.frame = CGRectMake(10, 0, 50, 44);
    returnButton.tag = 100;
    [returnButton setTitle:@"返回" forState:UIControlStateNormal];
    [returnButton setTitleColor:textFontColor forState:UIControlStateNormal];
    returnButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [returnButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar addSubview:returnButton];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(120, 0, 80, 44)];
    titleLabel.text = @"意见反馈";
    titleLabel.textColor = textFontColor;
    titleLabel.font = [UIFont systemFontOfSize:18];
    [self.navigationController.navigationBar addSubview:titleLabel];
    
    UIView *textView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight-40, kScreenWidth, 40)];
    [self.view addSubview:textView];
    
    UIImageView *HXimageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.3)];
    HXimageView.backgroundColor = [UIColor lightGrayColor];
    [textView addSubview:HXimageView];
    
    UITextField *textfield = [[UITextField alloc]initWithFrame:CGRectMake(5, 5, 250, 30)];
    textfield.placeholder = @"请填写您的意见，10-400个字符";
    textfield.font = [UIFont systemFontOfSize:12];
    textfield.layer.borderColor = textFontColor.CGColor;
    textfield.layer.borderWidth = 0.3;
    textfield.layer.cornerRadius = 0;
    [textView addSubview:textfield];
    
    UIButton *FSButton = [[UIButton alloc]initWithFrame:CGRectMake(260, 5, 50, 30)];
    [FSButton setTitle:@"发送" forState:UIControlStateNormal];
    [FSButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    FSButton.backgroundColor = textFontColor;
    FSButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [FSButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [textView addSubview:FSButton];
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
