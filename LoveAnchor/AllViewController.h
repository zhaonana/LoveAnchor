//
//  AllViewController.h
//  LoveAnchor
//
//  Created by zhongqinglongtu on 14-8-11.
//  Copyright (c) 2014年 zhongqinglongtu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHttpRequest.h"
#import "HomePageViewController.h"
@interface AllViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,ASIHTTPRequestDelegate>

@property (nonatomic,strong) HomePageViewController *home;

@end
