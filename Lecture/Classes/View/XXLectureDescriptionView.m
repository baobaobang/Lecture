//
//  XXLectureDescriptionView.m
//  Lecture
//
//  Created by 陈旭 on 16/3/1.
//  Copyright © 2016年 陈旭. All rights reserved.
//

#import "XXLectureDescriptionView.h"

@interface XXLectureDescriptionView ()
@property (nonatomic, weak) UILabel *label;
@end

@implementation XXLectureDescriptionView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        UILabel *label = [[UILabel alloc] init];
        [self addSubview:label];
        self.label = label;
    }
    return self;
}

- (void)layoutSubviews{
    self.label.frame = self.bounds;
}

@end
