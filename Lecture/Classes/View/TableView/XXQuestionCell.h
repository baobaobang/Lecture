//
//  XXQuestionCell.h
//  Lecture
//
//  Created by 陈旭 on 16/1/10.
//  Copyright © 2016年 陈旭. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XXQuestion;

@interface XXQuestionCell : UITableViewCell
+ (instancetype)QuestionCellInTableView:(UITableView *)tableView;
- (void)cellAutoLayoutHeight;

@property (weak, nonatomic) IBOutlet XXButton *shieldBtn;

@property (nonatomic, strong) XXQuestion *question;
@end
