//
//  MainPageLectureCell.m
//  lecture
//
//  Created by mortal on 16/1/29.
//  Copyright © 2016年 禾医健康科技. All rights reserved.
//

#import "MainPageLectureCell.h"
#import "XXXLectureModel.h"

@interface MainPageLectureCell()
@property (weak, nonatomic) IBOutlet UIImageView *titleImageView;
@property (weak, nonatomic) IBOutlet UIImageView *expertBar;
@property (weak, nonatomic) IBOutlet UIImageView *avatarView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation MainPageLectureCell

- (void)awakeFromNib {
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.frame = self.expertBar.bounds;
    layer.fillColor = [UIColor whiteColor].CGColor;
    //layer.backgroundColor = [UIColor whiteColor].CGColor;
//    layer.borderColor = RGB(87, 220, 147).CGColor;
//    layer.borderWidth = 1;
    [self.expertBar.layer addSublayer:layer];
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *blurView = [[UIVisualEffectView alloc]initWithEffect:blur];
    blurView.frame = self.expertBar.bounds;
    blurView.layer.opacity = 0.95;
    [self.expertBar addSubview:blurView];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+(instancetype)cellForTableView:(UITableView *)tableView with:(XXXLectureModel *) lecutreModel{
    static NSString *reuseStr = @"lectureCell";
    MainPageLectureCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseStr];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"MainPageLectureCell" bundle:nil] forCellReuseIdentifier:reuseStr];
        cell = [tableView dequeueReusableCellWithIdentifier:reuseStr];
    }
    [cell setLectureData:lecutreModel];
    return  cell;
}

-(void)setLectureData:(XXXLectureModel *) lectureModel{
    
}
@end
