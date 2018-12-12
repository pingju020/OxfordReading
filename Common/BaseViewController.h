//
//  BaseViewController.h
//  KKMY2_U
//
//  Created by Lad on 13-4-10.
//  Copyright (c) 2013年 ags. All rights reserved.
//  所有ViewController的基类

#import <UIKit/UIKit.h>
#import "NavigationViewController.h"
#import "ControllerManager.h"
//#import "MBProgressHUD.h"

@interface BaseViewController : UIViewController
{
    //加载框
    //MBProgressHUD *progressHUD;
}

@property (nonatomic, assign) BOOL isWillShow;              // 是否将要显示

@property (nonatomic, assign) BOOL isViewShow;              // 是否正处于显示中

@property (nonatomic, assign) BOOL isViewHadShow;           // 是否已经显示过


/**
 *  加载实例控制器
 *  @return BaseViewController 或 其子类
 */
+ (__kindof BaseViewController *)controller;


- (void)isNeedHidenTabbar:(BOOL)isNeed;
- (void)textInputTextDidChange:(id)textInput;
- (void)deviceDidChanageOrientation:(NSNotification*)notifi;

@end
