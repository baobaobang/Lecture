//
//  MainPageLectureCell.h
//  lecture
//
//  Created by mortal on 16/1/29.
//  Copyright © 2016年 禾医健康科技. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XXXLectureModel;
@interface MainPageLectureCell : UITableViewCell

+(instancetype)cellForTableView:(UITableView *)tableView with:(XXXLectureModel *) lecutreModel;

@end
