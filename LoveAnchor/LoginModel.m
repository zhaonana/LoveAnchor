//
//  LoginModel.m
//  LoveAnchor
//
//  Created by zhongqinglongtu on 14-10-29.
//  Copyright (c) 2014年 zhongqinglongtu. All rights reserved.
//

#import "LoginModel.h"

@implementation LoginModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
//    NSLog(@"搜索没有定义的key = %@",key);
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.userName forKey:@"userName"];
    [aCoder encodeObject:self.access_token forKey:@"access_token"];
    [aCoder encodeObject:self.finance forKey:@"finance"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.userName = [aDecoder decodeObjectForKey:@"userName"];
    self.access_token = [aDecoder decodeObjectForKey:@"access_token"];
    self.finance = [aDecoder decodeObjectForKey:@"finance"];
    return self;
}
@end
