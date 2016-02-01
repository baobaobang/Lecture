//
//  XXXLectureModel.h
//  lecture
//
//  Created by mortal on 16/2/1.
//  Copyright © 2016年 禾医健康科技. All rights reserved.
//

#import "XXXBaseModel.h"

@interface XXXLectureModel : XXXBaseModel

@property (nonatomic, copy) NSString  *title;//讲座标题
@property (nonatomic, copy) NSString *titleImageUrl;//讲座简介图
@property (nonatomic, copy) NSString *simpleDesc;//讲座简介
@property (nonatomic, strong) NSArray *contents;//内容页

@end
