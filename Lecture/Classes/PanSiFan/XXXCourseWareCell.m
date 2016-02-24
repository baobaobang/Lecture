//
//  XXXCourseWareCell.m
//  Lecture
//
//  Created by mortal on 16/2/22.
//  Copyright © 2016年 陈旭. All rights reserved.
//

#import "XXXCourseWareCell.h"
#import "XXXOnlineCoursewareVC.h"
@implementation XXXCourseWareCell


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.viewController = [XXXOnlineCoursewareVC onlineCoursewareViewController];
        [self addSubview:self.viewController.view];
    }
    return self;
}

@end
