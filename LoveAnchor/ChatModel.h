//
//  ChatModel.h
//  LoveAnchor
//
//  Created by NaNa on 14/12/8.
//  Copyright (c) 2014年 zhongqinglongtu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    contentType,    //聊天消息
    changeType,     //进入房间提示
    giftType,       //送礼物消息
    featherType,    //送主播羽毛
    tellTAType,     //对TA说
} ChatType;

@interface ChatModel : NSObject
//聊天内容
@property (nonatomic, strong) NSString *content;
//财富等级
@property (nonatomic, strong) NSNumber *level;
//昵称
@property (nonatomic, strong) NSString *nick_name;
@property (nonatomic, strong) NSNumber *_id;
//对方昵称
@property (nonatomic, strong) NSString *toNick_name;
@property (nonatomic, strong) NSNumber *to_id;
//礼物名称
@property (nonatomic, strong) NSString *giftName;
//礼物数量
@property (nonatomic, strong) NSNumber *giftCount;
//聊天类型
@property (nonatomic, assign) ChatType chatType;

@end
