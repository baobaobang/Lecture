//
//  XXHomeViewController.m
//  Lecture
//
//  Created by 陈旭 on 16/1/22.
//  Copyright © 2016年 陈旭. All rights reserved.
//

#import "XXHomeViewController.h"
#import "XXLectureViewController.h"
#import "XXLectureJoinViewController.h"

@interface XXHomeViewController ()

@end

@implementation XXHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *beforeBtn = [[UIButton alloc] init];
    beforeBtn.backgroundColor = XXTintColor;
    [beforeBtn setTitle:@"讲座前" forState:UIControlStateNormal];
    beforeBtn.frame = CGRectMake(40, 80, 60, 40);
    [beforeBtn addTarget:self action:@selector(toJoinLecture) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:beforeBtn];
    
    UIButton *lectureBtn = [[UIButton alloc] init];
    lectureBtn.backgroundColor = XXTintColor;
    [lectureBtn setTitle:@"讲座中" forState:UIControlStateNormal];
    lectureBtn.frame = CGRectMake(40, 160, 60, 40);
    [lectureBtn addTarget:self action:@selector(toLecture) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:lectureBtn];

    
}


- (void)toJoinLecture{
    XXLectureJoinViewController *vc = [[XXLectureJoinViewController alloc] init];
    vc.view.frame = self.view.bounds;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)toLecture{
    XXLectureViewController *vc = [[XXLectureViewController alloc] init];
    vc.view.frame = self.view.bounds;
    [self.navigationController pushViewController:vc animated:YES];
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
