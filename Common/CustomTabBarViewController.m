//
//  CustomTabBarViewController.m
//  Tech50
//
//  Created by fyf on 15/5/8.
//  Copyright (c) 2015年 yuanxu. All rights reserved.
//
#import "CustomTabBarViewController.h"

#import "NavigationViewController.h"

#import "MainHomeViewController.h"
#import "UIColor+Utils.h"
//#import "MainScheduleViewController.h"
//#import "ClassTakenViewController.h"
//#import "MainMeViewController.h"

//#import "UIColorDefine.h"
@interface CustomTabBarViewController ()<UITabBarControllerDelegate>
{
    
}
-(void)initViewControllers;

@end

@implementation CustomTabBarViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	self.delegate = self;
    [self initViewControllers];
}

-(void)initViewControllers{
    
//    ClassTakenViewController *courseVC = [ClassTakenViewController allocController];
//    NavigationViewController *courseNav = [[NavigationViewController alloc] initWithRootViewController:courseVC];
//    courseVC.tabBarItem = [self _tabBarItemWithTitle:@"Taken" normalImgName:@"taken_normal" selectedImgName:@"taken_press"];

    MainHomeViewController *classVC = [MainHomeViewController allocController];
    NavigationViewController *classNav = [[NavigationViewController alloc]initWithRootViewController:classVC];
    classVC.tabBarItem = [self _tabBarItemWithTitle:@"Home" normalImgName:@"home_normal" selectedImgName:@"home_press"];

//    MainScheduleViewController * scheduleVC= [MainScheduleViewController allocController];
//    NavigationViewController * scheduleNav = [[NavigationViewController alloc]initWithRootViewController:scheduleVC];
//    scheduleVC.tabBarItem = [self _tabBarItemWithTitle:@"Schedule" normalImgName:@"schedule_normal" selectedImgName:@"schedule_press"];


//    MainMeViewController *settingVC = [MainMeViewController allocController];
//    NavigationViewController *settingNav = [[NavigationViewController alloc]initWithRootViewController:settingVC];
//    settingVC.tabBarItem = [self _tabBarItemWithTitle:@"Me" normalImgName:@"me_normal" selectedImgName:@"me_press"];
    
    self.viewControllers = @[classNav];
}

- (UITabBarItem *)_tabBarItemWithTitle:(NSString *)title normalImgName:(NSString *)normalImgName selectedImgName:(NSString *)selectedImgName{
    
    UITabBarItem * tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:[[UIImage imageNamed:normalImgName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:selectedImgName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorFromHexRGB:@"5A6067"],NSFontAttributeName:[UIFont systemFontOfSize:14]} forState:UIControlStateNormal];
    [tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:kBaseColor} forState:UIControlStateSelected];
    tabBarItem.titlePositionAdjustment = UIOffsetMake(0, 0);
    return tabBarItem;
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
	return YES;
}
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
}

-(void)showTabBar{
    self.selectedViewController.hidesBottomBarWhenPushed = NO;

}
-(void)hiddenTabBar{
    self.selectedViewController.hidesBottomBarWhenPushed = YES;
}

@end
