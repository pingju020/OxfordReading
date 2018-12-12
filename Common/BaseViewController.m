//
//  BaseViewController.m
//  KKMY2_U
//
//  Created by Lad on 13-4-10.
//  Copyright (c) 2013年 ags. All rights reserved.
//

#import "BaseViewController.h"
#import "InterfaceManager.h"
#import "UIColor+Utils.h"
#import <objc/runtime.h>
#import "UITextField+Utils.h"
#import "UITextView+Utils.h"
#import "TextView.h"
#import "TextField.h"
@interface BaseViewController ()

@end

@implementation BaseViewController


+ (__kindof BaseViewController *)controller{
    
    NSString * xibPath = [[NSBundle mainBundle] pathForResource:NSStringFromClass([self class]) ofType:@"nib"];
    if (xibPath) {
        return [[self alloc] initWithNibName:NSStringFromClass([self class]) bundle:nil];
    }else{
        return [[self alloc] init];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    LogTrace(@"  ==>> %@ did load", NSStringFromClass([self class]));
    // 返回按钮统一设置
    if (self.navController != nil && self.navController.viewControllers.count > 1) {
        [self.navigationController setNavigationBarHidden:NO];
        [self.navController showBackButtonWith:self];
    }
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceDidChanageOrientation:) name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)deviceDidChanageOrientation:(NSNotification*)notifi{
 
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
}
- (void)viewWillAppear:(BOOL)animated
{
    LogTrace(@"   >>>>>>{ %@ } will appear", NSStringFromClass([self class]));
    [super viewWillAppear:animated];
    [BaseViewController hideNaviBottomLine:NO withController:self];
    _isWillShow = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    LogTrace(@"   >>>>>>{ %@ } did appear", NSStringFromClass([self class]));
    [super viewDidAppear:animated];
    _isViewShow = YES;
    _isViewHadShow = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(theTextChange:) name:UITextFieldTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(theTextChange:) name:UITextViewTextDidChangeNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    LogTrace(@"<<<<<<{ %@ } will disappear", NSStringFromClass([self class]));
    _isViewShow = NO;
    _isWillShow = NO;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:nil];
    [BaseViewController hideNaviBottomLine:YES withController:self];
    [super viewWillDisappear:animated];
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    LogTrace(@"<<<<<<{ %@ } did disappear", NSStringFromClass([self class]));
    [super viewDidDisappear:animated];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    LogError(@":%@ receive memory warning!!!", NSStringFromClass([self class]));
    // Dispose of any resources that can be recreated.
}


- (void)isNeedHidenTabbar:(BOOL)isNeed
{
    //isNeed = NO;//高保真不需隐藏工具栏
    float originY = isNeed ? 480:431;
    
    [UIView beginAnimations:nil context:NULL] ;
    [UIView setAnimationDuration:0.3];
    for(UIView *view in self.tabBarController.view.subviews)
    {
        if([view isKindOfClass:[UITabBar class]])
        {
            [view setFrame:CGRectMake(view.frame.origin.x, originY, view.frame.size.width, view.frame.size.height)];
        }
        else
        {
            [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width,originY)];
        }
    }
    [UIView commitAnimations];
}

#pragma mark - TextInput

- (void)theTextChange:(NSNotification *)sender
{
    [self textInputTextDidChange:sender.object];
}
- (void)textInputTextDidChange:(id)textInput{
    NSLog(@"textinput object:%@",textInput);
}

+(void)hideNaviBottomLine:(BOOL )isHide withController:(UIViewController *)controller{
    if ([controller.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]){
        NSArray *list=controller.navigationController.navigationBar.subviews;
        if(__CUR_IOS_VERSION>=__IPHONE_10_0){
            if (list.count>0) {
                UIView *view = list[0];
                for (UIView *obj in view.subviews) {
                    if ([obj isKindOfClass:[UIImageView class]] && obj.bounds.size.height<1) {
                        obj.hidden = isHide;
                        break;
                    }
                }
            }
        }else{
            for (id obj in list) {
                if ([obj isKindOfClass:[UIImageView class]]) {
                    UIImageView *imageView=(UIImageView *)obj;
                    NSArray *list2=imageView.subviews;
                    for (id obj2 in list2) {
                        if ([obj2 isKindOfClass:[UIImageView class]]) {
                            UIImageView *imageView2=(UIImageView *)obj2;
                            imageView2.hidden=isHide;
                            break;
                        }
                    }
                }
            }
        }
    }
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

-(BOOL)shouldAutorotate
{
    return NO;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return  UIInterfaceOrientationPortrait |
    UIInterfaceOrientationPortraitUpsideDown |
    UIInterfaceOrientationLandscapeLeft   |
    UIInterfaceOrientationLandscapeRight;
    
}

@end
