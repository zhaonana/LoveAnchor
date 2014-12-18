//
//  BadgeModel.h
//  LoveAnchor
//
//  Created by zhongqinglongtu on 14-11-14.
//  Copyright (c) 2014年 zhongqinglongtu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BadgeModel : NSObject

@property (nonatomic,strong) NSNumber *ID;
@property (nonatomic,strong) NSString *grey_pic;
@property (nonatomic,strong) NSString *pic_url;

- (BadgeModel *)getBadgeModelWithDictionary:(NSDictionary *)dic;

@end
