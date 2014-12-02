//  2924006737 buzhidaomima
//  AppDelegate.m
//  LoveAnchor
//  15811562734
//  Created by zhongqinglongtu on 14-8-11.
//  Copyright (c) 2014年 zhongqinglongtu. All rights reserved.
//

#import "AppDelegate.h"
#import <ShareSDK/ShareSDK.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    
    [SliderViewController sharedSliderController].LeftVC = [[LeftMenuViewController alloc] init];
    [SliderViewController sharedSliderController].RightVC = [[RightMenuViewController alloc] init];
    [SliderViewController sharedSliderController].RightSContentOffset=260;
    [SliderViewController sharedSliderController].RightSContentScale=0.85;
    [SliderViewController sharedSliderController].RightSOpenDuration=0.8;
    [SliderViewController sharedSliderController].RightSCloseDuration=0.4;
    [SliderViewController sharedSliderController].RightSJudgeOffset=160;
    [SliderViewController sharedSliderController].LeftSContentOffset = 260;
    
    
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[SliderViewController sharedSliderController]];
    
    
    //第三方登录
    [ShareSDK registerApp:@"47e11a1b1da2"];
    //sina
    [ShareSDK connectSinaWeiboWithAppKey:@"2352021188"
                                appSecret:@"37964df50726ec3ddb017fef36397851"
                                redirectUri:@"http://weibo.com/u/2389484970/home?wvr=5"];
    //QQ
    [ShareSDK connectQZoneWithAppKey:@"1103558424" appSecret:@"ldR56iwXfFAZMAVo" qqApiInterfaceCls:[QQApiInterface class] tencentOAuthCls:[TencentOAuth class]];
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [ShareSDK handleOpenURL:url wxDelegate:self];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [ShareSDK handleOpenURL:url sourceApplication:sourceApplication annotation:annotation wxDelegate:self];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
