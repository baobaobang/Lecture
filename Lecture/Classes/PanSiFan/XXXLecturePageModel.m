//
//  XXXLecturePageModel.m
//  Lecture
//
//  Created by mortal on 16/2/14.
//  Copyright © 2016年 陈旭. All rights reserved.
//

#import "XXXLecturePageModel.h"

@implementation XXXLecturePageModel

- (BOOL)save{
    
    FMDatabase *db = [DBManager shareDBManager].db;
    BOOL result = NO;
    if ([db open]) {
//        NSError *error;
//        result = [db executeUpdate:@"INSERT INTO t_LecturePage(LectureId, PageNo, Title, Picture, Audio) VALUES(?,?,?,?,?)" values:@[self.lectureId,@(self.pageNo),self.title,self.picture,self.audio] error:&error];
        result = [db executeUpdate:@"INSERT INTO t_LecturePage(LectureId, PageNo, Title, Picture, Audio) VALUES(?,?,?,?,?)",self.lectureId,@(self.pageNo),self.title,self.picture,self.audio];
    }
    [db close];
    return result;
    
}

- (NSMutableArray *)localUrls{
    if (!_localUrls) {
        _localUrls = [NSMutableArray array];
    }
    return _localUrls;
}
@end
