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
    
//    XXXMakeLectureView *mlv = [[XXXMakeLectureView alloc]initWithFrame:CGRectMake(0, SHEIGHT-100, SWIDTH, 100)];
    XXXMakeLectureView *mlv = [[XXXMakeLectureView alloc]initWithFrame:CGRectMake(SWIDTH/2-25, SHEIGHT-100, 50, 100)];
    mlv.delegate = self;
    [self.view addSubview:mlv];
    
    [self getLectures];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getLectures{
//    [NetworkManager getWithApi:@"lectures" params:nil success:^(id result) {
//        
//    } fail:^(NSError *error) {
//        
//    }];
//    [NetworkManager getWithApi:@"lectures/1/questions?content=sdasfs&images=d" params:nil success:^(id result) {
//        
//    } fail:^(NSError *error) {
//        
//    }];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://121.42.171.213:3000/lectures/1/questions"]];
    request.HTTPMethod = @"POST";
    NSString *params = @"content=打一顿就好了&images=";
    
    request.HTTPBody = [params dataUsingEncoding:NSUTF8StringEncoding];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
    }];
    
    [task resume];
    
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
