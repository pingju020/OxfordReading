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
#import "XHToast.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *account;
@property (weak, nonatomic) IBOutlet UITextField *password;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.account.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"LOGIN_ACCOUNT"];
    self.password.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"LOGIN_PASSWORD"];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginAction:(id)sender {
    
    NSString* account = self.account.text;
    NSString* password = self.password.text;
    BOOL login = NO;
    if ([account isEqualToString:@"yangyichen"]&&[password isEqualToString:@"1234"]) {
        login = YES;
    }
    else if ([account isEqualToString:@"xumeiqing"]&&[password isEqualToString:@"1234"]) {
        login = YES;
    }
    
    else if ([account isEqualToString:@"zhanghe"]&&[password isEqualToString:@"1234"]) {
        login = YES;
    }
    
    else if ([account isEqualToString:@"yangyuke"]&&[password isEqualToString:@"1234"]) {
        login = YES;
    }
    
    else if ([account isEqualToString:@"yangyulan"]&&[password isEqualToString:@"1234"]) {
        login = YES;
    }
    
    
    if (login) {
        [[NSUserDefaults standardUserDefaults] setObject:account forKey:@"LOGIN_ACCOUNT"];
        [[NSUserDefaults standardUserDefaults] setObject:password forKey:@"LOGIN_PASSWORD"];
        
        CustomTabBarViewController *VC = [[CustomTabBarViewController alloc]init];
        VC.hidesBottomBarWhenPushed = YES;
        
        NavigationViewController *nav = [[NavigationViewController alloc] initWithRootViewController:VC];
        UIWindow *window = [UIApplication sharedApplication].delegate.window;
        VC.navigationController.navigationBarHidden = YES;
        
        window.rootViewController = nav;
    }
    else{
        [XHToast showCenterWithText:@"账号或密码输入错误，请重新输入" duration:3];
    }
    
}


@end
