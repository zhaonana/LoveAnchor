//
//  PlayViewController.h
//  LoveAnchor
//
//  Created by zhongqinglongtu on 14-9-18.
//  Copyright (c) 2014年 zhongqinglongtu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AllModel.h"

@interface PlayViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)NSString *roomID;

@property (nonatomic,strong) AllModel *allModel;

@end
