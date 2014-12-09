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
        [_giftLab setHighlighted:YES];

        CGSize size = [self getRectWithText:chatModel.nick_name height:12.0 width:CGFLOAT_MAX].size;
        [_nickNameLab setFrame:CGRectMake(39, 7, size.width, size.height)];
        [_enterIntoLab setFrame:CGRectMake(size.width + 40, 8, 64, 12)];
        CGSize contentSize = [self getRectWithText:chatModel.content height:CGFLOAT_MAX width:304.0].size;
        [_contentLab setFrame:CGRectMake(8, 25, 304, contentSize.height)];
        
        if (chatModel.level) {
            NSString *imageName = [NSString stringWithFormat:@"%@fu",chatModel.level];
            _fuhaoImgView.image = [UIImage imageNamed:imageName];
        }
        if (chatModel.content.length) {
            _contentLab.text = chatModel.content;
        }
        [_enterIntoLab setText:@"说:"];
        [self loadDataWithModel:chatModel];
    }
}

- (void)loadChangeWithModel:(ChatModel *)chatModel
{
    [_fuhaoImgView setHidden:YES];
    [_contentLab setHidden:YES];
    
    CGSize size = [self getRectWithText:chatModel.nick_name height:12.0 width:CGFLOAT_MAX].size;
    [_nickNameLab setFrame:CGRectMake(8, 7, size.width, size.height)];
    [_enterIntoLab setFrame:CGRectMake(size.width + 12, 8, 64, 12)];
    [_giftLab setFrame:CGRectMake(size.width + 78, 8, 64, 12)];

    switch (chatModel.chatType) {
        case changeType:
            [_giftLab setHighlighted:YES];
            [_enterIntoLab setText:@"进入直播间"];
            break;
        case featherType:
            [_giftLab setHighlighted:NO];
            [_giftLab setText:@"一根羽毛"];
            [_enterIntoLab setText:@"送给主播"];
            break;
        default:
            break;
    }
    
    [self loadDataWithModel:chatModel];
}

- (void)loadDataWithModel:(ChatModel *)chatModel
{
    if (chatModel.nick_name.length) {
        _nickNameLab.text = chatModel.nick_name;
    }
}

- (CGRect)getRectWithText:(NSString *)text height:(float)height width:(float)width
{
    CGRect rect = [text boundingRectWithSize:CGSizeMake(width, height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0]} context:nil];
    return rect;
}

@end
