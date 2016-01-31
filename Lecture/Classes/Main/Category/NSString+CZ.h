//
//  NSString+CZ.h
//  D02-音乐播放
//
//  Created by Vincent_Guo on 14-6-28.
//  Copyright (c) 2014年 vgios. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (CZ)

/**
 *  将秒转换为00:00:00格式显示
 */
+(NSString *)getHourMinuteSecondWithSecond:(NSTimeInterval)time;
@end
