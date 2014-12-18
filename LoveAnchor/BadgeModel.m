//
//  BadgeModel.m
//  LoveAnchor
//
//  Created by zhongqinglongtu on 14-11-14.
//  Copyright (c) 2014年 zhongqinglongtu. All rights reserved.
//

#import "BadgeModel.h"

@implementation BadgeModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
//    NSLog(@"搜索没有定义的key = %@",key);
}

- (BadgeModel *)getBadgeModelWithDictionary:(NSDictionary *)dic
{
    self.ID = [dic objectForKey:@"_id"];
    self.grey_pic = [dic objectForKey:@"grey_pic"];
    self.pic_url = [dic objectForKey:@"pic_url"];
    
    return self;
}

@end
