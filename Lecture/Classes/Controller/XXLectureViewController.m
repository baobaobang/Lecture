//
//  XXLectureViewController.m
//  Lecture
//
//  Created by 陈旭 on 16/1/7.
//  Copyright © 2016年 陈旭. All rights reserved.
//

#import "XXLectureViewController.h"
#import "XXPlayerView.h"

@interface XXLectureViewController ()
@property (weak, nonatomic) IBOutlet XXPlayerView *playerView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation XXLectureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"公益讲堂";
    XXPlayerView *playerView = [XXPlayerView playerView];
    [self.playerView addSubview:playerView];
}



@end
