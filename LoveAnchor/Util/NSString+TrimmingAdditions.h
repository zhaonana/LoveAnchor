//
//  NSString+TrimmingAdditions.h
//  MyDemo
//
//  Created by NaNa on 14/12/10.
//  Copyright (c) 2014年 ___nn___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (TrimmingAdditions)

//去掉字符串最左边空格
- (NSString *)stringByTrimmingLeftCharactersInSet:(NSCharacterSet *)characterSet;
//去掉字符串最右边空格
- (NSString *)stringByTrimmingRightCharactersInSet:(NSCharacterSet *)characterSet;

@end
