//
//  BackNavItem.h
//  KKMYForU
//
//  Created by 黄磊 on 13-11-5.
//  Copyright (c) 2013年 Rogrand. All rights reserved.
//  导航栏返回键

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, UIBackNavType)
{
    UIBackNavDefault,
    UIBackNavWhite
};

@interface BackNavItem : UIBarButtonItem

- (id)initWithTitle:(NSString *)title type:(UIBackNavType)type target:(id)target action:(SEL)action;

- (void)backClick;

@end
