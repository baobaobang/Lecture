//
//  NSString+CZ.m
//  D02-音乐播放
//
//  Created by Vincent_Guo on 14-6-28.
//  Copyright (c) 2014年 vgios. All rights reserved.
//

#import "NSString+CZ.h"

@implementation NSString (CZ)

// 将秒转换为0:00格式显示
+(NSString *)getMinuteSecondWithSecond:(NSTimeInterval)time{
    
    int minute = (int)time / 60;
    int second = (int)time % 60;
    
    if (second > 9) { //2:10
        return [NSString stringWithFormat:@"%d:%d",minute,second];
    }
    
    //2:09
    return [NSString stringWithFormat:@"%d:0%d",minute,second];
}


// 将秒转换为00:00:00格式显示
+(NSString *)getHourMinuteSecondWithSecond:(NSTimeInterval)time
{
    NSInteger sec = round(time);
    NSString *tmphh = [NSString stringWithFormat:@"%d",sec/3600];
    if ([tmphh length] == 1)
    {
        tmphh = [NSString stringWithFormat:@"0%@",tmphh];
    }
    
    NSString *tmpmm = [NSString stringWithFormat:@"%d",(sec/60)%60];
    if ([tmpmm length] == 1)
    {
        tmpmm = [NSString stringWithFormat:@"0%@",tmpmm];
    }
    
    NSString *tmpss = [NSString stringWithFormat:@"%d",sec%60];
    if ([tmpss length] == 1)
    {
        tmpss = [NSString stringWithFormat:@"0%@",tmpss];
    }
    
    NSString *result;
    if (sec/3600 == 0) {
        result = [NSString stringWithFormat:@"%@:%@",tmpmm,tmpss];
    }else{
        result = [NSString stringWithFormat:@"%@:%@:%@",tmphh,tmpmm,tmpss];
    }
    return result;
}

// 微信语音显示的时间格式
+(NSString *)wechatTime:(NSTimeInterval)time
{
    NSInteger sec = round(time);
    NSString *tmpmm = [NSString stringWithFormat:@"%d",(sec/60)%60];
    NSString *tmpss = [NSString stringWithFormat:@"%d",sec%60];
    
    NSString *result;
    if ((sec/60)%60 == 0) {
        result = [NSString stringWithFormat:@"%@\"",tmpss];
    }else{
        result = [NSString stringWithFormat:@"%@\'%@\"",tmpmm,tmpss];
    }
    return result;
}


@end
