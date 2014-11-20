//
//  LoginModel.h
//  LoveAnchor
//
//  Created by zhongqinglongtu on 14-10-29.
//  Copyright (c) 2014年 zhongqinglongtu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginModel : NSObject <NSCoding>

@property (nonatomic, strong)NSString *access_token;

@property (nonatomic, strong)NSString *userName;

@property (nonatomic, strong)NSString *passWord;

@end
