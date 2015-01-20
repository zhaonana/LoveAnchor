//
//  VerifyViewController.h
//  LoveAnchor
//
//  Created by zhongqinglongtu on 14-10-10.
//  Copyright (c) 2014年 zhongqinglongtu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VerifyViewController : UIViewController<UITextFieldDelegate>

@property (nonatomic, strong)NSString *tel;
@property (nonatomic, strong)NSString *text;
@property (nonatomic, strong)NSString *auto_key;

@end
