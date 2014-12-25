//
//  LoginViewController.h
//  LoveAnchor
//
//  Created by zhongqinglongtu on 14-9-16.
//  Copyright (c) 2014年 zhongqinglongtu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    registerType,   //注册
    leftmenuType,   //左菜单
    livehallType,   //直播大厅
    dynamicType,    //历史观看
    playType,       //直播间
    rankingType,    //排行榜
} PresentControllerType;

@interface LoginViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, assign) PresentControllerType controllerType;

@end
