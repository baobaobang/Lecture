//
//  XXXApplyLectureVC.m
//  Lecture
//
//  Created by mortal on 16/2/17.
//  Copyright © 2016年 陈旭. All rights reserved.
//

#import "XXXApplyLectureVC.h"
#import "XXXDatePicker.h"
#import "XXXTimePicker.h"
#import "XXXTextField.h"
#import "LGPhoto.h"
#import "XXXCoursewareBaseVC.h"

@interface XXXApplyLectureVC ()<UITextFieldDelegate,XXXDatePickerDelegate,XXXTimePickerDelegate,UIActionSheetDelegate,LGPhotoPickerViewControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleFieldWidth;
@property (weak, nonatomic) IBOutlet XXXTextField *lectureTitle;
@property (weak, nonatomic) IBOutlet XXXTextField *desc;
@property (weak, nonatomic) IBOutlet XXXTextField *startTime;
@property (weak, nonatomic) IBOutlet XXXTextField *duration;
@property (weak, nonatomic) IBOutlet XXXTextField *onlineDuration;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) UIImage *chosenImage;

@end

@implementation XXXApplyLectureVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleLabel.text = @"申请讲座";
    
    self.titleFieldWidth.constant = SWIDTH-120;
    UIView *startBack = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    UIImageView *startTimeRightView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"starttime"]];
    [startBack addSubview:startTimeRightView];
    startTimeRightView.frame = CGRectMake(7.5, 7.5, 25, 25);
    self.startTime.rightView = startBack;
    self.startTime.rightViewMode = UITextFieldViewModeAlways;
    
    UIView *durationBack = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    UIImageView *durationTimeRightView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"duration"]];
    [durationBack addSubview:durationTimeRightView];
    durationTimeRightView.frame = CGRectMake(7.5, 7.5, 25, 25);
    self.duration.rightView = durationBack;
    self.duration.rightViewMode = UITextFieldViewModeAlways;
    
    UIView *onlinedurationBack = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    UIImageView *onlinedurationTimeRightView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"duration"]];
    [onlinedurationBack addSubview:onlinedurationTimeRightView];
    onlinedurationTimeRightView.frame = CGRectMake(7.5, 7.5, 25, 25);
    self.onlineDuration.rightView = onlinedurationBack;
    self.onlineDuration.rightViewMode = UITextFieldViewModeAlways;
}

- (IBAction)finish:(UIButton *)sender {
    
    if (self.startTime.text.length == 0 ||
        self.duration.text.length == 0 ||
        self.onlineDuration.text.length == 0 ||
        self.lectureTitle.text.length == 0 ||
        self.desc.text.length == 0 ) {
        AlertMessage(@"请将信息填写完整");
        return;
    }
    [SVProgressHUD show];
    NSDictionary *dic = @{@"startDate":self.startTime.text,
                             @"duration":@([self.duration.text integerValue]),
                             @"onlineDuration":@([self.onlineDuration.text integerValue]),
                             @"title":self.lectureTitle.text,
                             @"description":self.desc.text};
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:dic];
    
    NSData *imageData = UIImageJPEGRepresentation(self.chosenImage, 1);// jpeg
    if (imageData.length == 0) {
        [self apply:params];
    }else{
        
        [NetworkManager qiniuUpload:imageData progress:^(NSString *key, float percent) {
            [SVProgressHUD showProgress:percent];
        } success:^(id result) {
            [params setValue:result forKey:@"cover"];
            [self apply:params];
        } fail:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"图片上传失败"];
        } isImageType:YES];
        
    }
    
}

- (void)apply:(NSMutableDictionary *)params{
    
    
    [NetworkManager postWithApi:@"lectures" params:params success:^(id result) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showSuccessWithStatus:@"申请成功"];
        [self dismissViewControllerAnimated:YES completion:^{
            XXXCoursewareBaseVC *cb = [[XXXCoursewareBaseVC alloc]init];
            cb.lectureModel = [[XXXLectureModel alloc]init];
            cb.lectureModel.lectureId = [result[@"data"][@"lectureId"] stringValue];
            
            AppDelegate *delegate = Delegate;
            [delegate.sliderMenu.mainViewController presentViewController:cb animated:NO completion:^{
                
            }];
        }];
    } fail:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"申请失败"];
    }];
}

/**
 *  添加图片
 *
 *  @param sender
 */
- (IBAction)addImage:(UITapGestureRecognizer *)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"选择照片来源" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"照片",@"拍照", nil];
    [actionSheet showInView:self.view];
    
}

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

- (void)presentPhotoPickerViewControllerWithStyle:(LGShowImageType)style {
    LGPhotoPickerViewController *pickerVc = [[LGPhotoPickerViewController alloc] initWithShowType:style];
    //pickerVc.status = PickerViewShowStatusCameraRoll;
    pickerVc.maxCount = 1;   // 最多能选9张图片
    pickerVc.delegate = self;
    [pickerVc showPickerVc:self];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    self.imageView.image = info[UIImagePickerControllerOriginalImage];
    self.chosenImage = info[UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)pickerViewControllerDoneAsstes:(NSArray *)assets isOriginal:(BOOL)original{
    LGPhotoAssets *as = [assets lastObject];
    UIImage *simage = as.thumbImage;
    self.imageView.image = simage;
    self.chosenImage = simage;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [self.curTextField resignFirstResponder];
    self.curTextField = textField;
    switch (textField.tag) {
        case 1001://选择开始日期
        {
            XXXDatePicker *datePicker = [[XXXDatePicker alloc]initWithFrame:CGRectMake(10, 100, SWIDTH-20, 300)];
            datePicker.center = self.view.center;
            datePicker.delegate = self;
            [datePicker alertInView:self.view];
        }
            return NO;
        case 1002://选择时长
        case 1003://选择在线交流时长
        {
            XXXTimePicker *timePicker = [[XXXTimePicker alloc]initWithFrame:CGRectMake(10, 100, SWIDTH-20, 300)];
            timePicker.delegate = self;
            timePicker.center = self.view.center;
            [timePicker alertInView:self.view];
        }
            return NO;
        default:
            return YES;
    }
}


- (void)datePicker:(XXXDatePicker *)picker didFinishPickTime:(NSString *)timeStr{
    self.curTextField.text = timeStr;
}

- (void)timePicker:(XXXTimePicker *)picker didFinishPickTime:(NSInteger)min{
    self.curTextField.text = [NSString stringWithFormat:@"%ld分钟",min];
}
@end
