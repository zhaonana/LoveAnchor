//
//  ChatCell.m
//  LoveAnchor
//
//  Created by NaNa on 14/12/8.
//  Copyright (c) 2014年 zhongqinglongtu. All rights reserved.
//

#import "ChatCell.h"

@implementation ChatCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)loadContentWithModel:(ChatModel *)chatModel
{
    if (chatModel.level) {
        [_fuhaoImgView setHidden:NO];
        [_contentLab setHidden:NO];
        [_enterIntoLab setHidden:YES];
        
        CGSize size = [self getRectWithText:chatModel.nick_name].size;
        [_nickNameLab setFrame:CGRectMake(39, 8, size.width, size.height)];
        [_contentLab setFrame:CGRectMake(8, 25, 304, size.height)];
        if (chatModel.level) {
            NSInteger level = [CommonUtil getLevelInfoWithCoin:chatModel.level.intValue isRich:YES].level;
            NSString *imageName = [NSString stringWithFormat:@"%dfu",level];
            _fuhaoImgView.image = [UIImage imageNamed:imageName];
        }
        if (chatModel.content.length) {
            _contentLab.text = chatModel.content;
        }
        [self loadDataWithModel:chatModel];
    }
}

- (void)loadChangeWithModel:(ChatModel *)chatModel
{
    [_enterIntoLab setHidden:NO];
    [_fuhaoImgView setHidden:YES];
    [_contentLab setHidden:YES];
    
    CGSize size = [self getRectWithText:chatModel.nick_name].size;
    [_nickNameLab setFrame:CGRectMake(8, 8, size.width, size.height)];
    [_enterIntoLab setFrame:CGRectMake(size.width + 12, 8, 64, 12)];
    
    [self loadDataWithModel:chatModel];
}

- (void)loadDataWithModel:(ChatModel *)chatModel
{
    if (chatModel.nick_name.length) {
        _nickNameLab.text = chatModel.nick_name;
    }
}

- (CGRect)getRectWithText:(NSString *)text
{
    CGRect rect = [text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 12.0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0]} context:nil];
    return rect;
}

@end
