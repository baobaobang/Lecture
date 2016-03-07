//
//  XXXBaseScrollVC.h
//  Lecture
//
//  Created by mortal on 16/2/3.
//  Copyright © 2016年 陈旭. All rights reserved.
//

#import "XXXBaseVC.h"

@interface XXXBaseScrollVC : XXXBaseVC<UITextFieldDelegate>

@property (nonatomic, strong) UITextField *curTextField;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end
