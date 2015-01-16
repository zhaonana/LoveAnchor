//
//  ShareView.h
//  LoveAnchor
//
//  Created by NaNa on 15/1/6.
//  Copyright (c) 2015年 zhongqinglongtu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShareView : UIView

@property (nonatomic, copy)   NSString         *shareText;
@property (nonatomic, copy)   NSString         *imageUrl;
@property (nonatomic, copy)   NSString         *urlString;
@property (nonatomic, strong) UIViewController *controller;

@property (nonatomic, strong) IBOutlet UIView *shareButView;

- (void)shareWithText:(NSString *)str shareImageUrl:(NSString *)imageUrl shareUrl:(NSString *)url controller:(UIViewController *)controller;

@end
