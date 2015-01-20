//
//  ChatCell.h
//  LoveAnchor
//
//  Created by NaNa on 14/12/8.
//  Copyright (c) 2014年 zhongqinglongtu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatModel.h"
#import "MLEmojiLabel.h"

@interface ChatCell : UITableViewCell
//富豪等级
@property (weak, nonatomic) IBOutlet UIImageView  *fuhaoImgView;
//昵称
@property (weak, nonatomic) IBOutlet UILabel      *nickNameLab;
//对方昵称
@property (weak, nonatomic) IBOutlet UILabel      *toNickLab;
//聊天内容
@property (weak, nonatomic) IBOutlet MLEmojiLabel *contentLab;
//进入直播间
@property (weak, nonatomic) IBOutlet UILabel      *enterIntoLab;
//礼物
@property (weak, nonatomic) IBOutlet UILabel      *giftLab;
//点击昵称
@property (copy, nonatomic) void (^nickTapBlock)(NSInteger tag);

//进入房间提示/送给主播羽毛
- (void)loadChangeWithModel:(ChatModel *)chatModel;
//聊天消息
- (void)loadContentWithModel:(ChatModel *)chatModel;

@end
