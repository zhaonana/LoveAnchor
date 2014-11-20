//
//  TwoTableViewCell.m
//  LoveAnchor
//
//  Created by zhongqinglongtu on 14-10-16.
//  Copyright (c) 2014年 zhongqinglongtu. All rights reserved.
//

#import "TwoTableViewCell.h"

@implementation TwoTableViewCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self shouUI];
    }
    return self;
}

- (void)shouUI
{
    self.label1 = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 100, 15)];
    self.label1.font = [UIFont systemFontOfSize:12];
    self.label1.textColor = [UIColor blackColor];
    [self.contentView addSubview:self.label1];
    
    self.label2 = [[UILabel alloc]initWithFrame:CGRectMake(15, 35, 210, 15)];
    self.label2.font = [UIFont systemFontOfSize:10];
    self.label2.textColor = [UIColor grayColor];
    [self.contentView addSubview:self.label2];
    
    self.image2 = [[UIImageView alloc]initWithFrame:CGRectMake(15, 59, kScreenWidth-30, 0.3)];
    self.image2.backgroundColor = [UIColor lightGrayColor];
    [self.contentView addSubview:self.image2];
    
    self.KGSwitth = [[UISwitch alloc]initWithFrame:CGRectMake(250, 15, 50, 10)];
    [self.KGSwitth addTarget:self action:@selector(switchClick) forControlEvents:UIControlEventValueChanged];
    self.KGSwitth.on = YES;
    [self.contentView addSubview:self.KGSwitth];
}
- (void)switchClick
{
    NSLog(@"123");
}

- (void)awakeFromNib
{
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
