//
//  UserInfoModel.h
//  LoveAnchor
//
//  Created by NaNa on 14/12/16.
//  Copyright (c) 2014年 zhongqinglongtu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfoModel : NSObject

@property (nonatomic, strong) NSNumber     *_id;
@property (nonatomic, strong) NSDictionary *car;
@property (nonatomic, strong) NSDictionary *finance;
@property (nonatomic, strong) NSDictionary *medals;
@property (nonatomic, strong) NSString     *nick_name;
@property (nonatomic, strong) NSString     *pic;
@property (nonatomic, strong) NSNumber     *sex;
@property (nonatomic, strong) NSString     *location;

- (UserInfoModel *)getUserInfoWithDictionary:(NSDictionary *)dic;

@end
