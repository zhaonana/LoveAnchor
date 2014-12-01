//
//  HomePageViewController.m
//  LoveAnchor
//
//  Created by zhongqinglongtu on 14-8-11.
//  Copyright (c) 2014年 zhongqinglongtu. All rights reserved.
//

#import "HomePageViewController.h"

@interface HomePageViewController ()
{
    UISwipeGestureRecognizer *leftSwipeGestureRecognizer;
    UISwipeGestureRecognizer *rightSwipeGestureRecognizer;
}
@end

@implementation HomePageViewController

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
    [self.navigationController.navigationBar setTranslucent:NO];
    [self showUI];
}

#pragma mark - 界面
- (void)showUI {
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(10, 8, 30, 30);
    leftButton.tag = 1000;
    [leftButton setImage:[UIImage imageNamed:@"gerenxinxi"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar addSubview:leftButton];
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(280, 8, 30, 30);
    rightButton.tag = 1001;
    [rightButton setImage:[UIImage imageNamed:@"zhibofenlei"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar addSubview:rightButton];
    
    leftSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipes:)];
    rightSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipes:)];
    leftSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    rightSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:leftSwipeGestureRecognizer];
    [self.view addGestureRecognizer:rightSwipeGestureRecognizer];
    
    NSArray *titleArray = @[@"全部直播",@"我关注的"];
    AllViewController *allVC = [[AllViewController alloc]init];
    allVC.home = self;
    AttentionViewController *attentionVC = [[AttentionViewController alloc]init];
    
    [self setViewControllers:@[allVC,attentionVC] titles:titleArray];
    
}

- (void)handleSwipes:(UISwipeGestureRecognizer *)handle
{
    if (handle.direction == UISwipeGestureRecognizerDirectionLeft) {
        [self rightClick];
    }

    if (handle.direction == UISwipeGestureRecognizerDirectionRight) {
        [self leftClick];
    }
}

- (void)buttonClick:(UIButton *)button
{
    NSLog(@"别点了 要着火了");
    if (button.tag == 1000) {
        [self leftClick];
        
    } else {
        [self rightClick];
    }

}

- (void)leftClick {
    if (!_leftisVisible) {
        [[SliderViewController sharedSliderController] leftItemClick];
        _leftisVisible = YES;
    }else{
        [[SliderViewController sharedSliderController]  showContentControllerWithModel:@"TabBarViewController"];
        _leftisVisible = NO;
    }
}

- (void)rightClick {
    if (!_rightisVisible) {
        [[SliderViewController sharedSliderController] rightItemClick];
        _rightisVisible = YES;
    }else {
        [[SliderViewController sharedSliderController] showContentControllerWithModel:@"TabBarViewController"];
        _rightisVisible = NO;
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
