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

- (void)loadDataWithModel:(ChatModel *)chatModel
{
    CGSize size = [chatModel.nick_name sizeWithFont:[UIFont systemFontOfSize:12.0] constrainedToSize:CGSizeMake(MAXFLOAT, 12)];
    if (chatModel.nick_name.length) {
        _nickNameLab.text = chatModel.nick_name;
    }

    if (chatModel.level) {
        [_fuhaoImgView setHidden:NO];
        [_contentLab setHidden:NO];
        [_enterIntoLab setHidden:YES];
        NSInteger level = [CommonUtil getLevelInfoWithCoin:chatModel.level.intValue isRich:YES].level;
        NSString *imageName = [NSString stringWithFormat:@"%dfu",level];
        _fuhaoImgView.image = [UIImage imageNamed:imageName];
        
        [_nickNameLab setFrame:CGRectMake(39, 8, size.width, 12)];
        if (chatModel.content.length) {
            _contentLab.text = chatModel.content;
        }
    } else {
        [_enterIntoLab setHidden:NO];
        [_fuhaoImgView setHidden:YES];
        [_contentLab setHidden:YES];
        [_nickNameLab setFrame:CGRectMake(8, 8, size.width, 12)];
        [_enterIntoLab setFrame:CGRectMake(size.width + 10, 8, 64, 12)];
    }
    
}

@end
