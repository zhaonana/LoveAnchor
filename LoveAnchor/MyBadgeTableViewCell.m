//
//  MyBadgeTableViewCell.m
//  LoveAnchor
//
//  Created by zhongqinglongtu on 15-1-4.
//  Copyright (c) 2015年 zhongqinglongtu. All rights reserved.
//

#import "MyBadgeTableViewCell.h"

@implementation MyBadgeTableViewCell

- (void)awakeFromNib
{
    [self loadData];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)loadData
{
    NSString *text = @"naksghfskaefhkslefjlksjflksjdfkdsfkdsjfklsdjfk";
    CGSize size = [CommonUtil getRectWithText:text height:CGFLOAT_MAX width:270.0 font:17.0].size;
    [_contenLab setFrame:CGRectMake(31, 11, size.width, 12)];
}

@end
