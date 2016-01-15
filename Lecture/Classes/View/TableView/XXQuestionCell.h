//
//  XXQuestionCell.h
//  Lecture
//
//  Created by 陈旭 on 16/1/10.
//  Copyright © 2016年 陈旭. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XXQuestion, XXQuestionToolbar;

@interface XXQuestionCell : UITableViewCell
+ (instancetype)QuestionCellInTableView:(UITableView *)tableView;

/**
 *  cell高度自动适应label内容
 *
 *  @param text label内容
 */
-(void)cellAutoLayoutHeight:(NSString *)text;

@property (weak, nonatomic) IBOutlet XXButton *shieldBtn;

@property (nonatomic, strong) XXQuestion *question;
@property (nonatomic, weak) XXQuestionToolbar *toolBar;
@end
