//
//  XXExpertProfileVC.m
//  Lecture
//
//  Created by 陈旭 on 16/1/20.
//  Copyright © 2016年 陈旭. All rights reserved.
//

#import "XXExpertProfileVC.h"
#import "XXExpert.h"
#import "XXExpertProfileCell.h"
#import <UITableView+FDTemplateLayoutCell.h>
#import <MJExtension.h>


#define XXExpertProfileCellHeight 80
static NSString * const expertProfileCellReuseId = @"expertProfileCell";

@interface XXExpertProfileVC ()
// 模型数据组
@property (nonatomic, strong) NSArray *experts;
@end

@implementation XXExpertProfileVC


- (NSArray *)experts
{
    if (!_experts) {
        _experts = [XXExpert mj_objectArrayWithFilename:@"Experts.plist"];
    }
    return _experts;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"XXExpertProfileCell" bundle:nil] forCellReuseIdentifier:expertProfileCellReuseId];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.experts.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    XXExpertProfileCell *expertCell = [tableView dequeueReusableCellWithIdentifier:expertProfileCellReuseId forIndexPath:indexPath];
    expertCell.expert = self.experts[indexPath.row];
    
    return expertCell;
}

#pragma mark - cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [tableView fd_heightForCellWithIdentifier:expertProfileCellReuseId cacheByIndexPath:indexPath configuration:^(XXExpertProfileCell *cell) {
        // configurations
    }];
    
}


@end
