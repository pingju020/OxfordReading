//
//  AudioPlayerManager.h
//  OxfordReading
//
//  Created by yangjuanping on 2018/12/12.
//  Copyright © 2018 yangjuanping. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AudioPlayerManager : NSObject
@property (assign,nonatomic) CGFloat duration;
@property (strong,nonatomic) void (^PlayProgress)(CGFloat currentTime, CGFloat totalTime);
@property (strong,nonatomic) void (^playFinished)(void);

+ (AudioPlayerManager *)sharedManager;
-(void)changePlayItem:(NSString*)itemPath;

-(void)play;

-(void)pause;

-(void)changePlayTime:(NSInteger)second;

@end

NS_ASSUME_NONNULL_END
