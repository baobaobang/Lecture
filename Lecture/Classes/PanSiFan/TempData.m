//
//  TempData.m
//  Lecture
//
//  Created by mortal on 16/2/14.
//  Copyright © 2016年 陈旭. All rights reserved.
//

#import "TempData.h"

@implementation TempData

+ (instancetype)shareTempData{
    static dispatch_once_t onceToken;
    static TempData *sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        if (!sharedInstance) {
            sharedInstance = [[self alloc]init];
        }
    });
    return sharedInstance;
}


@end
