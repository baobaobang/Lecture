//
//  XXXLectureModel.m
//  lecture
//
//  Created by mortal on 16/2/1.
//  Copyright © 2016年 禾医健康科技. All rights reserved.
//

#import "XXXLectureModel.h"
#import "DateFormatter.h"
@implementation XXXLectureModel


+ (NSMutableArray *)objectArrayWithArray:(NSArray *)dictArray{
    
    [XXXLectureModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"lectureId":@"id",
                 @"desc":@"description"};
    }];
    [XXXLectureModel mj_setupObjectClassInArray:^NSDictionary *{
        return @{@"pages":@"XXXLecturePageModel"};
    }];
    return [XXXLectureModel mj_objectArrayWithKeyValuesArray:dictArray];
}


- (BOOL)save{
    
    FMDatabase *db = [DBManager shareDBManager].db;
    BOOL result = NO;
    if ([db open]) {
        
//        db executeQuery:@"SELECT count(*) FROM t_Lecture WHERE "
//        
        result = [db executeUpdate:@"DELETE FROM t_Lecture WHERE LectureId = ? ",self.lectureId];
        result = [db executeUpdate:@"INSERT INTO t_Lecture(LectureId, expertId, StartDate, Duration, OnlineDuration, Title, Desc, Cover, Hospital, Department, Introduction, JobTitle, Speciality, Name, HeadPic) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",self.lectureId,self.expertId,self.startDate,[NSNumber numberWithInteger:self.duration],[NSNumber numberWithInteger:self.onlineDuration],self.title,self.desc,self.cover,self.hospital,self.department,self.introduction,self.jobTitle,self.speciality,self.name,self.headPic];
        for (XXXLecturePageModel *page in self.pages) {
            [db executeUpdate:@"DELETE FROM t_LecturePage WHERE PageNo = ?",@(page.pageNo)];
            BOOL t = [db executeUpdate:@"INSERT INTO t_LecturePage(LectureId, PageNo, Title, Picture, Audio,LocalImage) VALUES(?,?,?,?,?,?)",page.lectureId,@(page.pageNo),page.title,page.picture,page.audio,page.localImage];
            if (!t) {
                result = NO;
            }
        }
    }
    [db close];
    return result;
}

+ (NSMutableArray *)AllLocalLectureModels{
    FMDatabase *db = [DBManager shareDBManager].db;
    NSMutableArray *arr = [NSMutableArray array];
    
    if ([db open]) {
       FMResultSet *result = [db executeQuery:@"SELECT * FROM t_Lecture"];
        while([result next]) {
            XXXLectureModel *model = [[XXXLectureModel alloc]init];
            model.lectureId = [result stringForColumn:@"LectureId"];
            model.expertId = [result stringForColumn:@"ExpertId"];
            model.startDate = [result stringForColumn:@"StartDate"];
            model.duration = [result intForColumn:@"Duration"];
            model.onlineDuration = [result intForColumn:@"OnlineDuration"];
            model.title = [result stringForColumn:@"Title"];
            model.desc = [result stringForColumn:@"Desc"];
            model.cover = [result stringForColumn:@"Cover"];
            model.hospital = [result stringForColumn:@"Hospital"];
            model.department = [result stringForColumn:@"Department"];
            model.introduction = [result stringForColumn:@"Introduction"];
            model.jobTitle = [result stringForColumn:@"JobTitle"];
            model.speciality = [result stringForColumn:@"Speciality"];
            model.name = [result stringForColumn:@"Name"];
            model.headPic = [result stringForColumn:@"HeadPic"];
            model.pages = [NSMutableArray array];
            
            FMResultSet *pageSet = [db executeQuery:@"SELECT * FROM t_LecturePage WHERE LectureId = ? ",model.lectureId];
            while ([pageSet next]) {
                XXXLecturePageModel *pageModel = [[XXXLecturePageModel alloc]init];
                pageModel.lectureId = [pageSet stringForColumn:@"LectureId"];
                pageModel.title = [pageSet stringForColumn:@"Title"];
                pageModel.pageNo = [pageSet intForColumn:@"PageNo"];
                pageModel.picture = [pageSet stringForColumn:@"Picture"];
                pageModel.audio = [pageSet stringForColumn:@"Audio"];
                pageModel.localImage = [pageSet dataForColumn:@"LocalImage"];
                [model.pages addObject:pageModel];
            }
            [arr addObject:model];
        }
    }
    [db close];
    return arr;
}

+ (BOOL)deleteElements:(NSArray *)elementsArray{
    FMDatabase *db = [DBManager shareDBManager].db;
    BOOL result = YES;
    if ([db open]) {
        for (XXXLectureModel *model in elementsArray) {
           BOOL i = [db executeUpdate:@"DELETE FROM t_Lecture WHERE LectureId = ?",model.lectureId];
            if (!i) {
                result = NO;
            }
            [db executeUpdate:@"DELETE FROM t_LecturePage WHERE LectureId = ?",model.lectureId];
        }
    }
    [db close];
    return result;
}

- (NSString *)startDate{
    ////NSLog(@"%@",_startDate);
    NSString *d = [_startDate substringToIndex:10];
    NSString *h = [_startDate substringWithRange:NSMakeRange(11, 5)];
    NSDate *date = [DateFormatter dateFromString:[NSString stringWithFormat:@"%@ %@",d,h]];
    NSDate *newDate = [NSDate dateWithTimeInterval:28800 sinceDate:date];
    return [DateFormatter formatDate:newDate pattern:@"yyyy-MM-dd HH:mm"];
}


- (NSMutableArray<XXXLecturePageModel *> *)pages{
    if (!_pages) {
        _pages = [NSMutableArray array];
    }
    return _pages;
}
@end
