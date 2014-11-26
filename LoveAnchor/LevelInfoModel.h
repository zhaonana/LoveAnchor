//
//  LevelInfoModel.h
//  LoveAnchor
//
//  Created by NaNa on 14/11/26.
//  Copyright (c) 2014年 zhongqinglongtu. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  等级model
 */
@interface LevelInfoModel : NSObject

/**
 *  等级数
 */
@property (nonatomic, assign) NSInteger level;
/**
 *  距下一等级还差几个金币
 */
@property (nonatomic, assign) NSInteger nextCoin;

@end
