//
//  Transcoder.h
//  Upload
//
//  Created by mortal on 16/1/18.
//  Copyright © 2016年 禾医健康科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Transcoder : NSObject

+ (void)transcodeToMP3From:(NSString *)filePath toPath:(NSString *)mp3savePath;

@end
