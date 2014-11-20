//
//  CommonHelp.h
//  LoveAnchor
//
//  Created by NaNa on 14-10-23.
//  Copyright (c) 2014年 zhongqinglongtu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommonHelp : NSObject

/**
 *  获得等级
 *
 *  @param coin   金币数
 *  @param isRich 是否是富豪
 *
 *  @return 等级数
 */
+ (NSInteger)getLevelWithCoin:(NSInteger)coin isRich:(BOOL)isRich;

@end
