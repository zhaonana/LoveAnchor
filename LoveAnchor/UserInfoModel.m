//
//  UserInfoModel.m
//  LoveAnchor
//
//  Created by NaNa on 14/12/16.
//  Copyright (c) 2014年 zhongqinglongtu. All rights reserved.
//

#import "UserInfoModel.h"

@implementation UserInfoModel

- (UserInfoModel *)getUserInfoWithDictionary:(NSDictionary *)dic
{
    self._id = [dic objectForKey:@"_id"];
    self.car = [dic objectForKey:@"car"];
    self.finance = [dic objectForKey:@"finance"];
    self.medals = [dic objectForKey:@"medals"];
    self.nick_name = [dic objectForKey:@"nick_name"];
    self.pic = [dic objectForKey:@"pic"];
    self.sex = [dic objectForKey:@"sex"];
    self.location = [dic objectForKey:@"location"];

    return self;
}

@end
