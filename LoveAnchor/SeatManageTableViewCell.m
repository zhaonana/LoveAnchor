//
//  SeatManageTableViewCell.m
//  LoveAnchor
//
//  Created by zhongqinglongtu on 14-11-18.
//  Copyright (c) 2014年 zhongqinglongtu. All rights reserved.
//

#import "SeatManageTableViewCell.h"

@implementation SeatManageTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self showUI];
    }
    return self;
}
#pragma mark - 界面
- (void)showUI
{
        self.iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(30, 10, 75, 40)];
        self.iconImageView.backgroundColor = [UIColor clearColor];
        self.iconImageView.tag = 101;
        [self.contentView addSubview:self.iconImageView];
        
        self.timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 55, 75, 15)];
        self.timeLabel.text = @"有效期:30天";
        self.timeLabel.tag = 102;
        self.timeLabel.font = [UIFont systemFontOfSize:12];
        self.timeLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.timeLabel];
        //禁用
        self.useButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.useButton.frame = CGRectMake(180, 25, 50, 25);
        self.useButton.titleLabel.font = [UIFont systemFontOfSize:12];
        self.useButton.backgroundColor = [UIColor redColor];
        self.useButton.layer.borderColor = textFontColor.CGColor;
        self.useButton.layer.borderWidth = 2.0;
        self.useButton.layer.cornerRadius = 5.0;
        [self.useButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.useButton];
        //续费
        self.continueButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.continueButton.frame = CGRectMake(246, 25, 50, 25);
        self.continueButton.backgroundColor = [UIColor redColor];
        self.continueButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [self.continueButton setTitle:@"续费" forState:UIControlStateNormal];
        self.continueButton.layer.borderColor = textFontColor.CGColor;
        self.continueButton.layer.borderWidth = 2.0;
        self.continueButton.layer.cornerRadius = 5.0;
        self.continueButton.tag = 101;
        [self.continueButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.continueButton];

}

- (void)buttonClick:(UIButton *)button
{
    if (self.UseButtonClickBlock) {
        self.UseButtonClickBlock();
    }
}

- (void)setCellData:(SeatManageModel *)model
{
    UIImageView *imageView = (UIImageView *)[self.contentView viewWithTag:101];
    [imageView setImageWithURL:[NSURL URLWithString:model.pic_url]];
    
    NSString *time = [CommonHelp getTimeInterval:model.time.longLongValue/1000];
    UILabel *timeLabel = (UILabel *)[self.contentView viewWithTag:102];
    timeLabel.text = [NSString stringWithFormat:@"有限期:%@天",time];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
