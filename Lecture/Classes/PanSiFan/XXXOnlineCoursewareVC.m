//
//  XXXOnlineCoursewareVC.m
//  Upload
//
//  Created by mortal on 16/1/11.
//  Copyright © 2016年 禾医健康科技. All rights reserved.
//

#import "XXXOnlineCoursewareVC.h"
#import "AudioTool.h"
#import "RecordView.h"
#import "Masonry.h"
#import "RecordButton.h"
#import "Transcoder.h"
#import "XXXCoursewareBaseVC.h"
#import "LGPhoto.h"
#import "RecordButton.h"

@interface XXXOnlineCoursewareVC ()<UIActionSheetDelegate,LGPhotoPickerViewControllerDelegate,RecordViewDelegate,RecordStopDelegate,AVAudioPlayerDelegate,UITextFieldDelegate>
@property (nonatomic, weak) XXXCoursewareBaseVC *supperVC;
@property (weak, nonatomic) IBOutlet UILabel *pageLabel;//页码
@property (weak, nonatomic) IBOutlet RecordButton *recordBtn;//录音按钮
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
@property (nonatomic, strong) AVAudioPlayer *player;
@property (nonatomic, assign) NSInteger curPlayIndex;
@property (nonatomic, assign) NSInteger playerState;//1-播放 0-暂停
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

+(instancetype)onlineCoursewareWithSupperVC:(UIViewController *)vc{
    XXXOnlineCoursewareVC *ocwVC = [[XXXOnlineCoursewareVC alloc]init];
    ocwVC.supperVC = (XXXCoursewareBaseVC *)vc;
    ocwVC.view.frame =CGRectMake(SWIDTH,93, SWIDTH, SHEIGHT);
    [ocwVC.view shadow];
    return ocwVC;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    _courseTitle = @"courseTitle";

    if (_page == 0) {
        _page = 1;
    }
    [self setPageNum];
    UILabel *label = [[UILabel alloc]init];
    label.textColor = [UIColor whiteColor];
    label.text = @"在线课件";
    [label sizeToFit];
    self.navigationItem.titleView = label;
    
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(preView)];
    [self.preViewImageView addGestureRecognizer:tap2];
    
    UITapGestureRecognizer *imageTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addImage)];
    [_imageView addGestureRecognizer:imageTap];
    _addPage.layer.shadowOpacity = 1;
    _addPage.layer.shadowOffset = CGSizeMake(1, 1);
    _addPage.layer.shadowColor = [UIColor grayColor].CGColor;
    
    
    _saveBtn.imageEdgeInsets = UIEdgeInsetsMake(10,0,10,10);
    
    _seperatorWidth.constant = SWIDTH;
    
    _titleLabel.delegate = self;
    
    self.recordBtn.voiceUrls = self.voiceUrls;
    self.recordBtn.courseTitle = self.courseTitle;
    self.recordBtn.page = self.page;
    self.recordBtn.delegate = self;
    
    [self updateVoiceList];
    
    
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1 initialSpringVelocity:3 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        self.view.frame = CGRectMake(0,84, SWIDTH, SHEIGHT);
    } completion:nil];
}
- (void)updateVoiceList{
    
    for (NSInteger i=0;i<self.voiceViews.count;i++){
        ((RecordView *)self.voiceViews[i]).frame = CGRectMake(0,i*40, 200, 40);
    }
    _voiceListViewHeight.constant = 40*(_voiceViews.count);
//    [self.voiceListContaner.superview layoutIfNeeded];
//    [UIView animateWithDuration:2 animations:^{
//        [self.voiceListContaner mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.height.equalTo(@(40*(_voiceViews.count)));
//        }];
//    }];
    
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
 *  开始录音/暂停录音
 *
 *  @param sender 按钮
 */
//- (IBAction)recordVoice:(UIButton *)sender {
//   
//    NSString *document = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
//   
//    if (!_recorder) {
//        NSInteger num = self.voiceUrls.count+1;
//        NSString *voiceName = [NSString stringWithFormat:@"title%@page%ldnumber%ld%@",_courseTitle,_page,num,@"voice.wav"];
//        NSString *path = [document stringByAppendingPathComponent:voiceName];
//        _filePath = [NSURL URLWithString:path];
//        
//        [self.voiceUrls addObject:path];
//        
//        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
//        
//        
//        NSDictionary *recordSettings=[NSDictionary dictionaryWithObjectsAndKeys:
//                                      [NSNumber numberWithInt:AVAudioQualityMin],
//                                      AVEncoderAudioQualityKey,
//                                      [NSNumber numberWithInt:16],
//                                      AVEncoderBitRateKey,
//                                      [NSNumber numberWithInt:2],
//                                      AVNumberOfChannelsKey,
//                                      [NSNumber numberWithFloat:44100.0],
//                                      AVSampleRateKey,
//                                      [NSNumber numberWithInt: kAudioFormatLinearPCM],AVFormatIDKey,nil];
//        _recorder = [[AVAudioRecorder alloc]initWithURL:_filePath settings:recordSettings error:nil];
//        
//        _state = RecorderStateStop;//停止状态
//    }
//    switch (_state) {
//        case RecorderStateRecording:
//        {
//            
//            [_recordBtn setBackgroundImage:nil forState:0];
//            [_recordBtn setTitle:@"开始录音" forState:0];
//            [_displayLink invalidate];
//            [self saveRecord];//保存
//            _state = RecorderStateStop;
//            
//        }
//            break;
//            case RecorderStateStop:
//        {
//            //[self btnAnimateChange];
//            [_scrollView addSubview:self.recordingBtn];
//
//            if ([_recorder prepareToRecord]) {
//                
//                _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateTime)];
//                [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
//                [_recorder record];
//                _state = RecorderStateRecording;//录音状态
//            };
//        }
//            break;
//        default:
//            
//            [_recorder pause];//暂停
//            _state = RecorderStatePause;
//            [_displayLink invalidate];
//         break;
//    }
//    
//}


/**
 *  保存录音
 *
 *  @param sender
 */
- (void)saveRecord {
    //[_recorder stop];
    //_recorder = nil; //删除录音机
    RecordView *rv = [RecordView viewWithUrl:[_voiceUrls lastObject] index:_voiceUrls.count name:self.recordBtn.timeLabel.text];
    rv.delegate = self;
    [self.voiceListContaner addSubview:rv];
    [self.voiceViews addObject:rv];
    [self updateVoiceList];
    //_state = RecorderStateStop;
    //[self btnAnimateChange];
    
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
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"选择照片来源" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"照片",@"拍照", nil];
    [actionSheet showInView:self.view];
    
}


//上传
- (IBAction)upload:(id)sender {
    _indicator.hidden = NO;
    [_indicator startAnimating];
    [self performSelector:@selector(uploadSuccess) withObject:nil afterDelay:1.2
     ];
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
    }];
}
#pragma actionSheet 代理


- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    [self presentPhotoPickerViewControllerWithStyle:LGShowImageTypeImagePicker];
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
    [self.voiceUrls removeObjectAtIndex:index];
    [self.voiceViews removeObjectAtIndex:index];
    [self updateVoiceList];
}

- (void)stopRecord:(RecordButton *)button{
    [self saveRecord];
}
- (IBAction)addPage:(UIButton *)sender {

    [self.supperVC addpage];
}
- (IBAction)savePage:(UIButton *)sender {
    NSString *document = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSInteger num = self.voiceUrls.count;
    NSString *voiceName = [NSString stringWithFormat:@"title%@page%ldnumber%ld%@",_courseTitle,_page,num,@"voice.wav"];
    NSString *path = [document stringByAppendingPathComponent:voiceName];
    NSString *copyName = [NSString stringWithFormat:@"title%@page%ldnumber%ld%@",_courseTitle,_page,num,@"voicecopy.mp3"];
    NSString *toPath = [document stringByAppendingPathComponent:copyName];
    
    [Transcoder transcodeToMP3From:path toPath:toPath];
}

-(void)setPageNum{

    
}

- (void)remove{
    [self.view removeFromSuperview];
    [self.supperVC.childs removeObject:self];
}


- (IBAction)preView:(UIButton *)sender {
    if (_playerState == 1) {
        [_player stop];
        _player = nil;
        [_preView setBackgroundImage:[UIImage imageNamed:@"play"] forState:0];
        _voiceListContaner.userInteractionEnabled = YES;
        _playerState = 0;
        return;
    }
    _player = [[AudioTool shareAudioTool] playerWithURL:[NSURL URLWithString:_voiceUrls[0]]];
    
    _player.delegate = self;
    _curPlayIndex = 0;
    if ([_player prepareToPlay]){
        [_player play];
        [_preView setBackgroundImage:[UIImage imageNamed:@"pause"] forState:0];
        _voiceListContaner.userInteractionEnabled = NO;
        _playerState = 1;
    }
    
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    if (_curPlayIndex+1 == _voiceUrls.count) {
        _player = nil;
        [_preView setBackgroundImage:[UIImage imageNamed:@"play"] forState:0];
        _voiceListContaner.userInteractionEnabled = YES;
        return;
    }
    _player = [[AudioTool shareAudioTool] playerWithURL:[NSURL URLWithString:_voiceUrls[_curPlayIndex+1]]];
    
    _player.delegate = self;
    _curPlayIndex ++ ;
    if ([_player prepareToPlay]){
        [_player play];
    }
}

- (void)btnAnimateChange {
    //_recordBtn _recordingBtn
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
@end
