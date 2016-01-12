//
//  XXExpertProfileCell.h
//  Lecture
//
//  Created by 陈旭 on 16/1/10.
//  Copyright © 2016年 陈旭. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XXExpertProfileCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *expertIconBtn;
@property (weak, nonatomic) IBOutlet UILabel *expertNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *expertDepartmentLabel;
@property (weak, nonatomic) IBOutlet UILabel *expertFieldLabel;

+ (instancetype)expertProfileCellInTableView:(UITableView *)tableView;
- (void)cellAutoLayoutHeight;

-(void)cellAutoLayoutHeight:(NSString *)str;
@end
