//
//  ChatModel.h
//  LoveAnchor
//
//  Created by NaNa on 14/12/8.
//  Copyright (c) 2014年 zhongqinglongtu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    contentType,
    changeType
} ChatType;

@interface ChatModel : NSObject

@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSNumber *level;
@property (nonatomic, strong) NSString *nick_name;
@property (nonatomic, assign) ChatType chatType;

@end
