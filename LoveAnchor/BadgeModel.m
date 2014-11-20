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
    NSLog(@"搜索没有定义的key = %@",key);
}
@end
