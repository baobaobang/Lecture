//
//  XXXMakeLectureView.h
//  Lecture
//
//  Created by mortal on 16/2/1.
//  Copyright © 2016年 陈旭. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XXXMakeLectureView;
@protocol XXXMakeLectureViewDelegate <NSObject>

- (void)XXXMakeLectureView:(XXXMakeLectureView *)mlview clickedIndex:(NSInteger)index;

@end

@interface XXXMakeLectureView : UIView
@property (nonatomic, assign) BOOL isOpen;//按钮收缩状态
@property (nonatomic, weak) id<XXXMakeLectureViewDelegate> delegate;

- (void)animateBtns:(UIButton *)plus;
@end
