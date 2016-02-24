//
//  XXXTimePicker.h
//  Lecture
//
//  Created by mortal on 16/2/17.
//  Copyright © 2016年 陈旭. All rights reserved.
//

#import "XXXAlertView.h"
@class XXXTimePicker;
@protocol XXXTimePickerDelegate

- (void)timePicker:(XXXTimePicker *)picker didFinishPickTime:(NSInteger)min;

@end

@interface XXXTimePicker : XXXAlertView

@property (nonatomic, assign) NSInteger min;
@property (nonatomic, weak) id<XXXTimePickerDelegate> delegate;
@end
