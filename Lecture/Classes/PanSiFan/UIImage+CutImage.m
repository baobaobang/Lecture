//
//  UIImage+CutImage.m
//  Lecture
//
//  Created by mortal on 16/3/2.
//  Copyright © 2016年 陈旭. All rights reserved.
//

#import "UIImage+CutImage.h"

@implementation UIImage (CutImage)

- (UIImage *)cutImage{
    CGSize size = self.size;
    CGRect rect;
    //kXXPlayerPicViewHeightWidthRatio
    if (size.height/size.width>kXXPlayerPicViewHeightWidthRatio) {
        //大于标准宽不变
        CGFloat h = size.width*kXXPlayerPicViewHeightWidthRatio;
        rect = CGRectMake(0, (size.height-h)/2, size.width,h);
    }else{
        CGFloat w = size.height/kXXPlayerPicViewHeightWidthRatio;
        rect = CGRectMake((size.width-w)/2, 0, w, size.height);
    }
    CGImageRef subImageRef = CGImageCreateWithImageInRect(self.CGImage, rect);
    CGRect smallBounds = CGRectMake(0, 0, CGImageGetWidth(subImageRef), CGImageGetHeight(subImageRef));
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, smallBounds, subImageRef);
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    UIGraphicsEndImageContext();
    
    return smallImage;
}

- (UIImage *)scaleTo200K{
    
//    NSData *data = UIImageJPEGRepresentation(self,1);
//    CGFloat ratio = 200000.0/data.length;
//    NSLog(@"ratio:%f>>>>>>>>%ld",ratio,(unsigned long)data.length);
//    
//    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
//    CGImageRef subImageRef = CGImageCreateWithImageInRect(self.CGImage, rect);
//    CGRect smallBounds = CGRectMake(0, 0, SWIDTH, SWIDTH*kXXPlayerPicViewHeightWidthRatio);
//    
//    UIGraphicsBeginImageContext(smallBounds.size);
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextDrawImage(context, smallBounds, subImageRef);
//    //UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
//    UIGraphicsEndImageContext();
//    
//    return smallImage;
    //return [UIImage imageWithData:UIImageJPEGRepresentation(self, ratio)];
    CGSize newSize = CGSizeMake(SWIDTH, SWIDTH*kXXPlayerPicViewHeightWidthRatio);
    UIGraphicsBeginImageContext(newSize);
    [self drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
@end
