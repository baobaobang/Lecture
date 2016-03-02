//
//  XXXOnlineCoursewareVC.m
//  Upload
//
//  Created by mortal on 16/1/11.
//  Copyright © 2016年 禾医健康科技. All rights reserved.
//

#import "XXXOnlineCoursewareVC.h"

#import "RecordView.h"
#import "Masonry.h"
#import "RecordButton.h"
#import "Transcoder.h"
#import "XXXCoursewareBaseVC.h"
#import "LGPhoto.h"


@interface XXXOnlineCoursewareVC ()<UIActionSheetDelegate,LGPhotoPickerViewControllerDelegate,RecordViewDelegate,RecordStopDelegate,AVAudioPlayerDelegate,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,SelectPageDelegate>

@property (weak, nonatomic) IBOutlet UILabel *pageLabel;//页码
//@property (weak, nonatomic) IBOutlet RecordButton *recordBtn;//录音按钮
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;//保存
@property (weak, nonatomic) IBOutlet UIButton *uploadBtn;//上传
@property (weak, nonatomic) IBOutlet UIButton *addPage;//添加页面
@property (weak, nonatomic) IBOutlet UIButton *endEditBtn;//结束编辑
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;//上传菊花
@property (weak, nonatomic) IBOutlet UIView *seperator;
@property (weak, nonatomic) IBOutlet UITextField *titleLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *seperatorWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *voiceListViewHeight;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;//选择的图片
@property (weak, nonatomic) IBOutlet UIImageView *preViewImageView;//预览
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *voiceListContaner;
@property (weak, nonatomic) IBOutlet UIButton *preView;//

@property (strong, nonatomic) AVAudioRecorder *recorder;//录音机
@property (strong,nonatomic) NSURL *filePath;//录音存放地址
@property (nonatomic, assign) RecorderState state;//录音机状态
@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic, strong) NSMutableArray *voiceUrls;//录音的路径
@property (nonatomic, copy) NSString *courseTitle;//课件主题

@property (nonatomic, strong) NSMutableArray *voiceViews;//
@property (nonatomic, strong) RecordButton *recordingBtn;//正在录音的按钮
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, assign) NSInteger curPlayIndex;
@property (nonatomic, assign) NSInteger playerState;//1-播放 0-暂停
@property (nonatomic, strong) UIImage *chosenImage;

@end



@implementation XXXOnlineCoursewareVC

- (RecordButton *)recordingBtn{
    if (!_recordingBtn) {
        _recordingBtn = [[RecordButton alloc]initWithFrame:CGRectMake(77,179.5, 200, 36)];
        _recordingBtn.delegate = self;
    }
    return _recordingBtn;
}

- (NSMutableArray *)voiceViews{
    if (!_voiceViews) {
        _voiceViews = [NSMutableArray array];
    }
    return _voiceViews;
}

- (NSMutableArray *)voiceUrls{
    if (!_voiceUrls) {
        _voiceUrls = [NSMutableArray array];
    }
    return _voiceUrls;
}


+ (instancetype)onlineCoursewareViewController{
    XXXOnlineCoursewareVC *ocwVC = [[XXXOnlineCoursewareVC alloc]init];
    return ocwVC;
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(preView)];
    [self.preViewImageView addGestureRecognizer:tap2];
    
    UITapGestureRecognizer *imageTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addImage)];
    [_imageView addGestureRecognizer:imageTap];
    
    
    _saveBtn.imageEdgeInsets = UIEdgeInsetsMake(10,0,10,10);
    
    _seperatorWidth.constant = SWIDTH;
    
    _titleLabel.delegate = self;
    
    
    self.recordBtn.pageModel = self.pageModel;
    self.recordBtn.delegate = self;
    
    [self.view bringSubviewToFront:self.saveBtn];
    [self updateVoiceList];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endPreView) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pageSelected:) name:@"SELECTPAGENOTE" object:nil];
    
}

- (void)pageSelected:(NSNotification *)note{
    if ([note.userInfo[@"page"] integerValue] == self.pageModel.pageNo) {
        return;
    }
    if (_recordBtn.recorderState == RecorderStateRecording) {
        [_recordBtn stopRecord];
    }
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.view.frame = CGRectMake(0,94, SWIDTH, SHEIGHT-94);
}
- (void)updateVoiceList{
    
    for (NSInteger i=0;i<self.voiceViews.count;i++){
        ((RecordView *)self.voiceViews[i]).frame = CGRectMake(0,i*40, 200, 40);
    }
    _voiceListViewHeight.constant = 40*(_voiceViews.count);
    _scrollView.contentSize = CGSizeMake(SWIDTH, 540+(40*self.voiceViews.count));
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [_titleLabel resignFirstResponder];
    return YES;
}



/**
 *  保存录音
 *
 *  @param sender
 */
- (void)saveRecord:(NSString *)url {
    RecordView *rv = [RecordView viewWithUrl:url index:self.pageModel.localUrls.count name:self.recordBtn.timeLabel.text];
    rv.delegate = self;
    [self.voiceListContaner addSubview:rv];
    [self.voiceViews addObject:rv];
    [self updateVoiceList];
    
}
/**
 *  删除录音
 *
 *  @param sender
 */
- (IBAction)deleteRecord:(UIButton *)sender {
    [_recorder stop];
    [_recorder deleteRecording];
    _state = RecorderStateStop;
    
    
}

- (void)addImage{
    [self.titleLabel resignFirstResponder];
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"选择照片来源" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"照片",@"拍照", nil];
    [actionSheet showInView:self.view];
    
}

- (void)executeVoices:(NSString *)toPath{
    
    NSString *document = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *path = [document stringByAppendingPathComponent:@"lectureTemp.wav"];
    if (self.pageModel.localUrls.count>0) {
        NSString *first = self.pageModel.localUrls.firstObject;
        if ([first hasPrefix:@"http"]) {
            [self.pageModel.localUrls removeObject:first];
        }
        [Transcoder concatFiles:self.pageModel.localUrls to:path];
        [Transcoder transcodeToMP3From:path toPath:toPath];
    }
}

#pragma 上传
- (IBAction)upload:(id)sender {
    
    if (!self.chosenImage || self.titleLabel.text.length == 0 || (self.pageModel.localUrls.count == 0 && self.pageModel.audio.length == 0)) {
        AlertMessage(@"请将信息填写完整");
        return;
    }
    
    _indicator.hidden = NO;
    [_indicator startAnimating];
    
    
    //TODO: 上传
    NSString *document = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *path = [document stringByAppendingPathComponent:[NSString stringWithFormat:@"%@lecture%@page%ld.mp3",[NSDate date],self.pageModel.lectureId,(long)self.pageModel.pageNo]];
    [self executeVoices:path];

    NSData *data = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:path]];
    
    [NetworkManager qiniuUpload:data progress:^(NSString *key, float percent) {
        [SVProgressHUD showProgress:percent];
        [SVProgressHUD showProgress:percent];
    } success:^(id result) {
        //音频上传成功 开始上传图片
        self.pageModel.audio = result;
        NSData *imageData = UIImageJPEGRepresentation(self.imageView.image, 1);
        [NetworkManager qiniuUpload:imageData progress:^(NSString *key, float percent) {
            [SVProgressHUD showProgress:percent];
        } success:^(id result) {
            self.pageModel.picture = result;
            
            //图片上传成功后添加条目到服务器
            [self addPageTolecture];
        } fail:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"图片上传失败"];
        } isImageType:YES];
    } fail:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"音频上传失败"];
    } isImageType:NO];
}


- (void)addPageTolecture{
    NSDictionary *params = @{@"pageNo":@(self.pageModel.pageNo),
                             @"title":self.titleLabel.text,
                             @"picture":self.pageModel.picture,
                             @"audio":self.pageModel.audio};
    NSString *url = [NSString stringWithFormat:@"lectures/%@/pages",self.pageModel.lectureId];
    [NetworkManager postWithApi:url params:params success:^(id result) {
        if ([result[@"ret"] integerValue] == 0) {
            [SVProgressHUD showSuccessWithStatus:@"上传成功"];
            [self uploadSuccess];
        }
    } fail:^(NSError *error) {
        
    }];
}


- (void)uploadSuccess{
    [_indicator stopAnimating];
    _indicator.hidden = YES;
    UIImageView *successImage = [[UIImageView alloc]initWithFrame:CGRectMake(_indicator.frame.origin.x, _indicator.frame.origin.y, 80, 20)];
    successImage.image = [UIImage imageNamed:@"checkedword"];
    [_scrollView addSubview:successImage];
    [self performSelector:@selector(dismiss:) withObject:successImage afterDelay:2];
}

- (void)dismiss:(UIView *)view{
    [UIView animateWithDuration:0.5 animations:^{
        view.layer.opacity = 0;
    } completion:^(BOOL finished) {
        [view removeFromSuperview];
        [self.supperVC clickAddPage];//添加一个空页
    }];
}

#pragma actionSheet 代理

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 1:
        {
            UIImagePickerController *picker = [[UIImagePickerController alloc]init];
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            picker.delegate = self;
            [self presentViewController:picker animated:YES completion:nil];
        }
            break;
        case 0:
            [self presentPhotoPickerViewControllerWithStyle:LGShowImageTypeImagePicker];
            break;
        default:
            break;
    }
}



- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    self.imageView.image = info[UIImagePickerControllerOriginalImage];
    self.preViewImageView.image = info[UIImagePickerControllerOriginalImage];
    self.chosenImage = info[UIImagePickerControllerOriginalImage];
    self.pageModel.localImage = UIImageJPEGRepresentation(info[UIImagePickerControllerOriginalImage], 1);
    [picker dismissViewControllerAnimated:YES completion:nil];
}


- (void)presentPhotoPickerViewControllerWithStyle:(LGShowImageType)style {
    LGPhotoPickerViewController *pickerVc = [[LGPhotoPickerViewController alloc] initWithShowType:style];
    //pickerVc.status = PickerViewShowStatusCameraRoll;
    pickerVc.maxCount = 1;   // 最多能选9张图片
    pickerVc.delegate = self;
    [pickerVc showPickerVc:self];
}

- (void)pickerViewControllerDoneAsstes:(NSArray *)assets isOriginal:(BOOL)original{
    LGPhotoAssets *as = [assets lastObject];
    UIImage *simage = as.thumbImage;
    self.imageView.image = simage;
    self.preViewImageView.image = simage;
    self.chosenImage = simage;
    self.pageModel.localImage = UIImageJPEGRepresentation(simage, 1);
}

#pragma 删除录音delegate
- (void)deleteAtIndex:(NSInteger)tag{
    NSInteger index = -1;
    for (RecordView *rv in _voiceViews) {
        if (rv.tag == tag) {
            index = [_voiceViews indexOfObject:rv];
        }
    }
    if (index == -1) {
        return;
    }
    if (self.pageModel.localUrls.count>index+1) {
        [self.pageModel.localUrls removeObjectAtIndex:index];
    }
    
    [self.voiceViews removeObjectAtIndex:index];
    [self updateVoiceList];
    [[AudioTool shareAudioTool].streamPlayer pause];
    [[AudioTool shareAudioTool].player stop];
}


- (void)stopRecord:(RecordButton *)button{
    [self saveRecord:[self.pageModel.localUrls lastObject]];
}


- (IBAction)savePage:(UIButton *)sender {

    
}



- (IBAction)preView:(UIButton *)sender {
    
    if (self.pageModel.localUrls.count == 0) {
        [SVProgressHUD showInfoWithStatus:@"没有新录音"];
        return;
    }
    if (_playerState == 1) {
        [_player pause];
        [_preView setBackgroundImage:[UIImage imageNamed:@"play"] forState:0];
        _voiceListContaner.userInteractionEnabled = YES;
        _playerState = 0;
        return;
    }

    _player = [[AudioTool shareAudioTool] streamPlayerWithURL:self.pageModel.localUrls[0]];

    //_player.delegate = self;
    _curPlayIndex = 0;
    
        [_player play];
        [_preView setBackgroundImage:[UIImage imageNamed:@"pause"] forState:0];
        _voiceListContaner.userInteractionEnabled = NO;
        _playerState = 1;
   
}


- (void)endPreView{
    
    //只处理当前页的通知
    if (self.supperVC.curPage == self.pageModel.pageNo) {
        return;
    }
        //全部播放完
    if (_curPlayIndex+1 == self.pageModel.localUrls.count) {
        _player = nil;
        _playerState = 0;
        [_preView setBackgroundImage:[UIImage imageNamed:@"play"] forState:0];
        _voiceListContaner.userInteractionEnabled = YES;
        return;
    }
        //播放下一条音频
    _player = [[AudioTool shareAudioTool] streamPlayerWithURL:self.pageModel.localUrls[_curPlayIndex+1]];
    
    _curPlayIndex ++ ;
    
    [_player play];
    
    
}



- (void)btnAnimateChange {
    if (_state == RecorderStateStop) {
        [UIView animateWithDuration:0.2 animations:^{
            _recordBtn.layer.transform = CATransform3DRotate(CATransform3DIdentity, M_PI_2, 1, 0, 0);
        } completion:^(BOOL finished) {
            [self.scrollView addSubview:self.recordingBtn];
            self.recordingBtn.layer.transform = CATransform3DMakeRotation(M_PI_2, 1, 0, 0);
            [UIView animateWithDuration:0.2 animations:^{
                self.recordingBtn.layer.transform = CATransform3DRotate(self.recordingBtn.layer.transform
                                                                        , -M_PI_2, 1, 0, 0);
            } completion:^(BOOL finished) {
                self.recordingBtn.layer.transform = CATransform3DIdentity;
            }];
        }];
        _state = RecorderStateRecording;
    }else{
        if (_state == RecorderStateRecording) {
            
            [UIView animateWithDuration:0.2 animations:^{
                
            } completion:^(BOOL finished) {
                [self.recordingBtn removeFromSuperview];
                [UIView animateWithDuration:0.2 animations:^{
                    _recordBtn.layer.transform = CATransform3DRotate(_recordBtn.layer.transform
                                                                     , -M_PI_2, 1, 0, 0);
                } completion:^(BOOL finished) {
                    
                }];
            }];
            _state = RecorderStateStop;
        }
    }
}

- (void)selectPage{
    [_recordBtn stopRecord];
}
- (void)setPageModel:(XXXLecturePageModel *)pageModel{
    _pageModel = pageModel;
    self.supperVC.pageSelectedDelegate = self;
    if (pageModel.localUrls.count == 0 && pageModel.audio) {
        [pageModel.localUrls addObject:[pageModel.audio copy]];
    }
    self.titleLabel.text = pageModel.title;
    self.recordBtn.voiceUrls = pageModel.localUrls;
    if (pageModel.localImage) {

    }
    [self.voiceViews removeAllObjects];
    [self.voiceListContaner removeSubviews];
    [self updateVoiceList];
    if (!pageModel.localImage) {
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:pageModel.picture] placeholderImage:[UIImage imageNamed:@"backimg"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            self.preViewImageView.image = image;
            self.chosenImage = image;
        }];
    }else{
        UIImage *image = [UIImage imageWithData:pageModel.localImage];
        self.preViewImageView.image = image;
        self.chosenImage = image;
        self.imageView.image = image;
    }
    
    
    
    for (NSString *url in self.pageModel.localUrls) {
        [self saveRecord:url];
    }
}


-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


@end
