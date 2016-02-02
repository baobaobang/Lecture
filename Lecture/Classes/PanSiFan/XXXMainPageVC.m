//
//  XXXMainPageVC.m
//  lecture
//
//  Created by mortal on 16/1/26.
//  Copyright © 2016年 禾医健康科技. All rights reserved.
//

#import "XXXMainPageVC.h"
#import "XXXCoursewareBaseVC.h"
#import "MainPageLectureCell.h"
#import "XXXMakeLectureView.h"
@interface XXXMainPageVC ()<XXXMakeLectureViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation XXXMainPageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    XXXMakeLectureView *mlv = [[XXXMakeLectureView alloc]initWithFrame:CGRectMake(0, SHEIGHT-200, SWIDTH, 200)];
    mlv.delegate = self;
    [self.view addSubview:mlv];
    
    [self getLectures];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getLectures{
//    [NetworkManager requestWithApi:<#(NSString *)#> params:<#(NSDictionary *)#> success:<#^(id result)successBlock#> fail:<#^(NSError *error)failBlock#>]
}
#pragma -tableView代理,数据源

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    return 0;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return [MainPageLectureCell cellForTableView:tableView with:nil];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)XXXMakeLectureView:(XXXMakeLectureView *)mlview clickedIndex:(NSInteger)index{
    switch (index) {
        case 0:
        {
            XXXCoursewareBaseVC *cb = [[XXXCoursewareBaseVC alloc]init];
            [self presentViewController:cb animated:YES completion:nil];
        }
            break;
        case 1:
            
            break;
        case 2:
            
            break;
        case 3:
            
            break;
        default:
            break;
    }
}
@end
