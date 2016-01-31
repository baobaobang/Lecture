//
//  XXLectureExpertOnlyVC.m
//  Lecture
//
//  Created by 陈旭 on 16/1/29.
//  Copyright © 2016年 陈旭. All rights reserved.
//

#import "XXLectureExpertOnlyVC.h"

@interface XXLectureExpertOnlyVC ()
@property (nonatomic, strong) NSArray *frames;
@end

@implementation XXLectureExpertOnlyVC
- (NSArray *)frames
{
    if (!_frames) {
        _frames = [self loadDataFromPlist];//TODO: 网络
    }
    return _frames;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.questionFrames = self.frames;
}

#pragma mark - 从本地加载数据
- (NSMutableArray *)loadDataFromPlist{
    //TODO: 后面改成从数据加载
    
    // 字典转模型
    // 方式一：从document目录下加载plist
    //    NSString *docmentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    //    NSString *plistPath = [docmentPath stringByAppendingPathComponent:@"Questions.plist"];
    
    // 方式二：从mainBundle目录下加载plist
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Questions.plist" ofType:nil];
    
    NSArray *questions = [XXQuestion mj_objectArrayWithFile:plistPath];
    // question模型转为questionFrames模型
    NSMutableArray *questionFrames = [self questionFramesWithQuestions:questions];
    // 按照点赞数排序
    questionFrames = [questionFrames sortedArrayUsingSelector:@selector(compareAttitudesCount:)];
    
    return questionFrames;
}

@end
