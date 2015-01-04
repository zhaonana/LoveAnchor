//
//  HelpViewController.m
//  LoveAnchor
//
//  Created by zhongqinglongtu on 14-12-31.
//  Copyright (c) 2014年 zhongqinglongtu. All rights reserved.
//

#import "HelpViewController.h"

@interface HelpViewController ()

@end

@implementation HelpViewController

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
    
    UILabel *topTitle = [[UILabel alloc]initWithFrame:CGRectMake(120, 0, 80, 44)];
    topTitle.text = @"使用帮助";
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
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [self.view addSubview:webView];
    //获取文件路径
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"index" ofType:@"html"];
    NSURL *url = [NSURL fileURLWithPath:filePath];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
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
