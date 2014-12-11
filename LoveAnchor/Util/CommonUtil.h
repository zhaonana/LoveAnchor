//
//  CommonUtil.h
//  LoveAnchor
//
//  Created by NaNa on 14/11/25.
//  Copyright (c) 2014年 zhongqinglongtu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LevelInfoModel.h"

@interface CommonUtil : NSObject

/**
 *  根据时间戳计算天数
 *
 *  @param time 时间戳
 *
 *  @return 天数
 */
+ (NSString *)getTimeInterval:(NSTimeInterval)time;
/**
 *  根据金币数计算等级
 *
 *  @param coin   金币数
 *  @param isRich 是否是富豪
 *
 *  @return 等级model
 */
+ (LevelInfoModel *)getLevelInfoWithCoin:(NSInteger)coin isRich:(BOOL)isRich;
/**
 *  判断是否已经登录
 *
 *  @return 是否登录
 */
+ (BOOL)isLogin;
/**
 *  退出登录
 */
+ (void)logout;
/**
 *  获得用户信息model
 *
 *  @return 用户信息model
 */
+ (LoginModel *)getUserModel;
/**
 *  存储用户信息
 *
 *  @param loginModel 用户信息model
 */
+ (void)saveUserModel:(LoginModel *)loginModel;

@end