//
//  RecordButton.h
//  Upload
//
//  Created by mortal on 16/1/13.
//  Copyright © 2016年 禾医健康科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XXXLecturePageModel.h"
typedef NS_ENUM(NSInteger,RecorderState){
    RecorderStateStop = 0,
    RecorderStatePause = 1,
    RecorderStateRecording = 2
};

@class RecordButton;
@protocol RecordStopDelegate <NSObject>

- (void)stopRecord:(RecordButton *) button;

@end

@interface RecordButton : UIButton

@property (nonatomic, strong) UIButton *deleteBtn;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) NSMutableArray *voiceUrls;
@property (nonatomic, copy) NSString *courseTitle;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) XXXLecturePageModel *pageModel;
@property (nonatomic, weak) id<RecordStopDelegate> delegate;
@end

