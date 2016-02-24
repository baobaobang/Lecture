//
//  XXXOnlineCoursewareVC.h
//  Upload
//
//  Created by mortal on 16/1/11.
//  Copyright © 2016年 禾医健康科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XXXBaseVC.h"
#import "UIView+RoundAndShadow.h"
#import "XXXLecturePageModel.h"
@class XXXCoursewareBaseVC;
@interface XXXOnlineCoursewareVC : UIViewController

@property (nonatomic, assign) NSInteger page;//页码
@property (nonatomic, strong) XXXLecturePageModel *pageModel;
@property (nonatomic, weak) XXXCoursewareBaseVC *supperVC;

+ (instancetype)onlineCoursewareViewController;
@end
