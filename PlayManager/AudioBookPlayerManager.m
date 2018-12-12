//
//  AudioBookPlayerManager.m
//  ChineseClass
//
//  Created by yangjuanping on 2018/6/11.
//  Copyright © 2018年 jiulong zhou. All rights reserved.
//
#import "AudioBookPlayerManager.h"
//#import "AudioBookVM.h"

//#import "AudioBookUrlModel.h"

#import <MediaPlayer/MPMediaItem.h>
#import <MediaPlayer/MPNowPlayingInfoCenter.h>

@interface AudioBookPlayerManager()
@property (nonatomic,strong) AVPlayer *player;
@property (nonatomic,strong) AVPlayerItem *playItem;
@property (nonatomic,assign) ShuffleAndRepeatState shuffleAndRepeatState;
@property (nonatomic,assign) NSInteger playingIndex;
@property (nonatomic, strong) id timeObserver;
@end


@implementation AudioBookPlayerManager

static AudioBookPlayerManager *_sharedManager = nil;

+ (AudioBookPlayerManager *)sharedManager {
    static AudioBookPlayerManager *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] init];
    });
    return shared;
}

- (AVPlayer *)player {
    if (_player == nil) {
        _player = [[AVPlayer alloc] init];
        _player.volume = 1.0; // 默认最大音量
    }
    return _player;
}

//播放音频的方法
- (void)p_musicPlayerWithURL:(NSURL *)playerItemURL{
    // 移除监听
    [self p_currentItemRemoveObserver];
    // 创建要播放的资源
    AVPlayerItem *playerItem = [[AVPlayerItem alloc]initWithURL:playerItemURL];
    // 播放当前资源
    [self.player replaceCurrentItemWithPlayerItem:playerItem];
    // 添加观察者
    [self p_currentItemAddObserver];
}

- (void)p_currentItemRemoveObserver {
    [self.player.currentItem removeObserver:self  forKeyPath:@"status"];
    [self.player.currentItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    [self.player removeTimeObserver:self.timeObserver];
}

- (void)p_currentItemAddObserver {
    
    //监控状态属性，注意AVPlayer也有一个status属性，通过监控它的status也可以获得播放状态
    [self.player.currentItem addObserver:self forKeyPath:@"status" options:(NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew) context:nil];
    
    //监控缓冲加载情况属性
    [self.player.currentItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
    
    //监控播放完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
    
    //监控时间进度
    WEAK_SELF(weakSelf)
    self.timeObserver = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
//        @strongify(self);
//        // 在这里将监听到的播放进度代理出去，对进度条进行设置
//        if (self.delegate && [self.delegate respondsToSelector:@selector(updateProgressWithPlayer:)]) {
//            [self.delegate updateProgressWithPlayer:self.player];
//        }
    }];
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    AVPlayerItem *playerItem = object;
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerItemStatus status = [change[@"new"] integerValue];
        switch (status) {
            case AVPlayerItemStatusReadyToPlay:
            {
                // 开始播放
                [self startPlay];
                // 代理回调，开始初始化状态
//                if (self.delegate && [self.delegate respondsToSelector:@selector(startPlayWithplayer:)]) {
//                    [self.delegate startPlayWithplayer:self.player];
//                }
            }
                break;
            case AVPlayerItemStatusFailed:
            {
                NSLog(@"加载失败");
            }
                break;
            case AVPlayerItemStatusUnknown:
            {
                NSLog(@"未知资源");
                //TOAST_MSG(@"播放错误");
            }
                break;
            default:
                break;
        }
    } else if([keyPath isEqualToString:@"loadedTimeRanges"]){
        NSArray *array=playerItem.loadedTimeRanges;
        //本次缓冲时间范围
        CMTimeRange timeRange = [array.firstObject CMTimeRangeValue];
        float startSeconds = CMTimeGetSeconds(timeRange.start);
        float durationSeconds = CMTimeGetSeconds(timeRange.duration);
        //缓冲总长度
        NSTimeInterval totalBuffer = startSeconds + durationSeconds;
        NSLog(@"共缓冲：%.2f",totalBuffer);
//        if (self.delegate && [self.delegate respondsToSelector:@selector(updateBufferProgress:)]) {
//            [self.delegate updateBufferProgress:totalBuffer];
//        }
        
    } else if ([keyPath isEqualToString:@"rate"]) {
        // rate=1:播放，rate!=1:非播放
        float rate = self.player.rate;
//        if (self.delegate && [self.delegate respondsToSelector:@selector(player:changeRate:)]) {
//            [self.delegate player:self.player changeRate:rate];
//        }
    } else if ([keyPath isEqualToString:@"currentItem"]) {
        NSLog(@"新的currentItem");
//        if (self.delegate && [self.delegate respondsToSelector:@selector(changeNewPlayItem:)]) {
//            [self.delegate changeNewPlayItem:self.player];
//        }
    }
}

- (void)playbackFinished:(NSNotification *)notifi {
    NSLog(@"播放完成");
}


//-(id)init{
//    if (self = [super init]) {
////        // 设置KVO
////        [self addObserver:self forKeyPath:@"playingIndex" options:NSKeyValueObservingOptionOld
////         |NSKeyValueObservingOptionNew context:nil];
//
////        [self addObserver:self forKeyPath:@"finishPlaySongIndex" options:NSKeyValueObservingOptionOld
////         |NSKeyValueObservingOptionNew context:nil];
//
////        // Notification
////        [[NSNotificationCenter defaultCenter] addObserver: self
////                                                 selector: @selector(playSongSetting)
////                                                     name: @"repeatPlay"
////                                                   object: nil];
//        [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(finishedPlaying) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
//        // 播放遇到中断，比如电话进来
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAudioSessionEvent:) name:AVAudioSessionInterruptionNotification object:nil];
//    }
//    return self;
//}
//
////-(void) setPlayItem: (NSString *)songURL {
////
////    //这里是否可以加个判断，如果上个播放和本次播放一样就不再加载新的URL
////
////    NSURL * url  = [NSURL URLWithString:songURL];
////    _playItem = [[AVPlayerItem alloc] initWithURL:url];
////
////}
//
//-(void) setFile:(NSURL *)file{
//    if (_file != file) {
//        _playItem = [[AVPlayerItem alloc] initWithURL:file];
//        _file = file;
//    }
//}
//
//-(void) setPlay {
//    //    张凯添加防崩溃机制，防止 重复释放  playbackTimeObserver 导致的崩溃
//    if (_playerTimeObserver != nil) {
//        @try{
//            [self.play removeTimeObserver:_playerTimeObserver];
//            _playerTimeObserver = nil;
//
//            [self.play.currentItem cancelPendingSeeks];
//            [self.play.currentItem.asset cancelLoading];
//        }
//        @catch(id anException){
//        }
//    }
//
//    _play = [[AVPlayer alloc] initWithPlayerItem:_playItem];
//}
//
-(void) startPlay {
    [_player play];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"playStatuChange" object:@{@"statu":@1}];
}

-(void) stopPlay {
    [_player pause];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"playStatuChange" object:@{@"statu":@0}];
}
//
//#pragma mark - 播放音乐调用
//-(void) playSongSetting {
//
//    if (self.isContinuePlaying) {
//        self.PlayProgress(0, 0);
//    }
//    else{
//        [self setPlay];
//        [self startPlay];
//
//        self.PlayProgress(0, 0);
//        WEAK_SELF(weakSelf)
//        _playerTimeObserver = [self.play addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
//
//            CGFloat currentTime = CMTimeGetSeconds(time);
//            //                                        NSLog(@"当前播放时间：%f", currentTime);
//
//            if ((int)currentTime == 30) {
//                //1、发送播放历史记录通知
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"HistorypkgId" object:nil];
//                //2、记录播放时长
//
//            }
//            //我们二十秒发送一次记录播放的总时长。
//            if (++weakSelf.postTime%20 == 0) {
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"BookListentime" object:nil];
//            }
//
//
//            CMTime total = weakSelf.play.currentItem.duration;
//            CGFloat totalTime = CMTimeGetSeconds(total);
//
//            if (weakSelf.PlayProgress) {
//                weakSelf.PlayProgress(currentTime, totalTime);
//            }
////            [weakSelf configNowPlayingCenter:book.name totalTime:totalTime currTiem:currentTime ];
//        }];
//    }
//}
//
//#pragma mark - KVO
//-(void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
//
//    if ([keyPath  isEqual: @"playingIndex"]) {
//        [self playSongSetting];
//    }
//
//    if ([keyPath  isEqual: @"finishPlaySongIndex"]) {
//        [self playSongSetting];
//    }
//}
//
//#pragma mark - 音乐被中断处理
//- (void) onAudioSessionEvent: (NSNotification *) notification
//{
//    //Check the type of notification, especially if you are sending multiple AVAudioSession events here
//    if ([notification.name isEqualToString:AVAudioSessionInterruptionNotification]) {
////        NSLog(@"Interruption notification received!");
//
//        //Check to see if it was a Begin interruption
//        if ([[notification.userInfo valueForKey:AVAudioSessionInterruptionTypeKey] isEqualToNumber:[NSNumber numberWithInt:AVAudioSessionInterruptionTypeBegan]]) {
////            NSLog(@"Interruption began!");
//            [self stopPlay];
//        } else {
////            NSLog(@"Interruption ended!");
//            //Resume your audio
//            [self startPlay];
//        }
//    }
//}
//
//-(void) finishedPlaying {
//
////    [[NSNotificationCenter defaultCenter]  removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:self.play.currentItem];
//   @try{ //防止出现数组越界导致的崩溃。
//       NSInteger index = self.playingIndex;
//       CYMusicModel *book = nil;
//
////       if (index < _audioPlayList.count - 1) {
////           index = index + 1;
////       } else {
////           index = 0;
////       }
////       book = [_audioPlayList objectAtIndex:index];
////       self.playingIndex = index;
//   }
//    @catch(id anException){
//    }
//}
//
//- (void)configNowPlayingCenter:(NSString*)name totalTime:(NSInteger)total currTiem:(NSInteger)curr {
//    //    NSLog(@"锁屏设置");
//    // BASE_INFO_FUN(@"配置NowPlayingCenter");
//    NSMutableDictionary * info = [NSMutableDictionary dictionary];
//    //音乐的标题
//    [info setObject:name forKey:MPMediaItemPropertyTitle];
//    //音乐的艺术家
//    NSString *author= @"琢磨琢磨英语";
//    [info setObject:author forKey:MPMediaItemPropertyArtist];
//    //音乐的播放时间
//    [info setObject:[NSNumber numberWithInteger:curr] forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime];
//    //音乐的播放速度
//    [info setObject:@(1) forKey:MPNowPlayingInfoPropertyPlaybackRate];
//    //音乐的总时间
//    [info setObject:[NSNumber numberWithInteger:total] forKey:MPMediaItemPropertyPlaybackDuration];
//    //音乐的封面
//    MPMediaItemArtwork * artwork = [[MPMediaItemArtwork alloc] initWithImage:[UIImage imageNamed:@"play_icon_default.png"]];
//    [info setObject:artwork forKey:MPMediaItemPropertyArtwork];
//    //完成设置
//    [[MPNowPlayingInfoCenter defaultCenter]setNowPlayingInfo:info];
//}
//
//
//- (void)dealloc{
//    [[NSNotificationCenter defaultCenter] removeObserver:@"HistorypkgId"];
//    [[NSNotificationCenter defaultCenter] removeObserver:@"BookListentime"];
//    [[NSNotificationCenter defaultCenter] removeObserver:@"playStatuChange"];
//    [[NSNotificationCenter defaultCenter] removeObserver:@"playNextStoryPicture"];
//}

@end
