//
//  RankingModel.m
//  LoveAnchor
//
//  Created by zhongqinglongtu on 14-9-1.
//  Copyright (c) 2014年 zhongqinglongtu. All rights reserved.
//

#import "RankingModel.h"

@implementation RankingModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
//    NSLog(@"排行榜没有定义的key = %@",key);
}

- (RankingModel *)getRankModelWithDictionary:(NSDictionary *)dic
{
    self.pic  = [dic objectForKey:@"pic"];
    self.pic_url = [dic objectForKey:@"pic_url"];
    self._id = [dic objectForKey:@"_id"];
    self.nick_name = [dic objectForKey:@"nick_name"];
    self.finance = [dic objectForKey:@"finance"];
    self.bean_count_total = [[dic objectForKey:@"finance"] objectForKey:@"bean_count_total"];
    self.coin_spend_total = [[dic objectForKey:@"finance"] objectForKey:@"coin_spend_total"];
    self.star = [dic objectForKey:@"star"];
    self.coin_spend = [dic objectForKey:@"coin_spend"];
    self.rank = [dic objectForKey:@"rank"];
    self.visiter_count = [dic objectForKey:@"visiter_count"];
    
    return self;
}

@end
