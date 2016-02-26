//
//  XXXLectureModel.h
//  lecture
//
//  Created by mortal on 16/2/1.
//  Copyright © 2016年 禾医健康科技. All rights reserved.
//

#import "XXXBaseModel.h"
#import "XXXLecturePageModel.h"
@interface XXXLectureModel : XXXBaseModel

@property (nonatomic, copy) NSString *lectureId;
@property (nonatomic, copy) NSString *expertId;//专家ID
@property (nonatomic, copy) NSString *startDate;//开始日期
//@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, assign) NSInteger duration;//持续时间
@property (nonatomic, assign) NSInteger onlineDuration;//在线交流持续时间
@property (nonatomic, copy) NSString *title;//讲座标题
@property (nonatomic, copy) NSString *desc;//讲座简介
@property (nonatomic, copy) NSString *cover;//讲座封面
@property (nonatomic, copy) NSString *hospital;//专家医院
@property (nonatomic, copy) NSString *department;//专家部门
@property (nonatomic, copy) NSString *introduction;//专家介绍
@property (nonatomic, copy) NSString *jobTitle;//专家职称
@property (nonatomic, copy) NSString *speciality;//专家擅长
@property (nonatomic, copy) NSString *name;//专家姓名
@property (nonatomic, copy) NSString *headPic;//头像

@property (nonatomic, strong) NSMutableArray<XXXLecturePageModel *> *pages;//讲座页
+ (NSMutableArray *)objectArrayWithArray:(NSArray *)dictArray;

//本地数据库中的数据
+ (NSMutableArray *)AllLocalLectureModels;
@end
