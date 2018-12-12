//
//  AudioBookPlayerManager.h
//  ChineseClass
//
//  Created by yangjuanping on 2018/6/11.
//  Copyright © 2018年 jiulong zhou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "CYMusicModel.h"

@interface AudioBookPlayerManager : NSObject

typedef enum : NSUInteger {
    RepeatPlayMode,
    RepeatOnlyOnePlayMode,
    ShufflePlayMode,
} ShuffleAndRepeatState;


@property (nonatomic,strong) NSURL* file;
@property (strong,nonatomic) void (^PlayProgress)(CGFloat currentTime, CGFloat totalTime);




+ (AudioBookPlayerManager *)sharedManager;

//播放音频的方法
- (void)p_musicPlayerWithURL:(NSURL *)playerItemURL;

@end
