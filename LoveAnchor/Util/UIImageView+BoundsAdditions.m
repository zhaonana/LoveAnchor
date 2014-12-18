//
//  UIImageView+BoundsAdditions.m
//  LoveAnchor
//
//  Created by NaNa on 14/12/18.
//  Copyright (c) 2014年 zhongqinglongtu. All rights reserved.
//

#import "UIImageView+BoundsAdditions.h"

@implementation UIImageView (BoundsAdditions)

- (void)makeBoundImage
{
    self.layer.masksToBounds = YES;
    [self.layer setCornerRadius:self.frame.size.width/2.0];
}

@end
