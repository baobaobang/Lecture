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
@interface XXXOnlineCoursewareVC : XXXBaseVC

@property (nonatomic, assign) NSInteger page;//页码

+(instancetype)onlineCoursewareWithSupperVC:(UIViewController *)vc;

@end
