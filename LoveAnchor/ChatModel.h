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

@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSNumber *level;
@property (nonatomic, strong) NSString *nick_name;
@property (nonatomic, strong) NSString *toNick_name;
@property (nonatomic, strong) NSString *giftName;
@property (nonatomic, strong) NSNumber *giftCount;
@property (nonatomic, assign) ChatType chatType;

@end
