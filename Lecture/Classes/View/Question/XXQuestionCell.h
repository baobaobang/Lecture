//
//  XXQuestionCell.h
//  Lecture
//
//  Created by 陈旭 on 16/1/10.
//  Copyright © 2016年 陈旭. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XXQuestion, XXQuestionToolbar, XXQuestionFrame;

@interface XXQuestionCell : UITableViewCell

@property (nonatomic, weak) XXQuestionToolbar *toolbar;

@property (nonatomic, strong) XXQuestionFrame *questionFrame;
@end
