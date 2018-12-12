//
//  ViewController.m
//  OxfordReading
//
//  Created by yangjuanping on 2018/3/23.
//  Copyright © 2018年 yangjuanping. All rights reserved.
//

#import "ViewController.h"
#import "CustomTabBarViewController.h"
#import "NavigationViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginAction:(id)sender {
    CustomTabBarViewController *VC = [[CustomTabBarViewController alloc]init];
    VC.hidesBottomBarWhenPushed = YES;
    
    NavigationViewController *nav = [[NavigationViewController alloc] initWithRootViewController:VC];
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    VC.navigationController.navigationBarHidden = YES;
    
    window.rootViewController = nav;
}


@end
