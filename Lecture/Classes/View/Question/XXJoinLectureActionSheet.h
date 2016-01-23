//
//  XXJoinLectureActionSheet.h
//  Lecture
//
//  Created by 陈旭 on 16/1/23.
//  Copyright © 2016年 陈旭. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XXJoinLectureActionSheet, XXLecture;

@protocol XXJoinLectureActionSheetDelegate <NSObject>

@optional
- (void)joinLectureActionSheet:(XXJoinLectureActionSheet *)sheet didClickDoneButton:(UIButton *)btn;

@end
@interface XXJoinLectureActionSheet : UIView
@property (nonatomic, weak) id<XXJoinLectureActionSheetDelegate> delegate;

@property (nonatomic, strong) XXLecture *lecture;

-(void)showInView:(UIView *)view;
@end
