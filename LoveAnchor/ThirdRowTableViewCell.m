//
//  ThirdRowTableViewCell.m
//  LoveAnchor
//
//  Created by zhongqinglongtu on 14-8-22.
//  Copyright (c) 2014年 zhongqinglongtu. All rights reserved.
//

#import "ThirdRowTableViewCell.h"
#import "AllModel.h"
#import "UIImageView+WebCache.h"

@implementation ThirdRowTableViewCell

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
    for (int i = 0; i < 3; i++) {
        UIImageView *imageView2 = [[UIImageView alloc]initWithFrame:CGRectMake(0+i*107, 0, 105, 81)];
        imageView2.backgroundColor = [UIColor clearColor];
        //imageView2.image = [UIImage imageNamed:@"36387_1393222176K1R0"];
        imageView2.userInteractionEnabled = YES;
        imageView2.tag = 10 + i;
        [self.contentView addSubview:imageView2];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(thirdTapClick:)];
        [imageView2 addGestureRecognizer:tap];
        
        UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 48, 85, 15)];
//        nameLabel.text = @"斯嘉丽约翰逊";
        [nameLabel setShadowColor:[UIColor blackColor]];
        [nameLabel setShadowOffset:CGSizeMake(1, 1)];
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.font = [UIFont systemFontOfSize:11.0f];
        nameLabel.textColor = [UIColor whiteColor];
        nameLabel.tag = 100 + i;
        [imageView2 addSubview:nameLabel];
        
        UIImageView *numberImageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 60, 16, 16)];
        numberImageView.image = [UIImage imageNamed:@"renshu"];
        numberImageView.backgroundColor = [UIColor clearColor];
        [imageView2 addSubview:numberImageView];
        
        UILabel *numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 60, 60, 16)];
//        numberLabel.text = @"8888";
        numberLabel.backgroundColor = [UIColor clearColor];
        numberLabel.textColor = [UIColor whiteColor];
        numberLabel.font = [UIFont systemFontOfSize:12.0f];
        numberLabel.tag = 1000 + i;
        [numberLabel setShadowColor:[UIColor blackColor]];
        [numberLabel setShadowOffset:CGSizeMake(1, 1)];
        [imageView2 addSubview:numberLabel];
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

- (void)thirdTapClick:(UIGestureRecognizer *)sender {
    NSLog(@"sender.view.tag:%ld",sender.view.tag-10);
    NSInteger tag = sender.view.tag;
    AllModel *model = _modelArray[tag-10];
    [self.delegate thirdClick:model];
}

- (void)awakeFromNib
{
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
