//
//  MCAlbumCreateVC.m
//  LZAlbum
//
//  Created by lzw on 15/4/1.
//  Copyright (c) 2015年 lzw. All rights reserved.
//

#import "LZAlbumCreateVC.h"
#import "XHPhotographyHelper.h"
//#import "LZAlbumManager.h"
#import "LZAlbumPhotoCollectionViewCell.h"
//#import "AppDelegate.h"

static CGFloat kLZAlbumCreateVCPhotoSize = 60; // 每张图片的大小
static NSUInteger kLZAlbumPhotosLimitCount = 9; // 图片的数量限制

@interface LZAlbumCreateVC ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

/**
 *  文字容器
 */
@property (weak, nonatomic) IBOutlet UITextField *contentTextField;

/**
 *  图片容器
 */
@property (weak, nonatomic) IBOutlet UICollectionView *photoCollectionView;

/**
 *  选中的照片组
 */
@property (nonatomic,strong) NSMutableArray* selectPhotos;

@property (strong,nonatomic) XHPhotographyHelper* photographyHelper;

@end

static NSString* photoCellIndentifier = @"photoCellIndentifier";

@implementation LZAlbumCreateVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=@"提问";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(createFeed)];
    
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(dismiss)];
    
    [self.photoCollectionView registerClass:[LZAlbumPhotoCollectionViewCell class] forCellWithReuseIdentifier:photoCellIndentifier];
}

#pragma mark - 取消提问
-(void)dismiss{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 发送提问
-(void)createFeed{
    if(self.contentTextField.text.length!=0){
        WEAKSELF
        [self showProgress];
        [self runInGlobalQueue:^{
            NSError* error;
            //TODO: 点击发送后的异步网络处理
//            [[LZAlbumManager manager] createAlbumWithText:self.contentTextField.text photos:self.selectPhotos error:&error];
            [weakSelf runInMainQueue:^{ // 刷新精选提问界面
                [weakSelf hideProgress];
                if(error==nil){
//                    [_albumVC refresh];//TODO:
                    [weakSelf dismiss];
                }else{
                    [weakSelf alertError:error];
                }
            }];
        }];
    }else{
        [self alert:@"文字不能为空！"];
    }
}

#pragma mark - Propertys
-(XHPhotographyHelper*)photographyHelper{
    if(_photographyHelper==nil){
        _photographyHelper=[[XHPhotographyHelper alloc] init];
    }
    return _photographyHelper;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(NSMutableArray*)selectPhotos{
    if(_selectPhotos==nil){
        _selectPhotos=[NSMutableArray array];
    }
    return _selectPhotos;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if(self.selectPhotos.count== kLZAlbumPhotosLimitCount){
        // 如果照片已满就不创建添加按钮的cell
        return self.selectPhotos.count;
    }else{
        return self.selectPhotos.count+1;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    LZAlbumPhotoCollectionViewCell* cell=(LZAlbumPhotoCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:photoCellIndentifier forIndexPath:indexPath];
    if(indexPath.row==self.selectPhotos.count){ // 最后一个cell为加号按钮
        cell.photoImageView.image=[UIImage imageNamed:@"AlbumAddBtn"];
        cell.photoImageView.highlightedImage=[UIImage imageNamed:@"AlbumAddBtnHL"];
        return cell;
    }else{
        cell.photoImageView.image=self.selectPhotos[indexPath.row];
        cell.photoImageView.highlightedImage=nil;
        return cell;
    }
}

#pragma mark - UICollectionViewDelegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row==_selectPhotos.count){ // 点击➕按钮
        //TODO: 现在只能从相册中选取图片，等会添加照相
        [self.photographyHelper showOnPickerViewControllerSourceType:
         UIImagePickerControllerSourceTypePhotoLibrary onViewController:self compled:^(UIImage *image, NSDictionary *editingInfo) {
            if (image) {
                [self addImage:image];
            } else {
                if (!editingInfo)
                    return ;
                image=[editingInfo valueForKey:UIImagePickerControllerOriginalImage];
                if(image){
                    [self addImage:image];
                }
            }
        }];
    }
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(kLZAlbumCreateVCPhotoSize, kLZAlbumCreateVCPhotoSize);
}

-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

#pragma mark - 添加一张图片
-(void)addImage:(UIImage*)image{
    [self.selectPhotos addObject:image];
    [self.photoCollectionView reloadData];
}


@end
