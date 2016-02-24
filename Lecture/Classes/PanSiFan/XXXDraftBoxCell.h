//
//  XXXDraftBoxCell.h
//  Lecture
//
//  Created by mortal on 16/2/15.
//  Copyright © 2016年 陈旭. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XXXLectureModel;

@protocol XXXDraftBoxCellDelegate <NSObject>

- (void)editLecture:(XXXLectureModel *)model;

@end

@interface XXXDraftBoxCell : UITableViewCell
@property (nonatomic, weak) id<XXXDraftBoxCellDelegate> delegate;
@property (nonatomic, strong) XXXLectureModel *lectureModel;
@property (weak, nonatomic) IBOutlet UIButton *checkBox;
@property (weak, nonatomic) IBOutlet UIButton *edit;

+(instancetype)cellForTableView:(UITableView *)tableView with:(XXXLectureModel *) lecutreModel delegate:(id<XXXDraftBoxCellDelegate>) delegate;


@end
