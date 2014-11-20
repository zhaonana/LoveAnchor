//
//  CommonHelp.m
//  LoveAnchor
//
//  Created by NaNa on 14-10-23.
//  Copyright (c) 2014年 zhongqinglongtu. All rights reserved.
//

#import "CommonHelp.h"

@implementation CommonHelp

+ (NSInteger)getLevelWithCoin:(NSInteger)coin isRich:(BOOL)isRich
{
    Boolean flag = true;
    NSInteger num = 0;
    NSInteger extraNum = 0;
    NSInteger currNum = 0;
    NSInteger i = 0;
    NSInteger base = isRich ? 100 : 1000;
    
    while (flag) {
        extraNum = coin - num;
        
        if (isRich) {
            if (i < 21) {
                currNum = ((i+1)*(i+1)*(i+1)+2*i)*base;
            } else if (i < 25) {
                switch (i) {
                    case 21 :
                        currNum = 6421900;
                        break;
                    case 22 :
                        currNum = 14000000;
                        break;
                    case 23 :
                        currNum = 26000000;
                        break;
                    case 24 :
                        currNum = 52600000;
                        break;
                }
            } else {
                extraNum = 0;
                currNum = 0;
                flag = false;
                break;
            }
        } else {
            if (i < 55) {
                currNum = ((i+1)*(i+1) + i)*base;
            } else {
                extraNum = 0;
                currNum = 0;
                flag = false;
                break;
            }
        }
        
        num += currNum;
        
        if (coin < num || currNum == 0) {
            flag = false;
            break;
        }
        
        i++;
    }
    return i;
}

@end
