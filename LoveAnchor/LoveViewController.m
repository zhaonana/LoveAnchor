//
//  LoveViewController.m
//  LoveAnchor
//
//  Created by zhongqinglongtu on 14-12-26.
//  Copyright (c) 2014年 zhongqinglongtu. All rights reserved.
//

#import "LoveViewController.h"

@interface LoveViewController ()
@property (weak, nonatomic) IBOutlet UILabel *versonLabel;

@end

@implementation LoveViewController

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
    [self showUI];
}

- (void)showUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    UILabel *topTitle = [[UILabel alloc]initWithFrame:CGRectMake(140, 0, 40, 44)];
    topTitle.text = @"设置";
    topTitle.font = [UIFont systemFontOfSize:18];
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
}

- (IBAction)buttonClick:(UIButton *)sender {
    if (sender.tag == 100) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
