//
//  KPSegmentedViewController.m
//  KPKuaiPai
//
//  Created by Johnny iDay on 13-12-14.
//  Copyright (c) 2013年 Johnny iDay. All rights reserved.
//

#import "XDSSegmentedViewController.h"

@interface XDSSegmentedViewController ()

@end

@implementation XDSSegmentedViewController

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
	// Do any additional setup after loading the view.
    
    if (!_segmentedControl) {
         NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:textFontColor,UITextAttributeTextColor,[UIFont fontWithName:@"Micrsoft Yahei"size:15],UITextAttributeFont ,nil];
        _segmentedControl = [[UISegmentedControl alloc] init];
        _segmentedControl.tintColor = [UIColor colorWithRed:228/255.0 green:105/255.0 blue:80/255.0 alpha:1];
        _segmentedControl.frame = CGRectMake(10, 8, 150, 40);
        [_segmentedControl setTitleTextAttributes:dic forState:UIControlStateNormal];
        self.navigationItem.titleView = _segmentedControl;
    } else {
        [_segmentedControl removeAllSegments];
    }
    [_segmentedControl addTarget:self action:@selector(segmentedControlSelected:) forControlEvents:UIControlEventValueChanged];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)setViewControllers:(NSArray *)viewControllers titles:(NSArray *)titles
{
    if ([_segmentedControl numberOfSegments] > 0) {
        return;
    }
    for (int i = 0; i < [viewControllers count]; i++) {
        [self pushViewController:viewControllers[i] title:titles[i]];
    }
    [_segmentedControl setSelectedSegmentIndex:0];
    self.selectedViewControllerIndex = 0;
}

- (void)setViewControllers:(NSArray *)viewControllers
{
    if ([_segmentedControl numberOfSegments] > 0) {
        return;
    }
    for (int i = 0; i < [viewControllers count]; i++) {
        [self pushViewController:viewControllers[i] title:[viewControllers[i] title]];//按顺序  把视图控制器加到自己的子视图控制器
    }
    [_segmentedControl setSelectedSegmentIndex:0];
    self.selectedViewControllerIndex = 0;
}

- (void)pushViewController:(UIViewController *)viewController
{
    [self pushViewController:viewController title:viewController.title];
}
- (void)pushViewController:(UIViewController *)viewController title:(NSString *)title
{
    [_segmentedControl insertSegmentWithTitle:title atIndex:_segmentedControl.numberOfSegments animated:NO];//插入一个按键
    [self addChildViewController:viewController];//视图控制器添加一个子视图控制器
    [_segmentedControl sizeToFit];
}

- (void)segmentedControlSelected:(id)sender
{
    if ([CommonUtil isLogin]) {
        self.selectedViewControllerIndex = _segmentedControl.selectedSegmentIndex;
    } else {
        [CommonUtil loginAlertViewShow:self];
        _segmentedControl.selectedSegmentIndex = 0;
    }
}

#pragma mark - UIAlertViewDelegate methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            break;
        case 1: {
            LoginViewController *loginViewController = [[LoginViewController alloc] init];
            loginViewController.controllerType = livehallType;
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:loginViewController];
            [self presentViewController:navigationController animated:YES completion:^{
                
            }];
        }
            break;
        default:
            break;
    }
}

- (void)setSelectedViewControllerIndex:(NSInteger)index
{
    if (!_selectedViewController) {
        _selectedViewController = self.childViewControllers[index];//从子视图控制器中选择  当前选中的视图
        if ([[UIDevice currentDevice].systemVersion floatValue] < 7.0f) {
            CGFloat deltaTop = 20.0f;
            if (self.navigationController && !self.navigationController.navigationBar.translucent) {//判断是否有导航栏且导航栏是否透明
                deltaTop = self.navigationController.navigationBar.frame.size.height;
            }
            //调整视图的尺寸
            CGRect frame = self.view.frame;
            [_selectedViewController view].frame = CGRectMake(frame.origin.x, frame.origin.y - deltaTop, frame.size.width, frame.size.height);
            [[_selectedViewController view] sizeToFit];
        } else {
            [_selectedViewController view].frame = self.view.frame;
        }
        [self.view addSubview:[_selectedViewController view]];
        [_selectedViewController didMoveToParentViewController:self];
    } else {
        if ([[UIDevice currentDevice].systemVersion floatValue] < 7.0f) {
            [self.childViewControllers[index] view].frame = self.view.frame;
        }
        [self transitionFromViewController:_selectedViewController toViewController:self.childViewControllers[index] duration:0.0f options:UIViewAnimationOptionTransitionNone animations:nil completion:^(BOOL finished) {
            _selectedViewController = self.childViewControllers[index];
            _selectedViewControllerIndex = index;
        }];
    }
}

@end
