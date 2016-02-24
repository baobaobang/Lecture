//
//  DBManager.h
//  Upload
//
//  Created by mortal on 16/1/11.
//  Copyright © 2016年 禾医健康科技. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"

@class FMDatabase;
@class XXXLectureModel;
@class XXXLecturePageModel;
@interface DBManager : NSObject

//
//+ (BOOL)saveLecture:(XXXLecturePageModel *)model;

@property (nonatomic, strong) FMDatabase *db;

+ (instancetype)shareDBManager;

@end
