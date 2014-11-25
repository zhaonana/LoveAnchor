//
//  DateUtil.m
//  LoveAnchor
//
//  Created by NaNa on 14/11/25.
//  Copyright (c) 2014年 zhongqinglongtu. All rights reserved.
//

#import "DateUtil.h"

@implementation DateUtil

+ (NSString *)getTimeInterval:(NSTimeInterval)time
{
    int distance = time - [[NSDate date] timeIntervalSince1970];
    NSString *string = @"";
    distance = distance / 86400;
    string = [NSString stringWithFormat:@"%d", (distance)];
    return string;
}

+ (NSString *)getLevelImageNameWithCoin:(NSInteger)coin isRich:(BOOL)isRich
{
    NSInteger level = 0;
    NSString *imageName = nil;
    
    if (isRich) {
        if (coin >= 100 && coin < 1100) {
            level = 1;
        } else if (coin >= 1100 && coin < 4200) {
            level = 2;
        } else if (coin >= 4200 && coin < 11200) {
            level = 3;
        } else if (coin >= 11200 && coin < 24500) {
            level = 4;
        } else if (coin >= 24500 && coin < 47100) {
            level = 5;
        } else if (coin >= 47100 && coin < 82600) {
            level = 6;
        } else if (coin >= 82600 && coin < 135200) {
            level = 7;
        } else if (coin >= 135200 && coin < 209700) {
            level = 8;
        } else if (coin >= 209700 && coin < 311500) {
            level = 9;
        } else if (coin >= 311500 && coin < 446600) {
            level = 10;
        } else if (coin >= 446600 && coin < 621600) {
            level = 11;
        } else if (coin >= 621600 && coin < 843700) {
            level = 12;
        } else if (coin >= 843700 && coin < 1120700) {
            level = 13;
        } else if (coin >= 1120700 && coin < 1461000) {
            level = 14;
        } else if (coin >= 1461000 && coin < 1873600) {
            level = 15;
        } else if (coin >= 1873600 && coin < 2368100) {
            level = 16;
        } else if (coin >= 2368100 && coin < 2954700) {
            level = 17;
        } else if (coin >= 2954700 && coin < 3644200) {
            level = 18;
        } else if (coin >= 3644200 && coin < 4448000) {
            level = 19;
        } else if (coin >= 4448000 && coin < 5378100) {
            level = 20;
        } else if (coin >= 5378100 && coin < 6447100) {
            level = 21;
        } else if (coin >= 6447100 && coin < 7668200) {
            level = 22;
        } else if (coin >= 7668200 && coin < 9055200) {
            level = 23;
        } else if (coin >= 9055200 && coin < 10622500) {
            level = 24;
        } else if (coin >= 10622500 && coin < 12385100) {
            level = 25;
        } else if (coin >= 12385100 && coin < 14358600) {
            level = 26;
        } else if (coin >= 14358600) {
            level = 27;
        }
        imageName = [NSString stringWithFormat:@"%dfu",level];
    } else {
        if (coin >= 1000 && coin < 6000) {
            level = 1;
        } else if (coin >= 6000 && coin < 17000) {
            level = 2;
        } else if (coin >= 17000 && coin < 36000) {
            level = 3;
        } else if (coin >= 36000 && coin < 65000) {
            level = 4;
        } else if (coin >= 65000 && coin < 106000) {
            level = 5;
        } else if (coin >= 106000 && coin < 161000) {
            level = 6;
        } else if (coin >= 161000 && coin < 232000) {
            level = 7;
        } else if (coin >= 232000 && coin < 321000) {
            level = 8;
        } else if (coin >= 321000 && coin < 430000) {
            level = 9;
        } else if (coin >= 430000 && coin < 561000) {
            level = 10;
        } else if (coin >= 561000 && coin < 716000) {
            level = 11;
        } else if (coin >= 716000 && coin < 897000) {
            level = 12;
        } else if (coin >= 897000 && coin < 1106000) {
            level = 13;
        } else if (coin >= 1106000 && coin < 1345000) {
            level = 14;
        } else if (coin >= 1345000 && coin < 1616000) {
            level = 15;
        } else if (coin >= 1616000 && coin < 1921000) {
            level = 16;
        } else if (coin >= 1921000 && coin < 2262000) {
            level = 17;
        } else if (coin >= 2262000 && coin < 2641000) {
            level = 18;
        } else if (coin >= 2641000 && coin < 3060000) {
            level = 19;
        } else if (coin >= 3060000 && coin < 3521000) {
            level = 20;
        } else if (coin >= 3521000 && coin < 4026000) {
            level = 21;
        } else if (coin >= 4026000 && coin < 4577000) {
            level = 22;
        } else if (coin >= 4577000 && coin < 5176000) {
            level = 23;
        } else if (coin >= 5176000 && coin < 5825000) {
            level = 24;
        } else if (coin >= 5825000 && coin < 6526000) {
            level = 25;
        } else if (coin >= 6526000 && coin < 7281000) {
            level = 26;
        } else if (coin >= 7281000 && coin < 8092000) {
            level = 27;
        } else if (coin >= 8092000 && coin < 8961000) {
            level = 28;
        } else if (coin >= 8961000 && coin < 9890000) {
            level = 29;
        } else if (coin >= 9890000 && coin < 10881000) {
            level = 30;
        } else if (coin >= 10881000 && coin < 11936000) {
            level = 31;
        } else if (coin >= 11936000 && coin < 13057000) {
            level = 32;
        } else if (coin >= 13057000 && coin < 14246000) {
            level = 33;
        } else if (coin >= 14246000 && coin < 15505000) {
            level = 34;
        } else if (coin >= 15505000 && coin < 16836000) {
            level = 35;
        } else if (coin >= 16836000 && coin < 18241000) {
            level = 36;
        } else if (coin >= 18241000 && coin < 19722000) {
            level = 37;
        } else if (coin >= 19722000 && coin < 21281000) {
            level = 38;
        } else if (coin >= 21281000 && coin < 22920000) {
            level = 39;
        } else if (coin >= 22920000 && coin < 24641000) {
            level = 40;
        } else if (coin >= 24641000 && coin < 26446000) {
            level = 41;
        } else if (coin >= 26446000 && coin < 28337000) {
            level = 42;
        } else if (coin >= 28337000 && coin < 30316000) {
            level = 43;
        } else if (coin >= 30316000 && coin < 32385000) {
            level = 44;
        } else if (coin >= 32385000 && coin < 34546000) {
            level = 45;
        } else if (coin >= 34546000 && coin < 36801000) {
            level = 46;
        } else if (coin >= 36801000 && coin < 39152000) {
            level = 47;
        } else if (coin >= 39152000 && coin < 41601000) {
            level = 48;
        } else if (coin >= 41601000 && coin < 44150000) {
            level = 49;
        } else if (coin >= 44150000 && coin < 46801000) {
            level = 50;
        } else if (coin >= 46801000 && coin < 49556000) {
            level = 51;
        } else if (coin >= 49556000 && coin < 52417000) {
            level = 52;
        } else if (coin >= 52417000 && coin < 55386000) {
            level = 53;
        } else if (coin >= 55386000 && coin < 58465000) {
            level = 54;
        } else if (coin >= 58465000 && coin < 61656000) {
            level = 55;
        } else if (coin >= 61656000 && coin < 64961000) {
            level = 56;
        } else if (coin >= 64961000 && coin < 68382000) {
            level = 57;
        } else if (coin >= 68382000 && coin < 71921000) {
            level = 58;
        } else if (coin >= 71921000 && coin < 75580000) {
            level = 59;
        } else if (coin >= 75580000) {
            level = 60;
        }
        imageName = [NSString stringWithFormat:@"%dzhubo",level];
    }
    
    return imageName;
}

@end
