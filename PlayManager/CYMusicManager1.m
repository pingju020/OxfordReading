//
//  CYMusicManager.m
//  CYMusic
//
//  Created by 蔡钰 on 2017/6/7.
//  Copyright © 2017年 蔡钰. All rights reserved.
//

#import "CYMusicManager.h"
#import <UIKit/UIKit.h>

@interface CYMusicManager ()

//当前曲目名
@property (nonatomic,copy) NSString *fileName;

@property (nonatomic,strong) AVPlayerItem *playItem;
//@property (nonatomic,assign) int postTime;
@end

@implementation CYMusicManager

+(instancetype)sharedManager {
    static CYMusicManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        //开启音频会话
        AVAudioSession *session = [AVAudioSession sharedInstance];
        [session setCategory:AVAudioSessionCategoryPlayback error:nil];
        //应用开启远程控制后,才会自动切歌,既可以实现后台运行 & 支持线控
        //[[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
        //注册打断通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(interruptHandleAction:) name:AVAudioSessionInterruptionNotification object:nil];
    }
   return self;
}

//播放打断事件处理
- (void)interruptHandleAction:(NSNotification *)noti {
    int type = [noti.userInfo[AVAudioSessionInterruptionTypeKey] intValue];
    switch (type) {
        case AVAudioSessionInterruptionTypeBegan:  //被打断
            [self.player pause];
            //取消选中状态
            self.playBtn.selected = NO;
            break;
        case AVAudioSessionInterruptionTypeEnded: //结束打断
            [self.player play];
            //设置为选中状态
            self.playBtn.selected = YES;
        default:
            break;
    }
}

//开始播放/继续播放
-(void)playMusicWithFileName:(NSString *)fileName {
    
    if (![self.fileName isEqualToString:fileName]) {
        
        NSURL* url = [NSURL fileURLWithPath:fileName];
        if (!url) {
            //获取文件路径
            NSString *pathStr = [[NSBundle mainBundle] pathForResource:fileName ofType:nil];
            url = [NSURL fileURLWithPath:pathStr];
        }
        
        _playItem = [[AVPlayerItem alloc] initWithURL:url];
        
        //记录当前曲目名
        self.fileName = fileName;
    }
    
    [self startPlay];
//    //开始播放
//    //[self.player play];
//
//    // 延时一秒,给缓冲预留更充足的时间
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        //开始播放
//        [self.player play];
//    });

}

-(void)startPlay{
    if (_playerTimeObserver != nil) {
        @try{
            [self.player removeTimeObserver:_playerTimeObserver];
            _playerTimeObserver = nil;
            
            [self.player.currentItem cancelPendingSeeks];
            [self.player.currentItem.asset cancelLoading];
        }
        @catch(id anException){
        }
    }
    
    if (self.player.currentItem != _playItem) {
        //初始化播放器
        self.player = [[AVPlayer alloc] initWithPlayerItem:_playItem];
    }
    
    //开始播放
    [self play];
    
    WEAK_SELF(weakSelf)
    _playerTimeObserver = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        
        CGFloat currentTime = CMTimeGetSeconds(time);
        //                                        NSLog(@"当前播放时间：%f", currentTime);
        
//        if ((int)currentTime == 30) {
//            //1、发送播放历史记录通知
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"HistorypkgId" object:nil];
//            //2、记录播放时长
//
//        }
//        //我们二十秒发送一次记录播放的总时长。
//        if (++weakSelf.postTime%20 == 0) {
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"BookListentime" object:nil];
//        }
        
        
        CMTime total = weakSelf.player.currentItem.duration;
        CGFloat totalTime = CMTimeGetSeconds(total);
        
        if (weakSelf.MusicPlayProgress) {
            weakSelf.MusicPlayProgress(currentTime, totalTime);
        }
        //            [weakSelf configNowPlayingCenter:book.name totalTime:totalTime currTiem:currentTime ];
    }];
}

-(void)play{
    [self.player play];
}

//暂停
-(void)pause {
    
    [self.player pause];

}
////当前播放时长
//-(NSTimeInterval)currentTime {
//    
//    return self.player.currentTime;
//
//}
//
//-(void)setCurrentTime:(NSTimeInterval)currentTime {
//     //拖动播放进度条时改变当前播放时长
//    self.player.currentTime = currentTime;
//
//}
////曲目总时长
//-(NSTimeInterval)duration {
//   
//    return self.player.duration;
//
//}


@end
