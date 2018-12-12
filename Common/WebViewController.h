//
//  WebViewController.h
//  KKMYForU
//
//  Created by 黄磊 on 14-1-13.
//  Copyright (c) 2014年 Rogrand. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import <WebKit/WebKit.h>

@interface WebViewController : BaseViewController <WKNavigationDelegate, WKUIDelegate>

@property (nonatomic, strong) WKWebView *wkWebView;
@property (nonatomic, strong) NSString *webUrl;
@property (nonatomic, strong) NSString *navTitle;
@property (nonatomic, assign) BOOL hideNav;
@property (nonatomic, assign) BOOL superHanderUrl;      // 是否有父类处理url
@property (nonatomic, strong) void (^backBlock)(void);//返回回调
@property (nonatomic, assign) BOOL needLoadJSPOST;//是否使用post
@property (nonatomic, strong) NSDictionary *params;
- (NSString *)assembleUrl:(NSString *)url parameters:(NSDictionary *)parameters;

- (void)loadUrl:(NSString *)url withParameters:(NSDictionary *)parameters;

- (void)refreshWithUrl:(NSString *)url;

- (void)refreshWithRequest:(NSURLRequest *)request;

// 直接执行js语句
- (void)executeThisJS:(NSString *)jsSentence;

@end
