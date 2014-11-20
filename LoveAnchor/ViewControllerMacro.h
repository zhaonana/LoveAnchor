//
//  ViewControllerMacro.h
//  Massage
//  控制器的宏定义文件

//  Created by Sundy on 14-3-10.
//  Copyright (c) 2014年 Sundy. All rights reserved.
//

#ifndef Massage_ViewControllerMacro_h
#define Massage_ViewControllerMacro_h

#pragma mark -
#pragma mark - 控制器数据
//屏幕的物理宽度
#define     kScreenWidth            [UIScreen mainScreen].bounds.size.width
//屏幕的物理高度
#define     kScreenHeight           [UIScreen mainScreen].bounds.size.height
//当前设备的版本
#define     kCurrentFloatDevice     [[[UIDevice currentDevice]systemVersion]floatValue]
//键盘的高度
#define     kKeyBoardHeight         216

//常用的文字颜色
//#define     textFontColor          @"007e99"
//简介的文字颜色
#define     descTextFontColor      @"999999"
//服务类别等文字的颜色较简介文字颜色深一些
#define     cateTextFontColor      @"666666"
//接近软件风格的文字颜色
#define     softStyleFontColor     @"2598a8"
//列表分割线的颜色
#define     tableViewSepColor      @"d9d9d9"

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define     textFontColor          [UIColor colorWithRed:228/255.0 green:105/255.0 blue:80/255.0 alpha:1]


#endif
