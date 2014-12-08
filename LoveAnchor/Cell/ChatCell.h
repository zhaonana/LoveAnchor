//
//  ChatCell.h
//  LoveAnchor
//
//  Created by NaNa on 14/12/8.
//  Copyright (c) 2014年 zhongqinglongtu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatModel.h"

@interface ChatCell : UITableViewCell
//富豪等级
@property (weak, nonatomic) IBOutlet UIImageView *fuhaoImgView;
//昵称
@property (weak, nonatomic) IBOutlet UILabel     *nickNameLab;
//聊天内容
@property (weak, nonatomic) IBOutlet UILabel     *contentLab;
//进入直播间
@property (weak, nonatomic) IBOutlet UILabel     *enterIntoLab;

- (void)loadDataWithModel:(ChatModel *)chatModel;

@end
