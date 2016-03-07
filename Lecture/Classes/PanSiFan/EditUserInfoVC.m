//
//  EditUserInfoVC.m
//  Lecture
//
//  Created by mortal on 16/3/4.
//  Copyright © 2016年 陈旭. All rights reserved.
//

#import "EditUserInfoVC.h"
#import "UIView+RoundAndShadow.h"
#import "LGPhoto.h"
@interface EditUserInfoVC()<UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,LGPhotoPickerViewControllerDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *seperatorW;
@property (weak, nonatomic) IBOutlet UIButton *applyBtn;
@property (weak, nonatomic) IBOutlet UIImageView *infoPic;
@property (weak, nonatomic) IBOutlet UIImageView *headPic;
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *mobile;
@property (weak, nonatomic) IBOutlet UITextField *hospital;
@property (weak, nonatomic) IBOutlet UITextField *department;
@property (weak, nonatomic) IBOutlet UITextField *jobTitle;
@property (weak, nonatomic) UIImageView *curImageView;

@end
@implementation EditUserInfoVC


-(void)viewDidLoad{
    [super viewDidLoad];
    self.seperatorW.constant = SWIDTH-40;
    [self.applyBtn shadow];
    self.title = @"个人资料";
}

- (IBAction)apply:(UIButton *)sender {
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                               //TODO: 参数
                                                                               }];
    NSData *headPicData = UIImageJPEGRepresentation(self.headPic.image, 1);
    [NetworkManager qiniuUpload:headPicData progress:^(NSString *key, float percent) {
        [SVProgressHUD showProgress:percent];
    } success:^(id result) {
        dic[@"headPic"] = result;
        NSData *infoPicData = UIImageJPEGRepresentation(self.infoPic.image, 1);
        [NetworkManager qiniuUpload:infoPicData progress:^(NSString *key, float percent) {
            [SVProgressHUD showProgress:percent];
        } success:^(id result) {
            dic[@"infoPic"] = result;
            [SVProgressHUD show];
            [NetworkManager postWithApi:@"apply" params:@{} success:^(id result) {
                [SVProgressHUD showSuccessWithStatus:@"申请成功"];
                //TODO: 申请
            } fail:^(NSError *error) {
                
            }];
        } fail:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"上传失败"];
        } isImageType:YES];
    } fail:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"上传失败"];
    } isImageType:YES];
}

- (IBAction)chooseInfoPic:(UITapGestureRecognizer *)sender {
    self.curImageView = (UIImageView *)sender.view;
    [self.curTextField resignFirstResponder];
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"选择照片来源" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"照片",@"拍照", nil];
    [actionSheet showInView:self.view];
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
    self.curImageView.image = info[UIImagePickerControllerOriginalImage];
    
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
    self.curImageView.image = simage;
}
@end
