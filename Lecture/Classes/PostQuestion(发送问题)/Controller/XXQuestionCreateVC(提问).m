//
//  XXQuestionCreateVC.m
//  Lecture
//
//  Created by 陈旭 on 16/1/24.
//  Copyright © 2016年 陈旭. All rights reserved.
//

#import "XXQuestionCreateVC.h"
#import "XHPhotographyHelper.h"
//#import "XXQuestionManager.h"
#import "XXQuestionPhotoCollectionViewCell.h"
//#import "AppDelegate.h"
#import "CXTextView.h"
#import "XXQuestion.h"
#import "XXQuestionFrame.h"
#import <MJExtension.h>
#import "XXQuestionPhoto.h"
#import "LGPhoto.h"
#import "ZLCameraImageView.h"

static CGFloat kXXQuestionCreateVCPhotoSize = 60; // 每张图片的大小
static NSUInteger kXXQuestionPhotosLimitCount = 3; // 图片的数量限制

@interface XXQuestionCreateVC ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UINavigationControllerDelegate,  UIImagePickerControllerDelegate, UIAlertViewDelegate, UIActionSheetDelegate,LGPhotoPickerViewControllerDelegate,LGPhotoPickerBrowserViewControllerDataSource,LGPhotoPickerBrowserViewControllerDelegate, ZLCameraImageViewDelegate>

/**
 *  文字容器
 */
@property (weak, nonatomic) IBOutlet CXTextView *textView;

/**
 *  图片展示容器
 */
@property (weak, nonatomic) IBOutlet UICollectionView *photoCollectionView;

/**
 *  要发送的所有图片
 */
@property (nonatomic,strong) NSMutableArray* selectPhotos;

@property (strong,nonatomic) XHPhotographyHelper* photographyHelper;

@property (nonatomic, assign) LGShowImageType showType;

@property (nonatomic, strong)NSMutableArray *LGPhotoPickerBrowserPhotoArray;

@end

static NSString* photoCellIndentifier = @"photoCellIndentifier";

@implementation XXQuestionCreateVC

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
    
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
}

- (void)setupTextView{
    _textView.placeholder = @"每人只能提一个问题，请珍惜！";
    
    // 文字改变的通知
    [XXNotificationCenter addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:_textView];
    
    // 删除文字的通知
    [XXNotificationCenter addObserver:self selector:@selector(textDidDelete) name:XXTextDidDeleteNotification object:nil];
}

- (void)setupPhotoCollectionView{
    
    [self.photoCollectionView registerClass:[XXQuestionPhotoCollectionViewCell class] forCellWithReuseIdentifier:photoCellIndentifier];
    
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

#pragma mark - 点击发送按钮，发送提问
-(void)createFeed{
    
    // 先用本地数据替代
    [self saveNewQuestion]; // 保存数据
    [self refreshQuestionVc]; // 刷新页面
    
    //TODO: 点击发送后的异步网络处理
//    if(self.contentTextField.text.length!=0 || self.selectPhotos.count!=0){
//        WEAKSELF
//        [self showProgress];
//        [self runInGlobalQueue:^{
//            NSError* error;
//            [[XXQuestionManager manager] createAlbumWithText:self.contentTextField.text photos:self.selectPhotos error:&error];
//            [weakSelf runInMainQueue:^{
//                [weakSelf hideProgress];
//                if(error==nil){
//                    [_albumVC refresh];
//                    [weakSelf dismiss];
//                }else{
//                    [weakSelf alertError:error];
//                }
//            }];
//        }];
//    }else{
//        [self alert:@"请完善内容"];
//    }
}


#pragma mark - 这一部分以后放到XXQuestionVC中，用通知来做，属性的耦合性太强
//TODO:这一部分以后放到XXQuestionVC中，用通知来做，属性的耦合性太强
- (void)saveNewQuestion{
    
    [self showProgress];
    
    // 创建新的question模型
    XXQuestion *question = [[XXQuestion alloc] init];
    
    // 先将图片保存到本地 //TODO: 上传到服务器
    NSMutableArray *pic_urlsM = [[NSMutableArray alloc] init];
    NSUInteger count = self.selectPhotos.count;
    for (NSUInteger i = 0; i < count; i++) {
        UIImage *image = self.selectPhotos[i];
        NSString *urlStr = [image saveInSandBoxWithIndex:i];
        XXQuestionPhoto *photo = [[XXQuestionPhoto alloc] init];
        photo.thumbnail_pic = urlStr;
        photo.highQuality_pic = urlStr;
        [pic_urlsM addObject:photo];
    }
    question.pic_urls = pic_urlsM;
    
    question.text = self.textView.text;

    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMddHHmmss"];
    question.created_at = [formatter stringFromDate:[NSDate date]];
    
    question.shares_count = 0;
//    question.digUsers = [NSMutableArray array];
    
    
    NSMutableArray *questions = [self questionsWithQuestionFrames:self.questionVC.questionFrames];
    
    // 让当前用户为数组中最后一个问题的用户
    XXQuestion *lastQuestion = [questions lastObject];
    question.user = lastQuestion.user;
    
    // 将新question插入到数组最前面
    [questions insertObject:question atIndex:0];
    
    // 将模型数组转换为字典数组，再重新写入plist
    // 方式一：从document目录下加载plist
//    NSString *docmentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
//    NSString *plistPath = [docmentPath stringByAppendingPathComponent:@"Questions.plist"];
    
    // 方式二：从mainBundle目录下加载plist
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Questions.plist" ofType:nil];
    [[NSMutableArray mj_keyValuesArrayWithObjectArray:questions] writeToFile:plistPath atomically:YES];
}

/**
 *  将XXQuestionFrame模型转为XXQuestion模型
 */
- (NSMutableArray *)questionsWithQuestionFrames:(NSArray *)questionFrames
{
    NSMutableArray *questions = [NSMutableArray array];
    for (XXQuestionFrame *frame in questionFrames) {
        [questions addObject:frame.question];
    }
    return questions;
}

// 发送成功后
- (void)refreshQuestionVc{
    
    // 因为修改了plist，需要从本地重新加载数据，再刷新精选提问界面
    self.questionVC.questionFrames = [self.questionVC loadDataFromPlist];
    [self.questionVC.tableView reloadData];
    
    // 模拟网络延时，提示发送成功
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self hideProgress];
        [self showHUDText:@"发送成功！"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self dismiss];
        });
    });
}

#pragma mark - 取消提问

- (void)cancel{
    UIAlertView *alertView=[[UIAlertView alloc]
                            initWithTitle:@"退出此次编辑？" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"退出", nil];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) { // 点击退出
        [self dismiss];
    }
}

#pragma mark - 退出控制器
-(void)dismiss{
    [self dismissViewControllerAnimated:YES completion:nil];
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
    
    if(self.selectPhotos.count== kXXQuestionPhotosLimitCount){
        // 如果照片已满就不创建添加按钮的cell
        return self.selectPhotos.count;
    }else{
        return self.selectPhotos.count+1;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    XXQuestionPhotoCollectionViewCell* cell=(XXQuestionPhotoCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:photoCellIndentifier forIndexPath:indexPath];
    if(indexPath.row==self.selectPhotos.count){ // 最后一个cell为加号按钮
        cell.photoImageView.image=[UIImage imageNamed:@"AlbumAddBtn"];
        cell.photoImageView.highlightedImage=[UIImage imageNamed:@"AlbumAddBtnHL"];
        cell.photoImageView.deleBjView.hidden= YES;
        return cell;
    }else{
        cell.photoImageView.image=self.selectPhotos[indexPath.row];
        cell.photoImageView.highlightedImage=nil;
        cell.photoImageView.deleBjView.hidden = NO; //显示红叉
        cell.photoImageView.delegatge = self; // 设置代理，点红叉才能删除
        return cell;
    }
}

#pragma mark - UICollectionViewDelegate


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.textView resignFirstResponder];
    
    if(indexPath.row==_selectPhotos.count){ // 点击➕按钮
        //TODO: 现在只能从相册中选取图片，等会添加照相
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照-单拍", @"拍照-连拍",@"从手机相册中选取", nil];
        // iOS8下面属性设置无效
//        sheet.actionSheetStyle =  UIActionSheetStyleBlackOpaque;
        [sheet showInView:self.view];
        
    }else{ // 点击小图
        // 给照片浏览器传image的时候先包装成LGPhotoPickerBrowserPhoto对象
        [self prepareForPhotoBroswerWithImage];
        // 调出图片浏览器
        [self pushPhotoBroswerWithStyle:LGShowImageTypeImageBroswer];
    }
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(kXXQuestionCreateVCPhotoSize, kXXQuestionCreateVCPhotoSize);
}

-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

#pragma mark - UIActionSheetDelegate 判断从哪里选取图片，相册还是相机
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{

    if (buttonIndex == 0) { // 拍照-单拍
        [self presentCameraSingle];
    }else if(buttonIndex == 1){ // 拍照-连拍
        [self presentCameraContinuous];
    }else if(buttonIndex == 2){ // 从相册中选取
        [self presentPhotoPickerViewControllerWithStyle:LGShowImageTypeImageBroswer];
    }else{
        
    }
}

// 修改ActionSheet的字体颜色，iOS8下面属性设置无效
//- (void)willPresentActionSheet:(UIActionSheet *)actionSheet
//{
//    for (UIView *subView in actionSheet.subviews) {
//        if ([subView isKindOfClass:[UIButton class]]) {
//            UIButton *button = (UIButton*)subView;
//            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        }
//    }
//}

#pragma mark - LGPhotoBrowser(图片浏览器，相册选取器，单拍和连拍)

/**
 *  给照片浏览器传image的时候先包装成LGPhotoPickerBrowserPhoto对象
 */
- (void)prepareForPhotoBroswerWithImage {
    self.LGPhotoPickerBrowserPhotoArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.selectPhotos.count; i++) {
        LGPhotoPickerBrowserPhoto *photo = [[LGPhotoPickerBrowserPhoto alloc] init];
        photo.photoImage = self.selectPhotos[i];
        [self.LGPhotoPickerBrowserPhotoArray addObject:photo];
    }
}

/**
 *  初始化图片浏览器
 */
- (void)pushPhotoBroswerWithStyle:(LGShowImageType)style{
    LGPhotoPickerBrowserViewController *BroswerVC = [[LGPhotoPickerBrowserViewController alloc] init];
    BroswerVC.delegate = self;
    BroswerVC.dataSource = self;
    BroswerVC.showType = style;
    self.showType = style;
    [self presentViewController:BroswerVC animated:YES completion:nil];
}

/**
 *  初始化相册选择器 LGPhotoPickerViewController
 */
- (void)presentPhotoPickerViewControllerWithStyle:(LGShowImageType)style {
    LGPhotoPickerViewController *pickerVc = [[LGPhotoPickerViewController alloc] initWithShowType:style];
    pickerVc.status = PickerViewShowStatusCameraRoll; // 默认进入相机胶卷
    pickerVc.maxCount = kXXQuestionPhotosLimitCount - self.selectPhotos.count;   // 最多能选图片的张数
    pickerVc.delegate = self;
    [pickerVc showPickerVc:self];
}

/**
 *  初始化自定义相机（单拍）
 */
- (void)presentCameraSingle {
    ZLCameraViewController *cameraVC = [[ZLCameraViewController alloc] init];
    // 拍照最多个数
    cameraVC.maxCount = 1;
    // 单拍
    cameraVC.cameraType = ZLCameraSingle;
    cameraVC.callback = ^(NSArray *cameras){
        //在这里得到拍照结果
        //数组元素是ZLCamera对象
         ZLCamera *cameraPhoto = cameras[0];
         UIImage *image = cameraPhoto.photoImage;
        [self.selectPhotos addObject:image];
        [self showPhotos];
    };
    [cameraVC showPickerVc:self];
}

/**
 *  初始化自定义相机（连拍）
 */
- (void)presentCameraContinuous {
    ZLCameraViewController *cameraVC = [[ZLCameraViewController alloc] init];
    // 拍照最多个数
    cameraVC.maxCount = kXXQuestionPhotosLimitCount - self.selectPhotos.count;
    // 连拍
    cameraVC.cameraType = ZLCameraContinuous;
    cameraVC.callback = ^(NSArray *cameras){
        //在这里得到拍照结果
        //数组元素是ZLCamera对象
        for (ZLCamera *cameraPhoto in cameras) {
            UIImage *image = cameraPhoto.photoImage;
            [self.selectPhotos addObject:image];
        }
        [self showPhotos];
    };
    [cameraVC showPickerVc:self];
}

#pragma mark - LGPhotoPickerBrowserViewControllerDataSource
/**
 *  每个组多少个图片
 */
- (NSInteger)photoBrowser:(LGPhotoPickerBrowserViewController *)photoBrowser numberOfItemsInSection:(NSUInteger)section{
    if (self.showType == LGShowImageTypeImageBroswer) {
        return self.LGPhotoPickerBrowserPhotoArray.count;
    } else {
        NSLog(@"非法数据源");
        return 0;
    }
}

/**
 *  每个对应的IndexPath展示什么内容
 */
- (id<LGPhotoPickerBrowserPhoto>)photoBrowser:(LGPhotoPickerBrowserViewController *)pickerBrowser photoAtIndexPath:(NSIndexPath *)indexPath{
    if (self.showType == LGShowImageTypeImageBroswer) {
        return [self.LGPhotoPickerBrowserPhotoArray objectAtIndex:indexPath.item];
    } else {
        NSLog(@"非法数据源");
        return nil;
    }
}

#pragma mark - LGPhotoPickerViewControllerDelegate 返回从相册中选择的所有图片

- (void)pickerViewControllerDoneAsstes:(NSArray *)assets isOriginal:(BOOL)original{

    if (assets) {
        
        for (LGPhotoAssets *asset in assets) {
            UIImage *image = asset.originImage;
            [self.selectPhotos addObject:image];
        }

        [self showPhotos];
    }
    
    // 提醒是否发送原图
    //    NSInteger num = (long)assets.count;
    //    NSString *isOriginal = original? @"YES":@"NO";
    //    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"发送图片" message:[NSString stringWithFormat:@"您选择了%ld张图片\n是否原图：%@",(long)num,isOriginal] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    //    [alertView show];
    
}

#pragma mark - 展示选取或者拍摄的图片
- (void)showPhotos{
    [self.photoCollectionView reloadData];
}

#pragma mark - 点击小图右上角的叉号删除已经展示的小图
- (void)deleteImageView:(ZLCameraImageView *)imageView{
    NSMutableArray *arrM = [self.selectPhotos mutableCopy];
    for (UIImage *image in self.selectPhotos) {
        if ([image isEqual:imageView.image]) {
            [arrM removeObject:image];
        }
    }
    self.selectPhotos = arrM;
    [self.photoCollectionView reloadData];
}

@end
