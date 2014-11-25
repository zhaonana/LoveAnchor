//
//  DateUtil.h
//  LoveAnchor
//
//  Created by NaNa on 14/11/25.
//  Copyright (c) 2014年 zhongqinglongtu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateUtil : NSObject

+ (NSString *)getTimeInterval:(NSTimeInterval)time;

+ (NSString *)getLevelImageNameWithCoin:(NSInteger)coin isRich:(BOOL)isRich;

@end
