//
//  PlayViewController.h
//  LoveAnchor
//
//  Created by zhongqinglongtu on 14-9-18.
//  Copyright (c) 2014年 zhongqinglongtu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RankingModel.h"
#import "Vitamio.h"

@interface PlayViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) RankingModel *allModel;

@end
