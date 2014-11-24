//
//  RankingModel.h
//  LoveAnchor
//
//  Created by zhongqinglongtu on 14-9-1.
//  Copyright (c) 2014年 zhongqinglongtu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RankingModel : NSObject
//头像
@property (nonatomic, strong)NSString *pic;
//ID
@property (nonatomic, strong)NSNumber *_id;
//昵称
@property (nonatomic, strong)NSString *nick_name;
//主播等级
@property (nonatomic, strong)NSNumber *finance;
//房间号
@property (nonatomic, strong)NSString *star;
@end
