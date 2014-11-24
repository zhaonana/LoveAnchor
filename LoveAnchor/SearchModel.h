//
//  SearchModel.h
//  LoveAnchor
//
//  Created by zhongqinglongtu on 14-9-11.
//  Copyright (c) 2014年 zhongqinglongtu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchModel : NSObject
//头像
@property (nonatomic, strong) NSString     *pic_url;
//房间号
@property (nonatomic, strong) NSNumber     *_id;
//等级
@property (nonatomic, strong) NSDictionary *finance;
@property (nonatomic, strong) NSNumber     *bean_count_total;
//昵称
@property (nonatomic, strong) NSString     *nick_name;

@end
