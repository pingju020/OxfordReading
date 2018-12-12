//
//  NavigationViewController.h
//  KKMYForU
//
//  Created by 黄磊 on 13-11-22.
//  Copyright (c) 2013年 Rogrand. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NavigationViewController : UINavigationController<UIGestureRecognizerDelegate>

@property (nonatomic, nonatomic) BOOL isViewShow;

@property (nonatomic, nonatomic) BOOL isViewHadShow;        // 是否已经显示过

- (void)showBackButtonWith:(UIViewController *)viewController;
- (void)showBackButtonWith:(UIViewController *)viewController andAction:(SEL)action;
- (void)showBackButtonWith:(UIViewController *)viewController andAction:(SEL)action withOtherBarButtons:(NSArray *)barButtons;

- (UIBarButtonItem *)showLeftButtonWith:(UIViewController *)viewController image:(UIImage *)image action:(SEL)action;
- (UIBarButtonItem *)showRightButtonWith:(UIViewController *)viewController title:(NSString*)title action:(SEL)action;
- (UIBarButtonItem *)showRightButtonWith:(UIViewController *)viewController image:(UIImage *)image action:(SEL)action;

- (BOOL)back;

- (BOOL)clickLeftItem;


@end


/** UIViewController extension */
@interface UIViewController (NavigationViewController)

- (NavigationViewController *)navController;

// The funtion below need be overwrite
/** 是否可以滑出 */
- (BOOL)canSlipOut;
/** 是否可以滑入 */
- (BOOL)canSlipIn;

@end

