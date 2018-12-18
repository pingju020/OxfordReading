//
//  AppDelegate.m
//  OxfordReading
//
//  Created by yangjuanping on 2018/3/23.
//  Copyright © 2018年 yangjuanping. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "NavigationViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    //默认情况下扬声器播放
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    [audioSession setActive:YES error:nil];
    
    if (@available(iOS 11, *)) {
        [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(-200, 0) forBarMetrics:UIBarMetricsDefault];
    } else {
        [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
    }
    
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    // 设置根控制器
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];//storyboard storyboard的名称
    UIViewController *firstVC = [storyboard instantiateViewControllerWithIdentifier:@"ViewController"];//跳转VC的名称
    
    NavigationViewController *nav=[[NavigationViewController alloc] initWithRootViewController:firstVC];
    firstVC.navigationController.navigationBarHidden = YES;
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];

    // Override point for customization after application launch.
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark 设置全局的锁屏界面和APP交互
-(void)remoteControlReceivedWithEvent:(UIEvent *)event{
    
    switch (event.subtype) {
        case UIEventSubtypeRemoteControlTogglePlayPause: // 暂停 ios6
            [[NSNotificationCenter defaultCenter] postNotificationName:@"PlayOrPause" object:nil];
            break;
            
        case UIEventSubtypeRemoteControlPreviousTrack:  // 上一首
            [[NSNotificationCenter defaultCenter] postNotificationName:@"preBookAction" object:nil];
            break;
            
        case UIEventSubtypeRemoteControlNextTrack: // 下一首
            [[NSNotificationCenter defaultCenter] postNotificationName:@"nextBookAction" object:nil];
            break;
            
        case UIEventSubtypeRemoteControlPlay: //播放
            [[NSNotificationCenter defaultCenter] postNotificationName:@"PlayOrPause" object:nil];
            break;
            
        case UIEventSubtypeRemoteControlPause: // 暂停 ios7
            [[NSNotificationCenter defaultCenter] postNotificationName:@"PlayOrPause" object:nil];
            
            break;
        default:
            break;
    }
    
    
}


@end
