//
//  XXXBaseModel.h
//  lecture
//
//  Created by mortal on 16/2/1.
//  Copyright © 2016年 禾医健康科技. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"
#import "DBManager.h"
@interface XXXBaseModel : NSObject

+ (NSMutableArray *)objectArrayWithArray:(NSArray *)dictArray;

- (BOOL)save;

+ (BOOL)deleteElements:(NSArray *)elementsArray;
@end
