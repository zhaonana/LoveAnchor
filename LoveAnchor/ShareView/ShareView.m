//
//  ShareView.m
//  LoveAnchor
//
//  Created by NaNa on 15/1/6.
//  Copyright (c) 2015年 zhongqinglongtu. All rights reserved.
//

#import "ShareView.h"
#import <ShareSDK/ShareSDK.h>

@interface ShareView () {
    IBOutlet UIButton *_cancleBut;
    UIImage *_image;
}

@end

@implementation ShareView

- (void)shareWithText:(NSString *)str shareImageUrl:(NSString *)imageUrl shareUrl:(NSString *)url
{
    self.shareText = str;
    self.imageUrl = imageUrl;
    self.urlString = url;
    
    _image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]]];
}

- (IBAction)selectShareType:(UIButton *)sender
{
    id<ISSCAttachment> imageAttach = [ShareSDK imageWithUrl:self.imageUrl];
    
    id<ISSShareOptions> simpleShareOptions = [ShareSDK simpleShareOptionsWithTitle:@"分享"
                        shareViewDelegate:nil ];
    NSString *shareContent = [NSString stringWithFormat:@"%@",self.shareText];

    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:shareContent
                                       defaultContent:@""
                                                image:imageAttach
                                                title:shareContent
                                                  url:self.urlString
                                          description:shareContent                                           mediaType:SSPublishContentMediaTypeNews];
    
    SSPublishContentEventHandler publishHandler =^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
        if (state == SSResponseStateSuccess) {
            [self removeFromSuperview];
            self.hidden = NO;
            
            [[[UIAlertView alloc] initWithTitle:@"分享成功!" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
        }
        else if (state == SSResponseStateFail) {
            NSLog(@"分享失败,错误码:%d,错误描述:%@", [error errorCode], [error errorDescription]);
            
            self.hidden = NO;
            [[[UIAlertView alloc] initWithTitle:@"暂时无法分享!" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
        }
    };

    switch (sender.tag) {
        case 100: { //QQ好友
            publishContent = [ShareSDK content:shareContent
                                defaultContent:@""
                                         image:imageAttach
                                         title:@"爱主播"
                                           url:self.urlString
                                   description:shareContent
                                     mediaType:SSPublishContentMediaTypeNews];
            
            [ShareSDK showShareViewWithType:ShareTypeQQ
                                  container:nil
                                    content:publishContent
                              statusBarTips:NO
                                authOptions:nil
                               shareOptions:simpleShareOptions
                                     result:publishHandler];
        }
            break;
        case 200: { //新浪微博
            self.hidden = YES;
            
            imageAttach = [ShareSDK jpegImageWithImage:_image quality:.5f];
            
            publishContent = [ShareSDK content:shareContent
                                defaultContent:nil
                                         image:imageAttach
                                         title:@"爱主播"
                                           url:self.urlString
                                   description:@"来自爱主播客户端"
                                     mediaType:SSPublishContentMediaTypeNews];
            
            
            [ShareSDK shareContent:publishContent
                              type:ShareTypeSinaWeibo
                       authOptions:nil
                     statusBarTips:YES
                            result:publishHandler];
        }
            break;
        case 300: { //QQ空间
            publishContent = [ShareSDK content:shareContent
                                defaultContent:@""
                                         image:imageAttach
                                         title:@"爱主播"
                                           url:self.urlString
                                   description:shareContent                                           mediaType:SSPublishContentMediaTypeNews];
            
            [ShareSDK showShareViewWithType:ShareTypeQQSpace
                                  container:nil
                                    content:publishContent
                              statusBarTips:NO
                                authOptions:nil
                               shareOptions:simpleShareOptions
                                     result:publishHandler
             ];
        }
            break;
        case 400: { //取消
            [UIView animateWithDuration:0.25 animations:^(void) {

            } completion:^(BOOL finshed) {
                [self removeFromSuperview];
            }];
        }
            break;
        default:
            break;
    }
}

@end
