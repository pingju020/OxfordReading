//
//  Constant.h
//  OxfordReading
//
//  Created by yangjuanping on 2018/6/29.
//  Copyright © 2018年 yangjuanping. All rights reserved.
//

#ifndef Constant_h
#define Constant_h

// 屏幕高度
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kScreenWidth  [UIScreen mainScreen].bounds.size.width

#define kBaseHost       @"https://www.baidu.com"


// 当前IOS版本
#ifndef __CUR_IOS_VERSION
#define __CUR_IOS_VERSION ([[[UIDevice currentDevice] systemVersion] floatValue] * 10000)
#endif

// 定义常用色值
#define kBaseColor HexRGB(@"86AC48")

// 屏幕高度
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kScreenWidth  [UIScreen mainScreen].bounds.size.width
#define kAppWindow (UIWindow *)[[UIApplication sharedApplication].windows objectAtIndex:0]
#define kAppDelegate ((AppDelegate *)[UIApplication sharedApplication].delegate)

#endif /* Constant_h */
