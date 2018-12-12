//
//  ControllerManager.h
//  KKMY_U
//
//  Created by 黄磊 on 14/12/18.
//  Copyright (c) 2014年 Rogrand. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ControllerManager : NSObject
#pragma mark - ViewCotroller


+ (UIViewController *)getRootViewController;

+ (UINavigationController *)rootNavViewController;

+ (UIViewController *)topViewController;

+ (UINavigationController *)topNavViewController;
+ (BOOL)isInTabBarNav;
+ (BOOL)isInRootView;

+ (void)popToRootViewController;

+ (void)popToRootViewControllerAnimated:(BOOL)animated;
+ (UIViewController *)getUniqueViewControllerWithName:(NSString *)aVCName;
+ (UIViewController *)getViewControllerWithName:(NSString *)aVCName;


@end
