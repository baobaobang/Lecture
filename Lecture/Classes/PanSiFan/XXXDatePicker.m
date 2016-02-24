//
//  XXXDatePicker.m
//  Lecture
//
//  Created by mortal on 16/2/17.
//  Copyright © 2016年 陈旭. All rights reserved.
//

#import "XXXDatePicker.h"
#import "DateFormatter.h"

@interface XXXDatePicker()

@property (nonatomic, strong) UIDatePicker *datePicker;

@end
@implementation XXXDatePicker

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.title.text = @"选择开始时间";
        _datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 44, frame.size.width, frame.size.height-44)];
        _datePicker.datePickerMode = UIDatePickerModeDateAndTime;

        [self.contanner addSubview:_datePicker];
    }
    return self;
}

- (void)close{
    [self.delegate datePicker:self didFinishPickTime:self.timeStr];
    [super close];
}

- (NSString *)timeStr{
    return [DateFormatter formatDate:self.datePicker.date pattern:@"yyyy-MM-dd HH:mm"];
}
@end
