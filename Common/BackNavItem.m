//
//  BackNavItem.m
//  KKMYForU
//
//  Created by 黄磊 on 13-11-5.
//  Copyright (c) 2013年 Rogrand. All rights reserved.
//

#import "BackNavItem.h"

@interface BackNavItem  ()

@property (nonatomic, strong) UIImageView *leftImageView;

@property (nonatomic, strong) UIButton *btnBack;

@end

@implementation BackNavItem

//@synthesize leftImageView = _leftImageView;

- (id)initWithTitle:(NSString *)title style:(UIBarButtonItemStyle)style target:(id)target action:(SEL)action
{
    self = [super initWithTitle:title style:style target:target action:action];
    if (self)
    {
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_6_0
        [self configSelfWithTitle:title type:UIBackNavDefault target:target action:action];
#else
        if (__CUR_IOS_VERSION >= __IPHONE_6_0)
        {
            [self configSelfWithTitle:title type:UIBackNavDefault target:target action:action];
        }
        else
        {
            [self configSelfWithTitle:title type:UIBackNavWhite target:target action:action];
        }
#endif
    }
    return self;
}

- (id)initWithTitle:(NSString *)title type:(UIBackNavType)type target:(id)target action:(SEL)action
{
    self = [super initWithTitle:title style:UIBarButtonItemStylePlain target:target action:action];
    if (self)
    {
        [self configSelfWithTitle:title type:type target:target action:action];
    }
    return self;
}

- (void)backClick
{
    if (_btnBack) {
        [_btnBack sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)configSelfWithTitle:(NSString *)title type:(UIBackNavType)type target:(id)target action:(SEL)action
{
//    UIColor *textColor = [UIColor colorWithRed:(CGFloat)77.0/255 green:(CGFloat)194.0/255 blue:(CGFloat)167.0/255 alpha:1];
    UIColor *textColor =[UIColor orangeColor];
    UIColor *highLightColor = [UIColor colorWithRed:(CGFloat)209/255 green:(CGFloat)239/255 blue:(CGFloat)231/255 alpha:1];
    NSString *backImage = @"btn_back_color";
    if (type == UIBackNavWhite)
    {
        textColor = [UIColor whiteColor];
        highLightColor = [UIColor lightGrayColor];
        backImage = @"nav_back_white";
    }
    
    
    // modified by xia zhiyong 1217
    _btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnBack setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    _btnBack.frame = CGRectMake(0, 5, 40, 30);
    [_btnBack setTitle:title forState:UIControlStateNormal];
    [_btnBack.titleLabel setTextColor:textColor];
    [_btnBack.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [_btnBack setTitleColor:textColor forState:UIControlStateNormal];
    [_btnBack setTitleColor:highLightColor forState:UIControlStateHighlighted];
    _btnBack.contentEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    if (__CUR_IOS_VERSION >= __IPHONE_7_0)
    {
        _btnBack.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        _btnBack.imageEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 30);
    }
    else
    {
        _btnBack.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        _btnBack.imageEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 30);
    }
    [_btnBack setImage:[UIImage imageNamed:backImage] forState:UIControlStateNormal];
    [_btnBack addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [self setCustomView:_btnBack];
}

@end
