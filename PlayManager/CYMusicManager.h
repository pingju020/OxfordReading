//
//  CYMusicManager.h
//  CYMusic
//
//  Created by yangjuanping on 2018/12/7.
//  Copyright © 2018年 yangjuanping. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

@interface CYMusicManager : NSObject
//当前播放时长
@property (nonatomic,assign) NSTimeInterval currentTime;
//曲目总时长
@property (nonatomic,assign,readonly) NSTimeInterval duration;

//全局访问点
+(instancetype)sharedManager;

//播放器
@property (nonatomic,strong) AVAudioPlayer *player;

@property (nonatomic,weak) UIButton *playBtn;

//播放或暂停
-(void)playMusicWithFileName:(NSString *)fileName;

//暂停
-(void)pause;

@end
