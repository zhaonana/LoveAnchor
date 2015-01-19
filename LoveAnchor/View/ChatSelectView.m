//
//  ChatSelectView.m
//  LoveAnchor
//
//  Created by NaNa on 15/1/16.
//  Copyright (c) 2015年 zhongqinglongtu. All rights reserved.
//

#import "ChatSelectView.h"

@interface ChatSelectView () 

@property (weak, nonatomic) IBOutlet UIView *bgView;

@end

@implementation ChatSelectView

- (void)awakeFromNib
{
    UITapGestureRecognizer *bgViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    [_bgView addGestureRecognizer:bgViewTap];
}

- (void)tapGesture:(UITapGestureRecognizer *)tap
{
    [self removeFromSuperview];
}

- (IBAction)selectTypeClick:(UIButton *)sender
{
    if (self.selectTypeBlock) {
        self.selectTypeBlock(sender.tag);
    }
    [self removeFromSuperview];
}

@end
