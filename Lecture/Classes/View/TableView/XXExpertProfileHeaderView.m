//
//  XXExpertProfileHeaderView.m
//  Lecture
//
//  Created by 陈旭 on 16/1/10.
//  Copyright © 2016年 陈旭. All rights reserved.
//

#import "XXExpertProfileHeaderView.h"

@interface XXExpertProfileHeaderView ()
@property (weak, nonatomic) IBOutlet UIButton *followBtn;

@end

@implementation XXExpertProfileHeaderView

- (void)awakeFromNib{
    [super awakeFromNib];
    
    self.followBtn.backgroundColor = HWTintColor;
}

+ (instancetype)headerView{
    return [[[NSBundle mainBundle] loadNibNamed:@"XXExpertProfileHeaderView" owner:nil options:nil] lastObject];
}

@end
