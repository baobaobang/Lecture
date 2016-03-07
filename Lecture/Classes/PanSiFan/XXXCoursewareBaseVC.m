//
//  ViewController.m
//  Upload
//
//  Created by mortal on 16/1/11.
//  Copyright © 2016年 禾医健康科技. All rights reserved.
//

#import "XXXCoursewareBaseVC.h"
#import "XXXOnlineCoursewareVC.h"
#import "TipView.h"
#import "XXXCourseWareCell.h"
#import "Transcoder.h"
#import "RecordButton.h"
@interface XXXCoursewareBaseVC ()<TipViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate>
@property (nonatomic, strong) UIButton *addBtn;//添加页面的按钮
@property (nonatomic, strong) XXXOnlineCoursewareVC *curVC;//当前操作的view
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataArray;


@end

@implementation XXXCoursewareBaseVC


- (void)viewDidLoad{
    [super viewDidLoad];
    self.titleLabel.text = @"编辑讲座";
    //self.navRightView.image = [UIImage imageNamed:@"saveIcon"];
    self.view.backgroundColor = [UIColor whiteColor];
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0,0, SWIDTH, SHEIGHT) collectionViewLayout:[self flowLayout]];
    collectionView.pagingEnabled = YES;
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.backgroundColor = [UIColor whiteColor];
    [collectionView registerClass:[XXXCourseWareCell class] forCellWithReuseIdentifier:@"CourseWareCell"];
    
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;
    
    [self.view bringSubviewToFront:self.nav];
    
    if (self.fromDraft) {
        [self setTips];
    }else{
        if (self.lectureModel.pages.count== 0) {
            [NetworkManager getWithApi:[NSString stringWithFormat:@"lectures/%@",self.lectureModel.lectureId] params:nil success:^(id result) {
                self.lectureModel = [XXXLectureModel mj_objectWithKeyValues:result[@"data"][@"lecture"]];
                [self setTips];
            } fail:^(NSError *error) {
                
            }];
        }else{
            [self setTips];
        }
    }
    
//    if (!self.fromDraft) {
//        self.navRightView.alpha = 0;
//    }
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, SHEIGHT-50, SWIDTH, 50)];
    [button addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundImage:[UIImage imageNamed:@"save"] forState:0];
    [button setTitleColor:[UIColor whiteColor] forState:0];
    [button setTitle:@"保存" forState:0];
    [self.view addSubview:button];
}

#pragma collectionView 代理
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.lectureModel.pages.count;
    //return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuseStr = @"CourseWareCell";
    XXXCourseWareCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseStr forIndexPath:indexPath];
    cell.viewController.pageModel = self.lectureModel.pages[indexPath.row];
    cell.viewController.supperVC = self;
    return cell;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(SWIDTH, SHEIGHT);
}

- (UICollectionViewFlowLayout *) flowLayout{ UICollectionViewFlowLayout *flowLayout =
    [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing =.0f;
    flowLayout.minimumInteritemSpacing = .0f;
    flowLayout.itemSize = CGSizeMake(SWIDTH, SHEIGHT);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.sectionInset = UIEdgeInsetsZero;
    return flowLayout;
}

/**
 *  标签内容联动
 *
 *  @param scrollView
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSArray *indexPaths = [self.collectionView indexPathsForVisibleItems];    NSIndexPath *indexPath = [indexPaths lastObject];
    for (TipView *sender in self.titleTips.subviews) {
        if (sender.tag-1001 == indexPath.row) {
            [self tipView:sender clickAtIndex:indexPath.row];
        }
    }
}

- (void)clickAddPage{
    
    if([AudioTool shareAudioTool].recorder.recording){
        [SVProgressHUD showInfoWithStatus:@"请先停止录音"];
        
        
        return;
    }
    
    XXXLecturePageModel *page = [[XXXLecturePageModel alloc]init];
    page.lectureId = self.lectureModel.lectureId;
    page.pageNo = self.lectureModel.pages.count+1;
    [self.lectureModel.pages addObject:page];
    [self.collectionView reloadData];
    [self addpage:page];
}

/**
 *  添加页
 *
 *  @param pageModel 单页模型  如果为nil 则添加空页
 */
- (void)addpage:(XXXLecturePageModel *)pageModel{
    NSInteger index = [self.lectureModel.pages indexOfObject:pageModel];
    TipView *button = [[TipView alloc]initWithFrame:CGRectMake(3+(53*index),0, 50, 30)];
    button.tag = pageModel.pageNo+1000;
    button.delegate = self;
    button.selected = YES;
    [button setTitle:[NSString stringWithFormat:@"%ld",(long)pageModel.pageNo] forState:0];
    for (UIView *v in _titleTips.subviews) {
        if ([v isKindOfClass:[TipView class]]) {
            ((TipView *)v).selected = NO;
        }
    }
    
    [self selectPage:button];
    [self.titleTips addSubview:button];
    [button shadow];
    
    _addBtn.frame = CGRectOffset(_addBtn.frame, 53, 0);
    self.titleTips.contentSize = CGSizeMake(CGRectGetMaxX(_addBtn.frame), 30);
    
    [self.view bringSubviewToFront:_titleTips];
}

/**
 *  选择某一页
 *
 *  @param sender
 */
- (void)selectPage:(UIButton *)sender{
   NSLog(@"%ld----------------",(long)sender.tag);
    
    if([AudioTool shareAudioTool].recorder.recording){
        [SVProgressHUD showInfoWithStatus:@"请先停止录音"];
        for (UIView *v in _titleTips.subviews) {
            if ([v isKindOfClass:[TipView class]]) {
                NSLog(@"%d",(long)v.tag==(long)self.curPage + 1000);
                if (v.tag == self.curPage + 1000) {
                    ((TipView *)v).selected = YES;
                }else{
                    ((TipView *)v).selected = NO;
                }
                
                
            }
        }
        return;
    }
    
    [[AudioTool shareAudioTool].streamPlayer pause];
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:sender.tag-1001 inSection:0];
    NSLog(@"%ld------%ld",(long)sender.tag,(long)indexPath.row);
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
    
    self.curPage = sender.tag - 1000;
}

/**
 *  点击标签
 *
 *  @param tipView 标签
 *  @param index   index
 */
- (void)tipView:(TipView *)tipView clickAtIndex:(NSInteger)index{
    
    
    //self.curPage = index-1000;
    for (UIView *v in _titleTips.subviews) {
        if ([v isKindOfClass:[TipView class]]) {
            ((TipView *)v).selected = NO;
        }
    }
    tipView.selected = YES;
    [self selectPage:tipView];
    [self.view bringSubviewToFront:_titleTips];
    
}


/**
 *  处理标签逻辑
 */
- (void)setTips{
    if (self.lectureModel.pages.count == 0 ) {
        XXXLecturePageModel *page = [[XXXLecturePageModel alloc]init];
        NSLog(@"%@",page);
        page.lectureId = self.lectureModel.lectureId;
        page.pageNo = 1;
        [self.lectureModel.pages addObject:page];
    }
    [self.collectionView reloadData];
    for (XXXLecturePageModel *page in self.lectureModel.pages) {
        page.lectureId = self.lectureModel.lectureId;
        [self addpage:page];
    }
    
}


/**
 *  导航右按钮
 */
//- (void)navRightAcion{
//    NSString *document = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
//    for (XXXLecturePageModel *pageModel in self.lectureModel.pages) {
//        NSLog(@">>>>>>>>>>>>>>>>>>>>>>>>>>%@",pageModel);
//        NSString *path = [document stringByAppendingPathComponent:[NSString stringWithFormat:@"%@lecture%@page%ld.wav",[NSDate date],pageModel.lectureId,(long)pageModel.pageNo]];
//        NSLog(@"%@",path);
//        [self executeVoices:pageModel toPath:path];
//        pageModel.audio = path;
//    }
//    
//
//    //NSLog(@"%d", [self.lectureModel save]);
//
//    
//    if ([self.lectureModel save]) {
//        [SVProgressHUD showSuccessWithStatus:@"已保存到草稿箱"];
//        [self dismissViewControllerAnimated:YES completion:nil];
//    }else{
//        [SVProgressHUD showErrorWithStatus:@"保存失败"];
//    }
//}

//- (void)executeVoices:(XXXLecturePageModel *)pageModel toPath:(NSString *)toPath{
//    NSLog(@"id%@>>>>>>>>>>>>%ld>>>>>>%@",pageModel.lectureId,(unsigned long)pageModel.localUrls.count,pageModel.audio);
////    NSString *document = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
////    NSString *path = [document stringByAppendingPathComponent:@"lectureTemp.wav"];
////     NSString *path = [document stringByAppendingPathComponent:[NSString stringWithFormat:@"%@lecture%@page%ld.wav",[NSDate date],pageModel.lectureId,(long)pageModel.pageNo]];
//    if (pageModel.localUrls.count>0) {
//        NSString *first = pageModel.localUrls.firstObject;
//        if ([first hasPrefix:@"http"]) {
//            [pageModel.localUrls removeObject:first];
//        }
//        NSLog(@"%@",toPath);
//        for (NSString *url in pageModel.localUrls) {
//            NSLog(@"%@",url);
//        }
//        [Transcoder concatFiles:pageModel.localUrls to:toPath];
//        //[Transcoder transcodeToMP3From:path toPath:toPath];
//    }
//}
/**
 *  懒加载标签
 *
 *  @return
 */
- (UIScrollView *)titleTips{
    if (!_titleTips) {
        _titleTips = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64,SWIDTH , 30)];
        _titleTips.showsHorizontalScrollIndicator = NO;
        _titleTips.backgroundColor = [UIColor whiteColor];
        _titleTips.contentSize = CGSizeMake(SWIDTH, 30);
//        _addBtn = [[UIButton alloc]initWithFrame:CGRectMake(3,0, 30, 30)];
//        [_addBtn setBackgroundImage:[UIImage imageNamed:@"backimg"] forState:0];
//        //[button setTitle:_pageLabel.text forState:0];
//        [_addBtn addTarget:self action:@selector(clickAddPage) forControlEvents:UIControlEventTouchUpInside];
//        [_titleTips addSubview:_addBtn];
        [self.view addSubview:_titleTips];
       
    }
    return _titleTips;
}

- (void) save{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

@end
