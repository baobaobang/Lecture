//
//  XXXTimePicker.m
//  Lecture
//
//  Created by mortal on 16/2/17.
//  Copyright © 2016年 陈旭. All rights reserved.
//

#import "XXXTimePicker.h"

@interface XXXTimePicker()<UIPickerViewDataSource,UIPickerViewDelegate>

@end

@implementation XXXTimePicker

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIPickerView *picker = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 44, self.frame.size.width, self.frame.size.height-44)];
        [self addSubview:picker];
        picker.delegate = self;
        [picker selectRow:3 inComponent:0 animated:NO];
        self.min = 40;
    }
    
    return self;
}


-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [NSString stringWithFormat:@"%ld分钟",(row+1)*10];
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return 12;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    self.min = (row+1)*10;
}

- (void)close{
    [self.delegate timePicker:self didFinishPickTime:self.min];
    [super close];
}

@end
