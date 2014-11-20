//
//  AllModel.m
//  LoveAnchor
//
//  Created by zhongqinglongtu on 14-8-28.
//  Copyright (c) 2014年 zhongqinglongtu. All rights reserved.
//

#import "AllModel.h"

@implementation AllModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    NSLog(@"没有定义的key == %@",key);
}
@end
