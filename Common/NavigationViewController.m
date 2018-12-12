//
//  NavigationViewController.m
//  KKMYForU
//
//  Created by 黄磊 on 13-11-22.
//  Copyright (c) 2013年 Rogrand. All rights reserved.
//

#import "NavigationViewController.h"
#import "BackNavItem.h"
#include <objc/message.h>
//#import "UIColorDefine.h"
@implementation UIViewController (NavigationViewController)


- (NavigationViewController *)navController
{
    UIViewController *viewController = self.parentViewController;
    while (!(viewController == nil || [viewController isKindOfClass:[NavigationViewController class]]))
    {
        viewController = viewController.parentViewController;
    }
    
    return (NavigationViewController *)viewController;
}

- (BOOL)canSlipOut
{
    return YES;
}

- (BOOL)canSlipIn
{
    return YES;
}


@end

@interface NavigationViewController ()

@end

@implementation NavigationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (id)initWithRootViewController:(UIViewController *)rootViewController
{
    self = [super initWithRootViewController:rootViewController];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    if (__CUR_IOS_VERSION >= __IPHONE_7_0) {
        self.edgesForExtendedLayout= UIRectEdgeTop | UIRectEdgeBottom;
        self.navigationBar.barTintColor =  kBaseColor;
        self.navigationBar.tintColor = [UIColor whiteColor];
        self.interactivePopGestureRecognizer.delegate = self;
    }
    
    NSDictionary *textAttr = [NSDictionary dictionaryWithObjectsAndKeys:
                              [UIColor whiteColor], NSForegroundColorAttributeName,
                              [UIFont systemFontOfSize:16.0f], NSFontAttributeName,nil];
    self.navigationBar.titleTextAttributes = textAttr;
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    _isViewShow = YES;
    _isViewHadShow = YES;
}

-(void)viewWillDisappear:(BOOL)animated
{
    _isViewShow = NO;
    [super viewWillDisappear:animated];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)showBackButtonWith:(UIViewController *)viewController
{
//    UIBarButtonItem *negativeSeperator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
//    negativeSeperator.width = -10;
//    UIBarButtonItem *leftItem = [self createButtonWith:self action:@selector(back)];
//    [viewController.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:leftItem, nil] animated:YES];
}


- (UIBarButtonItem *)showLeftButtonWith:(UIViewController *)viewController image:(UIImage *)image action:(SEL)action
{
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:viewController action:action forControlEvents:UIControlEventTouchUpInside];
    btn.frame = CGRectMake(20, 5, 30, 35);
    [btn setImage:image forState:UIControlStateNormal];
    [btn setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    [viewController.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:leftItem, nil] animated:YES];
    return leftItem;
}


- (UIBarButtonItem *)showRightButtonWith:(UIViewController *)viewController title:(NSString*)title action:(SEL)action
{
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:viewController action:action forControlEvents:UIControlEventTouchUpInside];
    btn.frame = CGRectMake(250, 5, 56, 30);
    UIColor *textColor = [UIColor whiteColor];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn.titleLabel setTextColor:textColor];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [btn setTitleColor:textColor forState:UIControlStateNormal];
//    UIColor *highLightColor = [UIColor colorWithRed:(CGFloat)77.0/255 green:(CGFloat)194.0/255 blue:(CGFloat)167.0/255 alpha:1];
//    [btn setTitleColor:highLightColor forState:UIControlStateHighlighted];
    UIBarButtonItem* rightItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    [viewController.navigationItem setRightBarButtonItem:rightItem];
    return rightItem;
}

- (UIBarButtonItem *)showRightButtonWith:(UIViewController *)viewController image:(UIImage *)image action:(SEL)action
{
    
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:viewController action:action forControlEvents:UIControlEventTouchUpInside];
    btn.frame = CGRectMake(270, 5, 35, 35);

    UIColor *textColor = [UIColor colorWithRed:(CGFloat)77.0/255 green:(CGFloat)194.0/255 blue:(CGFloat)167.0/255 alpha:1];
    UIColor *highLightColor = [UIColor colorWithRed:(CGFloat)209/255 green:(CGFloat)239/255 blue:(CGFloat)231/255 alpha:1];
    [btn setImage:image forState:UIControlStateNormal];
    [btn.titleLabel setTextColor:textColor];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [btn setTitleColor:textColor forState:UIControlStateNormal];
    [btn setTitleColor:highLightColor forState:UIControlStateHighlighted];
    UIBarButtonItem* rightItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    [viewController.navigationItem setRightBarButtonItem:rightItem];
    return rightItem;
}

- (void)showBackButtonWith:(UIViewController *)viewController andAction:(SEL)action
{
    UIBarButtonItem *negativeSeperator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSeperator.width = -10;
    UIBarButtonItem *leftItem = [self createButtonWith:viewController action:action];
    [viewController.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:negativeSeperator, leftItem, nil] animated:YES];
}
- (void)showBackButtonWith:(UIViewController *)viewController andAction:(SEL)action withOtherBarButtons:(NSArray *)barButtons
{
    UIBarButtonItem *negativeSeperator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSeperator.width = -10;
    
    NSMutableArray *buttonList = [NSMutableArray array];
    UIBarButtonItem *leftItem = [self createButtonWith:viewController action:action];
    [buttonList addObject:negativeSeperator];
    [buttonList addObject:leftItem];
    [buttonList addObjectsFromArray:barButtons];
    [viewController.navigationItem setLeftBarButtonItems:buttonList  animated:YES];
}
- (UIBarButtonItem *)createButtonWith:(id)target action:(SEL)action
{
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];

    btn.frame = CGRectMake(20, 5, 30, 35);
    [btn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [btn setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    UIBarButtonItem*  backNav = leftItem;
    return backNav;
}


- (BOOL)back
{
    if (self.viewControllers.count > 1) {
        if ([[self.viewControllers lastObject] isViewHadShow]) {
            [self popViewControllerAnimated:YES];
            return YES;
        }
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
        return YES;
    }
    return NO;
}


- (BOOL)clickLeftItem
{
    UIViewController *aVC = self.theTopViewController;
    if (self.viewControllers.count > 0) {
        if ([[self.viewControllers lastObject] isViewHadShow]) {
            UIBarButtonItem *leftItem = aVC.navigationItem.leftBarButtonItem;
            if ([leftItem isKindOfClass:[BackNavItem class]]) {
                    BackNavItem *backNav = (BackNavItem *)leftItem;
                    [backNav backClick];
                    [NSObject cancelPreviousPerformRequestsWithTarget:aVC];
                    return YES;
//            if ([leftItem.target respondsToSelector:leftItem.action]) {
//               AFHTTPRequestOperationManager * requestOperationManager = [AFHTTPRequestOperationManager manager];
//                [self performSelector:@selector(cancelALL:) withObject:requestOperationManager.operationQueue afterDelay:0];
//                objc_msgSend(leftItem.target, leftItem.action, leftItem);
//            }
            }
        }
    }
    return NO;
}
- (void)cancelALL:(id)obj
{
    /*
    obj = (NSOperationQueue *)[AFHTTPSessionManager manager].operationQueue;
    [obj cancelAllOperations];
     */
}
- (UIViewController *)theTopViewController
{
    UIViewController *topVC = self.topViewController;
    while ([topVC isKindOfClass:[UINavigationController class]] || [topVC isKindOfClass:[UITabBarController class]]) {
        if ([topVC isKindOfClass:[UITabBarController class]]) {
            topVC = ((UITabBarController *)topVC).selectedViewController;
        } else {
            UINavigationController *navVC = (UINavigationController *)topVC;
            topVC = navVC.topViewController;
        }
    }
    return topVC;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (self.viewControllers.count == 1) {             //关闭主界面的右滑返回
        return NO;
    } else {
        UIViewController *lastVC = self.viewControllers.lastObject;
        UIViewController *secondLastVC = self.viewControllers[self.viewControllers.count-2];
        if ([lastVC canSlipOut] && [secondLastVC canSlipIn]) {
            return YES;
        } else {
            return NO;
        }
    }
}

//!< 颜色处理
-(UIImage *)imageWithBgColor:(UIColor *)color {
    
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
    
}
@end
