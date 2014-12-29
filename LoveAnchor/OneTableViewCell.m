//
//  OneTableViewCell.m
//  LoveAnchor
//
//  Created by zhongqinglongtu on 14-10-16.
//  Copyright (c) 2014年 zhongqinglongtu. All rights reserved.
//

#import "OneTableViewCell.h"

@implementation OneTableViewCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.label3 = [[UILabel alloc]initWithFrame:CGRectMake(15, 18, 100, 12)];
        self.label3.font = [UIFont systemFontOfSize:10];
        self.label3.textColor = [UIColor grayColor];
        [self.contentView addSubview:self.label3];
        
        self.image3 = [[UIImageView alloc]initWithFrame:CGRectMake(15, 39, kScreenWidth-30, 0.3)];
        self.image3.backgroundColor = [UIColor lightGrayColor];
        [self.contentView addSubview:self.image3];
        
        self.KGSwitch = [[UISwitch alloc]initWithFrame:CGRectMake(250, 5, 50, 10)];
        self.KGSwitch.hidden = YES;
        [self.KGSwitch addTarget:self action:@selector(switchClick:) forControlEvents:UIControlEventValueChanged];
        [self.contentView addSubview:self.KGSwitch];
    }
    return self;
}
- (void)switchClick:(UISwitch *)sender
{
    if (self.switchClick) {
        self.switchClick (sender.on);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
