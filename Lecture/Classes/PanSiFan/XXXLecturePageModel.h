//
//  XXXLecturePageModel.h
//  Lecture
//
//  Created by mortal on 16/2/14.
//  Copyright © 2016年 陈旭. All rights reserved.
//

#import "XXXBaseModel.h"

@interface XXXLecturePageModel : XXXBaseModel

@property (nonatomic, assign) NSInteger pageNo;//页码
@property (nonatomic, copy) NSString *title;//标题
@property (nonatomic, copy) NSString *picture;//图片
@property (nonatomic, copy) NSString *audio;//音频
@property (nonatomic, copy) NSString *lectureId;
@property (nonatomic, strong) NSMutableArray *localUrls;
@property (nonatomic, strong)NSData *localImage;

- (BOOL)save;
@end
