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
#import "CXTextViewWithPlaceholder.h"

static CGFloat kLZAlbumCreateVCPhotoSize = 60; // 每张图片的大小
static NSUInteger kLZAlbumPhotosLimitCount = 3; // 图片的数量限制

@interface LZAlbumCreateVC ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

/**
 *  文字容器
 */
@property (weak, nonatomic) IBOutlet CXTextViewWithPlaceholder *textView;

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

#pragma mark - 生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置导航栏
    [self setupNav];
    
    // 设置文字
    [self setupTextView];
    
    // 设置图片
    [self setupPhotoCollectionView];
    
}

#pragma mark - 初始化

- (void)setupNav{
    
    self.title=@"提问";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(createFeed)];
    self.navigationItem.rightBarButtonItem.enabled = NO; // 一进入的时候没有文字，因此发送按钮不可用
    
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(dismiss)];
}

- (void)setupTextView{
    _textView.placeholder = @"每人只能提一个问题，请珍惜！";
    
    // 文字改变的通知
    [XXNotificationCenter addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:_textView];
    
    // 删除文字的通知
    [XXNotificationCenter addObserver:self selector:@selector(textDidDelete) name:XXTextDidDeleteNotification object:nil];
}

- (void)setupPhotoCollectionView{
    
    [self.photoCollectionView registerClass:[LZAlbumPhotoCollectionViewCell class] forCellWithReuseIdentifier:photoCellIndentifier];
    
    // 有导航控制器的时候，如果控制器里面只有一个ScrollView，ScrollView就会默认往下调整64
    self.automaticallyAdjustsScrollViewInsets = NO;
}

#pragma mark - 监听TextView的方法
/**
 *  删除文字
 */
- (void)textDidDelete
{
    [self.textView deleteBackward];
}

/**
 * 监听文字改变，没有文字的时候不能发送
 */
- (void)textDidChange
{
    self.navigationItem.rightBarButtonItem.enabled = self.textView.hasText;
}

#pragma mark - 取消提问
-(void)dismiss{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 发送提问
-(void)createFeed{
    if(self.textView.text.length!=0){
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
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    if(self.selectPhotos.count== kLZAlbumPhotosLimitCount){
        // 如果照片已满就不创建添加按钮的cell
        return self.selectPhotos.count;
    }else{
        return self.selectPhotos.count+1;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
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

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
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
