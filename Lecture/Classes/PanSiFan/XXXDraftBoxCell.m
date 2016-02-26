//
//  XXXDraftBoxCell.m
//  Lecture
//
//  Created by mortal on 16/2/15.
//  Copyright © 2016年 陈旭. All rights reserved.
//

#import "XXXDraftBoxCell.h"
#import "XXXLectureModel.h"
@interface XXXDraftBoxCell()

@property (weak, nonatomic) IBOutlet UIImageView *headPicView;
@property (weak, nonatomic) IBOutlet UILabel *lecTitle;
@property (weak, nonatomic) IBOutlet UILabel *timeAndPage;
@property (weak, nonatomic) IBOutlet UILabel *startDate;

@end
@implementation XXXDraftBoxCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

+(instancetype)cellForTableView:(UITableView *)tableView with:(XXXLectureModel *) lecutreModel delegate:(id<XXXDraftBoxCellDelegate>) delegate{
    static NSString *reuseStr = @"DraftBoxCell";
    XXXDraftBoxCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseStr];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"XXXDraftBoxCell" bundle:nil] forCellReuseIdentifier:reuseStr];
        cell = [tableView dequeueReusableCellWithIdentifier:reuseStr];
        
    }
    cell.delegate = delegate;
    cell.lectureModel = lecutreModel;
    return cell;
}

- (void)setLectureModel:(XXXLectureModel *)lectureModel{
    _lectureModel = lectureModel;
    [self.headPicView sd_setImageWithURL:[NSURL URLWithString:lectureModel.headPic] placeholderImage:[UIImage imageNamed:@""]];
    self.lecTitle.text = [NSString stringWithFormat:@"主题:%@",lectureModel.title];
    self.timeAndPage.text = [NSString stringWithFormat:@"时长:%@ 页数:%ld",@"",(long)lectureModel.pages.count];
    self.startDate.text = lectureModel.startDate;
    
}

- (IBAction)choose:(UIButton *)sender {
    sender.selected = !sender.selected;
}

- (IBAction)edit:(UIButton *)sender {
    [self.delegate editLecture:self.lectureModel];
}
@end
