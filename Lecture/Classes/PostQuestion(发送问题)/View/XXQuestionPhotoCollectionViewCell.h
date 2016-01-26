//
//  XXQuestionPhotoCollectionViewCell.h
//  Lecture
//
//  Created by 陈旭 on 16/1/24.
//  Copyright © 2016年 陈旭. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZLCameraImageView.h"

@interface XXQuestionPhotoCollectionViewCell : UICollectionViewCell

@property (nonatomic,strong) NSIndexPath* indexPath;

@property (nonatomic,strong) ZLCameraImageView* photoImageView;

@end
