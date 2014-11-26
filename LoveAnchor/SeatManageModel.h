//
//  SeatManageModel.h
//  LoveAnchor
//
//  Created by zhongqinglongtu on 14-11-19.
//  Copyright (c) 2014年 zhongqinglongtu. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  座驾model
 */
@interface SeatManageModel : NSObject

/**
 *  座驾图片url
 */
@property (nonatomic, strong) NSString *pic_url;
/**
 *  座驾id
 */
@property (nonatomic, strong) NSNumber *_id;
/**
 *  座驾有效期
 */
@property (nonatomic, strong) NSString *time;
/**
 *  座驾价格
 */
@property (nonatomic, strong) NSNumber *coin_price;
/**
 *  座驾名称
 */
@property (nonatomic, strong) NSString *name;

@end
