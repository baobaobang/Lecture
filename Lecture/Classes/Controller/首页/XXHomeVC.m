//
//  XXHomeVC.m
//  Lecture
//
//  Created by 陈旭 on 16/1/22.
//  Copyright © 2016年 陈旭. All rights reserved.
//

#import "XXHomeVC.h"
#import "XXLectureHomeVC.h"
#import "XXLectureJoinVC.h"

@interface XXHomeVC ()

@end

@implementation XXHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *beforeBtn = [[UIButton alloc] init];
    beforeBtn.backgroundColor = XXColorTint;
    [beforeBtn setTitle:@"讲座前" forState:UIControlStateNormal];
    beforeBtn.frame = CGRectMake(40, 80, 60, 40);
    [beforeBtn addTarget:self action:@selector(toJoinLecture) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:beforeBtn];
    
    UIButton *lectureBtn = [[UIButton alloc] init];
    lectureBtn.backgroundColor = XXColorTint;
    [lectureBtn setTitle:@"讲座中" forState:UIControlStateNormal];
    lectureBtn.frame = CGRectMake(40, 160, 60, 40);
    [lectureBtn addTarget:self action:@selector(toLecture) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:lectureBtn];

    
}


- (void)toJoinLecture{
    XXLectureJoinVC *vc = [[XXLectureJoinVC alloc] init];
    vc.view.frame = self.view.bounds;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)toLecture{
    XXLectureHomeVC *vc = [[XXLectureHomeVC alloc] init];
    vc.view.frame = self.view.bounds;
    [self.navigationController pushViewController:vc animated:YES];
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationVC].
    // Pass the selected object to the new view controller.
}
*/

@end
