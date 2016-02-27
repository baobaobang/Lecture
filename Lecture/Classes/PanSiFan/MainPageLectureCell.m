//
//  MainPageLectureCell.m
//  lecture
//
//  Created by mortal on 16/1/29.
//  Copyright © 2016年 禾医健康科技. All rights reserved.
//

#import "MainPageLectureCell.h"
#import "XXXLectureModel.h"
#import "DateFormatter.h"

@interface MainPageLectureCell()
@property (weak, nonatomic) IBOutlet UIImageView *titleImageView;
@property (weak, nonatomic) IBOutlet UIImageView *expertBar;
@property (weak, nonatomic) IBOutlet UIImageView *avatarView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeCount;// 讲座倒计时
@property (nonatomic, strong) NSTimer *timer;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;// 讲座主题
@property (nonatomic, strong) XXXLectureModel *lectureModel;
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
    self.lectureModel = lectureModel;
    [self.timer invalidate];
    [self.titleImageView sd_setImageWithURL:[NSURL URLWithString:lectureModel.cover] placeholderImage:[UIImage imageNamed:@""]];
    [self.avatarView sd_setImageWithURL:[NSURL URLWithString:lectureModel.headPic] placeholderImage:[UIImage imageNamed:@""]];
    self.nameLabel.text = [NSString stringWithFormat:@"%@",lectureModel.name];
    self.descLabel.text = lectureModel.jobTitle;
    self.timeLabel.text = lectureModel.startDate;
    NSDate *date = [DateFormatter dateFromString:lectureModel.startDate];
    NSString *dateStr = [DateFormatter formatDate:date pattern:@"MM月dd日 HH:mm EE"];
    self.timeLabel.text = dateStr;
    self.titleLabel.text = lectureModel.title;
    //self.titleLabel.text = @"哈哈哈哈哈哈哈哈哈哈";
    [self.titleLabel sizeToFit];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(timeCountAction) userInfo:nil repeats:YES];
    [self.timer fire];
}

- (void)timeCountAction{
    NSDate *startDate = [DateFormatter dateFromString:self.lectureModel.startDate];
    NSTimeInterval sec = [startDate timeIntervalSinceDate:[NSDate date]];
    //NSLog(@"%f",sec);
    if (sec > 0) {
        int s = ((long long)sec)%60;
        int m = (((long long)sec)/60)%60;
        int h = (((long long)sec)/3600)%24;
        int d = ((long long)sec)/3600/24;
        
        NSString *timeStr = [NSString stringWithFormat:@"距开讲 %d天%d小时",d,h];
        
        self.timeCount.text = timeStr;
    }else{
        self.timeCount.text = @"";
    }
}
@end
