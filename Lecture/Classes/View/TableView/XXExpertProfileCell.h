//
//  XXExpertProfileCell.h
//  Lecture
//
//  Created by 陈旭 on 16/1/10.
//  Copyright © 2016年 陈旭. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XXExpertProfileCell : UITableViewCell
+ (instancetype)expertProfileCellInTableView:(UITableView *)tableView;
- (void)cellAutoLayoutHeight;
@end