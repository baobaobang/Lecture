//
//  ViewController.h
//  Upload
//
//  Created by mortal on 16/1/11.
//  Copyright © 2016年 禾医健康科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XXXBaseVC.h"
#import "XXXLectureModel.h"
#define SSIZE [UIScreen mainScreen].bounds.size
//#define SWIDTH SSIZE.width
//#define SHEIGHT SSIZE.height
@interface XXXCoursewareBaseVC : XXXBaseVC

@property (nonatomic, strong) XXXLectureModel *lectureModel;//模型
@property (nonatomic, strong) UIScrollView *titleTips;
@property (assign,nonatomic)NSInteger curPage;//当前编辑页

- (void)addpage:(XXXLecturePageModel *)pageModel;
- (void)clickAddPage;
@end

