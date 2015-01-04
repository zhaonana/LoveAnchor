//
//  LoveViewController.m
//  LoveAnchor
//
//  Created by zhongqinglongtu on 14-12-26.
//  Copyright (c) 2014年 zhongqinglongtu. All rights reserved.
//

#import "LoveViewController.h"

@interface LoveViewController ()<ASIHTTPRequestDelegate>
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
    UILabel *topTitle = [[UILabel alloc]initWithFrame:CGRectMake(130, 0, 60, 44)];
    topTitle.text = @"爱主播";
    topTitle.font = [UIFont systemFontOfSize:18];
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
}

- (IBAction)buttonClick:(UIButton *)sender {
    if (sender.tag == 100) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else if (sender.tag == 101) {
        FeedbackViewController *feed = [[FeedbackViewController alloc]init];
        UINavigationController *nc = [[UINavigationController alloc]initWithRootViewController:feed];
        [self presentViewController:nc animated:YES completion:nil];
        
    } else if (sender.tag == 102) {
        HelpViewController *help = [[HelpViewController alloc]init];
        UINavigationController *nc = [[UINavigationController alloc]initWithRootViewController:help];
        [self presentViewController:nc animated:YES completion:nil];
        
    } else if (sender.tag == 103) {
        [self request];
    }
}
- (void)request
{
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@sys/show_download2ios_info",BaseURL]]];
    request.delegate = self;
    [request setTimeOutSeconds:100];
    [request startAsynchronous];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"requse == %@",request.responseString);
    
    id result = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
    if ([result isKindOfClass:[NSDictionary class]]) {
        int code = [[result objectForKey:@"code"] intValue];
        if (code == 1) {
            
        }else if (code == 30405) {
            
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
