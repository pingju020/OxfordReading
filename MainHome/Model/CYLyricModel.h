//
//  CYLyricModel.h
//  CYMusic
//
//  Created by yangjuanping on 2018/8/12.
//  Copyright © 2018年 yangjuanping. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CYLyricModel : NSObject
//当前这一句的歌词内容
@property (nonatomic,copy) NSString *lyricContent;
//该句歌词的起始播放时间
@property(nonatomic,assign) NSTimeInterval initialTime;

@end
