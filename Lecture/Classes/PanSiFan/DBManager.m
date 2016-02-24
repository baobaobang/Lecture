//
//  DBManager.m
//  Upload
//
//  Created by mortal on 16/1/11.
//  Copyright © 2016年 禾医健康科技. All rights reserved.
//

#import "DBManager.h"
@implementation DBManager

+ (instancetype)shareDBManager{
    static dispatch_once_t onceToken;
    static DBManager *sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        if (!sharedInstance) {
            sharedInstance = [[self alloc]init];
        }
    });
    return sharedInstance;
}

- (FMDatabase *)db{
    if (!_db) {
        NSString *document = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        NSString *path = [document stringByAppendingPathComponent:@"LectureRoom.db"];
        _db = [FMDatabase databaseWithPath:path];
        NSLog(@"%@",path);
    }
    return _db;
}
@end
