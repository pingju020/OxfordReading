//
//  AudioPlayerManager.m
//  OxfordReading
//
//  Created by yangjuanping on 2018/12/12.
//  Copyright © 2018 yangjuanping. All rights reserved.
//

#import "AudioPlayerManager.h"
#import <AVFoundation/AVFoundation.h>

@interface AudioPlayerManager()
@property (nonatomic,strong) AVPlayer *player;
@property (nonatomic, strong) id timeObserver;
@property (nonatomic, strong) NSString* filePath;
@property (nonatomic, assign) BOOL hasObserver;
@end


@implementation AudioPlayerManager

+ (AudioPlayerManager *)sharedManager {
    static AudioPlayerManager *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] init];
    });
    return shared;
}

- (AVPlayer *)player {
    if (_player == nil) {
        _player = [[AVPlayer alloc] initWithPlayerItem:[AVPlayerItem playerItemWithURL:[NSURL URLWithString:@""]]];
        _player.volume = 1.0; // 默认最大音量
    }
    return _player;
}

-(void)changePlayItem:(NSString*)itemPath{
    if (![_filePath isEqualToString:itemPath]) {
        if (self.hasObserver) {
            [self removeObserver];
        }
        
        _filePath = itemPath;
        NSURL* url=nil;
        if ([itemPath hasPrefix:@"http://"] || [itemPath hasPrefix:@"https://"]) {
            url = [NSURL URLWithString:itemPath];
        }
        else{
            NSString *pathStr = [[NSBundle mainBundle] pathForResource:itemPath ofType:nil];
            url = [NSURL fileURLWithPath:pathStr];
        }
        
        AVPlayerItem *item = [AVPlayerItem playerItemWithURL:url];
        [self.player replaceCurrentItemWithPlayerItem:item];
        
        [self addObserver];
    }
}

-(void)changePlayTime:(NSInteger)second{
    CMTime changedTime = CMTimeMakeWithSeconds(second, 1);
    [_player seekToTime:changedTime completionHandler:^(BOOL finished) {
    }];
}

//-(CGFloat)getPlayTime{
//    CGFloat currentPlayTime =_player.currentItem.currentTime.value/_player.currentItem.currentTime.timescale;
//    return currentPlayTime;
//}
//
//-(CGFloat)getDuration{
//    NSArray *loadedTimeRanges = [[_player currentItem] loadedTimeRanges];
//    CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];//获取缓冲区域
//    CGFloat startSeconds = CMTimeGetSeconds(timeRange.start);
//    CGFloat durationSeconds = CMTimeGetSeconds(timeRange.duration);
//    return startSeconds + durationSeconds;//计算缓冲总进度
//}

-(void)play{
    [_player play];
}

-(void)pause{
    [_player pause];
}

- (void)playFinish
{
    [self changePlayTime:0];
    if (self.playFinished) {
        self.playFinished();
    }
    NSLog(@"播放完成");
}

//实现监听
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"status"]) {
        // 取出status的新值
        AVPlayerItemStatus status = [change[NSKeyValueChangeNewKey] intValue];
        switch (status) {
            case AVPlayerItemStatusFailed: {
                NSLog(@"item 有误");
            } break;
            case AVPlayerItemStatusReadyToPlay: {
                NSLog(@"准好播放了");
                [self.player play];
            } break;
            case AVPlayerItemStatusUnknown: {
                NSLog(@"视频资源出现未知错误");
            } break;
            default: break;
        }
    } else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        NSArray *array = self.player.currentItem.loadedTimeRanges;
        // 本次缓冲的时间范围
        CMTimeRange timeRange = [array.firstObject CMTimeRangeValue];
        // 缓冲总长度
        NSTimeInterval totalBuffer = CMTimeGetSeconds(timeRange.start) + CMTimeGetSeconds(timeRange.duration);
        // 音乐的总时间
        NSTimeInterval duration = CMTimeGetSeconds(self.player.currentItem.duration);
        // 计算缓冲百分比例
        NSTimeInterval scale = totalBuffer / duration;
        //
        NSLog(@"总时长：%f, 已缓冲：%f, 总进度：%f", duration, totalBuffer, scale);
    }
}

//移除监听

- (void)removeObserver
{
    if (self.hasObserver) {
        self.hasObserver = NO;
        
        [self.player.currentItem removeObserver:self forKeyPath:@"status"];
        [self.player.currentItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
        
        [self.player removeTimeObserver:self.timeObserver];
        self.timeObserver = nil;
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    }
}

//添加监听
- (void)addObserver{
    
    self.hasObserver = YES;
    
    // KVO
    // KVO来观察status属性的变化
    [self.player.currentItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    // KVO监测加载情况
    [self.player.currentItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    
    //
    WEAK_SELF(weakSelf)
    self.timeObserver = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        
        weakSelf.duration = CMTimeGetSeconds(weakSelf.player.currentItem.duration);
        if (weakSelf.PlayProgress) {
            weakSelf.PlayProgress(CMTimeGetSeconds(time), weakSelf.duration);
        }
    }];
    
    // 通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playFinish) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}

@end
