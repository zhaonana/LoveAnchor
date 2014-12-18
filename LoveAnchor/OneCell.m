//
//  OneCell.m
//  LoveAnchor
//
//  Created by zhongqinglongtu on 14-10-18.
//  Copyright (c) 2014年 zhongqinglongtu. All rights reserved.
//

#import "OneCell.h"
#import "UIImageView+BoundsAdditions.h"

@implementation OneCell

- (id)init
{
    self = [super init];
    if (self) {
        [self showUI];
    }
    return self;
}

- (void)showUI
{
    self.headImage = [[UIImageView alloc] initWithFrame:CGRectMake(5, 7, 40, 40)];
    [self.headImage makeBoundImage];
    [self.contentView addSubview:self.headImage];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(52, 10, 250, 10)];
    self.titleLabel.font = [UIFont systemFontOfSize:10];
    [self.contentView addSubview:self.titleLabel];
    
    self.IDLabel = [[UILabel alloc]initWithFrame:CGRectMake(52, 22, 100, 10)];
    self.IDLabel.font = [UIFont systemFontOfSize:10];
    [self.contentView addSubview:self.IDLabel];
    
    self.HGimageView = [[UIImageView alloc]initWithFrame:CGRectMake(52, 33, 16, 16)];
    [self.contentView addSubview:self.HGimageView];
    
    self.DJimageView = [[UIImageView alloc]initWithFrame:CGRectMake(80, 36, 25, 12)];
    [self.contentView addSubview:self.DJimageView];
}

- (void)loadDataWithModel:(UserInfoModel *)userModel
{
    if (userModel.pic.length) {
        [_headImage setImageWithURL:[NSURL URLWithString:userModel.pic]];
    }
    if (userModel.nick_name.length) {
        [_titleLabel setText:userModel.nick_name];
    }
    if (userModel._id) {
        [_IDLabel setText:userModel._id.stringValue];
    }
    if (userModel.finance) {
        NSInteger coin = [[userModel.finance objectForKey:@"bean_count_total"] intValue];
        NSInteger level = [CommonUtil getLevelInfoWithCoin:coin isRich:NO].level;
        NSString *imageName = [NSString stringWithFormat:@"%dzhubo",level];
        [_HGimageView setImage:[UIImage imageNamed:imageName]];
        
        NSInteger richCoin = [[userModel.finance objectForKey:@"coin_spend_total"] intValue];
        NSInteger richLevel = [CommonUtil getLevelInfoWithCoin:richCoin isRich:YES].level;
        NSString *richImage = [NSString stringWithFormat:@"%dfu",richLevel];
        [_DJimageView setImage:[UIImage imageNamed:richImage]];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
