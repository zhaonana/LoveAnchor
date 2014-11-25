//
//  DateUtil.m
//  LoveAnchor
//
//  Created by NaNa on 14/11/25.
//  Copyright (c) 2014年 zhongqinglongtu. All rights reserved.
//

#import "DateUtil.h"

@implementation DateUtil

+ (NSString *)getTimeInterval:(NSTimeInterval)time
{
    int distance = time - [[NSDate date] timeIntervalSince1970];
    NSString *string = @"";
    distance = distance / 86400;
    string = [NSString stringWithFormat:@"%d", (distance)];
    return string;
}

@end
