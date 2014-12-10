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
        [_giftLab setHidden:YES];

        CGSize size = [self getRectWithText:chatModel.nick_name height:12.0 width:CGFLOAT_MAX].size;
        [_nickNameLab setFrame:CGRectMake(38, 8, size.width, 12)];
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
        switch (chatModel.chatType) {
            case contentType:
                [_toNickLab setHidden:YES];
                [_enterIntoLab setText:@"说:"];
                break;
            case tellTAType:
                [_toNickLab setHidden:NO];
                [_enterIntoLab setText:@"告诉"];
                CGSize toSize = [self getRectWithText:chatModel.toNick_name height:12.0 width:CGFLOAT_MAX].size;
                if (chatModel.toNick_name.length) {
                    [_toNickLab setText:chatModel.toNick_name];
                    [_toNickLab setFrame:CGRectMake(size.width + 66, 8, toSize.width, 12)];
                }
                break;
            default:
                break;
        }
        [self loadDataWithModel:chatModel];
    }
}

- (void)loadChangeWithModel:(ChatModel *)chatModel
{
    [_fuhaoImgView setHidden:YES];
    [_contentLab setHidden:YES];
    
    CGSize size = [self getRectWithText:chatModel.nick_name height:12.0 width:CGFLOAT_MAX].size;
    [_nickNameLab setFrame:CGRectMake(8, 8, size.width, 12)];
    [_enterIntoLab setFrame:CGRectMake(size.width + 12, 8, 64, 12)];

    switch (chatModel.chatType) {
        case changeType:
            [_giftLab setHidden:YES];
            [_toNickLab setHidden:YES];
            [_enterIntoLab setText:@"进入直播间"];
            break;
        case featherType:
            [_giftLab setHidden:NO];
            [_toNickLab setHidden:YES];
            [_enterIntoLab setText:@"送给主播"];
            [_giftLab setText:@"一根羽毛"];
            [_giftLab setFrame:CGRectMake(size.width + 65, 8, 64, 12)];
            break;
        case giftType:
            [_giftLab setHidden:NO];
            [_toNickLab setHidden:NO];
            [_enterIntoLab setText:@"送给"];
            CGSize toSize = [self getRectWithText:chatModel.toNick_name height:12.0 width:CGFLOAT_MAX].size;
            if (chatModel.toNick_name.length) {
                [_toNickLab setText:chatModel.toNick_name];
                [_toNickLab setFrame:CGRectMake(size.width + 38, 8, toSize.width, 12)];
            }
            if (chatModel.giftName.length && chatModel.giftCount) {
                NSString *gift = [NSString stringWithFormat:@"%@个%@",chatModel.giftCount,chatModel.giftName];
                CGSize giftSize = [self getRectWithText:gift height:12.0 width:CGFLOAT_MAX].size;
                [_giftLab setText:gift];
                [_giftLab setFrame:CGRectMake(size.width + toSize.width + 40, 8, giftSize.width, 12)];
            }
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
