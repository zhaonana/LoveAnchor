//
//  AllModel.h
//  LoveAnchor
//
//  Created by zhongqinglongtu on 14-8-28.
//  Copyright (c) 2014年 zhongqinglongtu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AllModel : NSObject
//房间号
@property (nonatomic, strong) NSNumber     *_id;
//海报
@property (nonatomic, strong) NSString     *pic_url;
//昵称
@property (nonatomic, strong) NSString     *nick_name;
//等级
@property (nonatomic, strong) NSDictionary *finance;

@property (nonatomic, strong) NSString     *auth_key;

@property (nonatomic, strong) NSString     *auth_url;

@property (nonatomic, strong) NSNumber     *visiter_count;

@end
