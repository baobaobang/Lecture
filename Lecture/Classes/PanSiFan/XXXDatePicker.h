//
//  XXXDatePicker.h
//  Lecture
//
//  Created by mortal on 16/2/17.
//  Copyright © 2016年 陈旭. All rights reserved.
//

#import "XXXAlertView.h"
@class XXXDatePicker;
@protocol XXXDatePickerDelegate <NSObject>

- (void)datePicker:(XXXDatePicker *)picker didFinishPickTime:(NSString *)timeStr;

@end

@interface XXXDatePicker : XXXAlertView

@property (nonatomic, copy) NSString *timeStr;
@property (nonatomic, weak) id<XXXDatePickerDelegate> delegate;
@end
