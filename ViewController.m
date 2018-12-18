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
#import "WebViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *account;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UIButton *check;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.account.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"LOGIN_ACCOUNT"];
    self.password.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"LOGIN_PASSWORD"];
    self.check.selected = [[NSUserDefaults standardUserDefaults]boolForKey:@"CHECK_STATE"];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden=YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden=NO;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginAction:(id)sender {
    
    if (!self.check.selected) {
        [XHToast showCenterWithText:@"请阅读并确认《隐私授权协议》" duration:3];
        return;
    }
    
    
    NSString* account = self.account.text;
    NSString* password = self.password.text;
    
    if (account.length<=0) {
        [XHToast showCenterWithText:@"请输入账号" duration:3];
        return;
    }
    
    if (password.length<=0) {
        [XHToast showCenterWithText:@"请输入密码" duration:3];
        return;
    }
    
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
- (IBAction)showInfoAction:(id)sender {
    WebViewController* about = [WebViewController allocController];
    about.title = @"隐私授权协议";
    about.webUrl = @"http://47.97.174.58:8080/banquan.html";
    [self.navigationController pushViewController:about animated:YES];
}

- (IBAction)checkAction:(id)sender {
    self.check.selected = !self.check.selected;
    [[NSUserDefaults standardUserDefaults]setBool:self.check.selected forKey:@"CHECK_STATE"];
}


@end
