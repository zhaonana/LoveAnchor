//
//  RegisterModel.m
//  LoveAnchor
//
//  Created by zhongqinglongtu on 14-10-28.
//  Copyright (c) 2014年 zhongqinglongtu. All rights reserved.
//

#import "RegisterModel.h"

@implementation RegisterModel 
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
//    NSLog(@"搜索没有定义的key = %@",key);
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.userName forKey:@"userName"];
    [aCoder encodeObject:self.passWord forKey:@"passWord"];
    
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.passWord = [aDecoder decodeObjectForKey:@"passWord"];
    self.userName = [aDecoder decodeObjectForKey:@"userName"];
    return self;
}
@end
