//
//  XXXTextField.m
//  lecture
//
//  Created by mortal on 16/1/20.
//  Copyright © 2016年 禾医健康科技. All rights reserved.
//

#import "XXXTextField.h"

@implementation XXXTextField

- (CGRect)editingRectForBounds:(CGRect)bounds{
    return CGRectMake(bounds.origin.x+14, bounds.origin.y, bounds.size.width - 28, bounds.size.height);
}

- (CGRect)placeholderRectForBounds:(CGRect)bounds{
    return CGRectMake(bounds.origin.x+14, bounds.origin.y, bounds.size.width - 28, bounds.size.height);
}

- (CGRect)textRectForBounds:(CGRect)bounds{
    return CGRectMake(bounds.origin.x+14, bounds.origin.y, bounds.size.width - 28, bounds.size.height);
}
@end
