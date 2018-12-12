//
//  CYMusicModel.h
//  CYMusic
//
//  Created by yangjuanping on 2018/6/5.
//  Copyright © 2018年 yangjuanping. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    CYMusicTypeLocal,
    CYMusicTypeRemote,
} CYMusicType;

@interface CYMusicModel : NSObject

//歌手图片
@property (nonatomic,copy) NSString *image;
//歌词
@property (nonatomic,copy) NSString *lrc;
//音频
@property (nonatomic,copy) NSString *mp3;
//歌手-播放曲目
@property (nonatomic,copy) NSString *name;
//歌手
@property (nonatomic,copy) NSString *singer;
//专辑名
@property (nonatomic,copy) NSString *album;
//文件缓存路径类型
@property (nonatomic,assign) CYMusicType type;

@end
