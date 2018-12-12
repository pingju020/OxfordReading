//
//  CYLyricParser.h
//  CYMusic
//
//  Created by yangjuanping on 2018/8/12.
//  Copyright © 2018年 yangjuanping. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CYLyricModel.h"

@interface CYLyricParser : NSObject

+ (NSArray <CYLyricModel *>*)parserLyricWithFileName:(NSString *)fileName;

@end
