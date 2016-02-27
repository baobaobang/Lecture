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
#import "UITableView+FDTemplateLayoutCell.h"
#import "MJExtension.h"


#define XXExpertProfileCellHeight 80
static NSString * const expertProfileCellReuseId = @"expertProfileCell";

@interface XXExpertProfileVC ()
@end

@implementation XXExpertProfileVC

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

    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    XXExpertProfileCell *expertCell = [tableView dequeueReusableCellWithIdentifier:expertProfileCellReuseId forIndexPath:indexPath];
    [self configureCell:expertCell atIndexPath:indexPath];
    
    return expertCell;
}

- (void)configureCell:(XXExpertProfileCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.lecture = self.lecture;
}
#pragma mark - cell的高度(自适应高度)
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WS(weakSelf);
    return [tableView fd_heightForCellWithIdentifier:expertProfileCellReuseId cacheByIndexPath:indexPath configuration:^(XXExpertProfileCell *cell) {
        // configurations
        [weakSelf configureCell:cell atIndexPath:indexPath];
    }];
}

- (void)dealloc{

}


@end
