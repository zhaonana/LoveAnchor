//
//  SecondRowTableViewCell.m
//  LoveAnchor
//
//  Created by zhongqinglongtu on 14-8-22.
//  Copyright (c) 2014年 zhongqinglongtu. All rights reserved.
//

#import "SecondRowTableViewCell.h"
#import "AllModel.h"
#import "UIImageView+WebCache.h"
@implementation SecondRowTableViewCell

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
    for (int i = 0; i < 2; i++) {
        UIImageView *imageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(0+i*161, 0, 159, 120)];
        imageView1.backgroundColor = [UIColor purpleColor];
        //imageView1.image = [UIImage imageNamed:@"36387_1393222176K1R0"];
        imageView1.tag = 10+i;
        imageView1.userInteractionEnabled = YES;
        [self.contentView addSubview:imageView1];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(secondTapClick:)];
        [imageView1 addGestureRecognizer:tap];
        
        UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 90, 110, 15)];
        nameLabel.text = @"斯嘉丽约翰逊";
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.font = [UIFont systemFontOfSize:11.0f];
        nameLabel.textColor = [UIColor whiteColor];
        nameLabel.tag = 100+i;
        [nameLabel setShadowColor:[UIColor blackColor]];
        [nameLabel setShadowOffset:CGSizeMake(1, 1)];
        [imageView1 addSubview:nameLabel];
        
        UIImageView *numberImageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 105, 15, 15)];
        numberImageView.image = [UIImage imageNamed:@"renshu"];
        numberImageView.backgroundColor = [UIColor clearColor];
        [imageView1 addSubview:numberImageView];
        
        UILabel *numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(25, 105, 130, 16)];
        numberLabel.text = @"8888";
        numberLabel.textColor = [UIColor whiteColor];
        numberLabel.font = [UIFont systemFontOfSize:12.0f];
        numberLabel.backgroundColor = [UIColor clearColor];
        numberLabel.tag = 1000+i;
        [numberLabel setShadowColor:[UIColor blackColor]];
        [numberLabel setShadowOffset:CGSizeMake(1, 1)];
        [imageView1 addSubview:numberLabel];
    }
}

- (void)setCellData:(NSArray *)modelArray
{
    _modelArray = modelArray;
    for (int i = 0; i < [modelArray count]; i++) {
        AllModel *model = [modelArray objectAtIndex:i];
        UIImageView *imageView = (UIImageView *)[self.contentView viewWithTag:10+i];
        [imageView setImageWithURL:[NSURL URLWithString:model.pic_url]];
        
        UILabel *nameLabel = (UILabel *)[self.contentView viewWithTag:100+i];
        nameLabel.text = [NSString stringWithFormat:@"%@",model.nick_name];
        
        UILabel *numberLabel = (UILabel *)[self.contentView viewWithTag:1000+i];
        numberLabel.text = [NSString stringWithFormat:@"%@",model._id];
    }
}
- (void)secondTapClick:(UITapGestureRecognizer *)sender
{
    NSInteger tag = sender.view.tag;
    AllModel *model = _modelArray[tag-10];
    [self.delegate secondClick:model];
}
- (void)awakeFromNib
{
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
