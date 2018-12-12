//
//  ControllerManager.m
//  KKMY_U
//
//  Created by 黄磊 on 14/12/18.
//  Copyright (c) 2014年 Rogrand. All rights reserved.
//

#import "ControllerManager.h"
#import "BaseViewController.h"
#import "AppDelegate.h"
//#import "LoginViewController.h"
#import "CustomTabBarViewController.h"

static ControllerManager *s_controllerManager = nil;

@interface ControllerManager ()

@property (nonatomic, strong) NSMutableDictionary *dicForListVC;
@property (nonatomic, strong) NSMutableDictionary *dicVCs;


@end

@implementation ControllerManager

+ (ControllerManager *)shareInstant
{
    if (s_controllerManager == nil)
    {
        s_controllerManager = [[ControllerManager alloc] init];
        
    }
    return s_controllerManager;
}

- (id)init
{
    self = [super init];
    if (self) {
        _dicVCs = [[NSMutableDictionary alloc] init];
    }
    return self;
}

#pragma mark - ViewCotroller

+ (UIViewController *)getRootViewController
{
    UINavigationController *navVC = (UINavigationController *)kAppDelegate.window.rootViewController;
    LogInfo(@"getRootViewController:%@",navVC.topViewController);
    return  navVC.topViewController;

}

+ (UINavigationController *)rootNavViewController
{
    UINavigationController *navVC = (UINavigationController *)kAppDelegate.window.rootViewController;
	if ([navVC.topViewController isKindOfClass:[CustomTabBarViewController class]]) {
		CustomTabBarViewController *tabbar = (CustomTabBarViewController *)navVC.topViewController;
		navVC = (UINavigationController*)tabbar.selectedViewController;
	}
    LogInfo(@"rootNavViewController:%@",navVC);
    return navVC;
}

+ (UIViewController *)topViewController
{
    UIViewController *topVC = nil;
    UINavigationController *navVC = (UINavigationController *)kAppDelegate.window.rootViewController;
	if ([navVC.topViewController isKindOfClass:[CustomTabBarViewController class]]) {
		CustomTabBarViewController *tabbar = (CustomTabBarViewController *)navVC.topViewController;
		topVC = tabbar.selectedViewController;
	}
	if ([topVC isKindOfClass:[UINavigationController class]]) {
		navVC = (UINavigationController*)topVC;
	}
    while (navVC.presentedViewController != nil) {
        navVC = (UINavigationController *)navVC.presentedViewController;
    }
    //当前为UIAlertViewController时没有topViewController方法，如果不判断，会crash
    if([navVC respondsToSelector:@selector(topViewController)]){
        topVC = navVC.topViewController;
    }
    while ([topVC respondsToSelector:@selector(topViewController)]) {
        UINavigationController *navVC = (UINavigationController *)topVC;
        if([navVC respondsToSelector:@selector(topViewController)]){
            topVC = navVC.topViewController;
        }
    }
    LogInfo(@"topViewController:%@",topVC);
    return topVC;
}

+ (UINavigationController *)topNavViewController
{
    UINavigationController *topVC = nil;
    topVC = (UINavigationController *)kAppDelegate.window.rootViewController;
	if ([topVC.topViewController isKindOfClass:[CustomTabBarViewController class]]) {
		CustomTabBarViewController *tabbar = (CustomTabBarViewController *)topVC.topViewController;
		topVC = tabbar.selectedViewController;
	}
    UIViewController *presentVC = topVC.presentedViewController;
    if (presentVC && [presentVC isKindOfClass:[UINavigationController class]]) {
        topVC = (UINavigationController *)presentVC;
    }
    LogInfo(@"topNavViewController:%@",topVC);
    return topVC;
}

+ (BOOL)isInTabBarNav
{
    return [[self topViewController] isEqual:[[self topNavViewController].viewControllers firstObject]];
}


+ (BOOL)isInRootView
{
    UITabBarController *tabBarVC = (UITabBarController *)self.getRootViewController;
    if ([tabBarVC presentedViewController] == nil) {
        return YES;
    }
    return NO;
}

+ (void)popToRootViewController
{
    [self popToRootViewControllerAnimated:YES];
}

+ (void)popToRootViewControllerAnimated:(BOOL)animated
{
	UINavigationController __block *navVC = [ControllerManager topNavViewController];
    if (navVC.presentedViewController != nil) {
        [navVC dismissViewControllerAnimated:animated completion:nil];
    }
    if(navVC.presentingViewController != nil){
        [navVC popToRootViewControllerAnimated:YES];
        [navVC dismissViewControllerAnimated:NO completion:^{
            navVC = nil;
            return ;
        }];
    }
    if (navVC.viewControllers.count > 1) {
        [navVC popToRootViewControllerAnimated:animated];
    }
}

+ (UIViewController *)getViewControllerWithName:(NSString *)aVCName
{
    if (aVCName.length == 0) {
        return nil;
    }
    Class classVC = NSClassFromString(aVCName);
    if (classVC) {
            // 存在该类
        UIViewController *aVC = [classVC allocController];
        if (aVC) {
             return aVC;
        }
    }
    return nil;
}

+ (UIViewController *)getUniqueViewControllerWithName:(NSString *)aVCName
{
    NSMutableDictionary *dicVCs = [[self shareInstant] dicVCs];
    UIViewController *aVC = [dicVCs objectForKey:aVCName];
    if (aVC) {
        return aVC;
    }
    aVC = [self getViewControllerWithName:aVCName];
    if (aVC) {
        [dicVCs setObject:aVC forKey:aVCName];
    }
    return aVC;
}



@end
