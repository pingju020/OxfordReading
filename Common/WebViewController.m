//
//  WebViewController.m
//  KKMYForU
//
//  Created by 黄磊 on 14-1-13.
//  Copyright (c) 2014年 Rogrand. All rights reserved.
//

#define WEB_REQUEST_TIMEOUT 30

#import "WebViewController.h"
//#import "BackNavItem.h"
#import "NSString+Utils.h"
#import <JavaScriptCore/JavaScriptCore.h>
//#import "NSDictionary+Utils.h"
//#import "JSONKit.h"
#import "WebManager.h"
#import "UserManager.h"
@interface WebViewController ()
{
    UIButton *btnClose;
}

@property (nonatomic, strong) NSMutableString *executeStr;
@property (nonatomic, assign) BOOL isWebLoaded;
@property (nonatomic, strong) WebManager *manager;
@property (nonatomic, strong) CALayer *progressLayer;
@end

@implementation WebViewController
@synthesize webUrl =_webUrl;
@synthesize navTitle =_navTitle;


- (id)init
{
    self = [super init];
    if (self) {
        self.superHanderUrl = YES;
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.superHanderUrl = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    if (self.navTitle.length > 0) {
        self.navigationItem.title = self.navTitle;
    }

    _isWebLoaded = NO;
    _executeStr = [[NSMutableString alloc] init];
    self.wkWebView = [[WKWebView alloc] init];
    [self.wkWebView setFrame:self.view.bounds];
    [self.wkWebView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    [self.wkWebView setNavigationDelegate:self];
    [self.wkWebView setUIDelegate:self];
    [self.wkWebView setMultipleTouchEnabled:YES];
    [self.wkWebView setAutoresizesSubviews:YES];
    [self.wkWebView.scrollView setAlwaysBounceVertical:YES];
    [self.view addSubview:self.wkWebView];
    [self addProgressLayer];

    btnClose = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 35)];
    btnClose.hidden = YES;
    [btnClose setTitle:@"关闭" forState:UIControlStateNormal];
    [btnClose addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barBtnClose = [[UIBarButtonItem alloc] initWithCustomView:btnClose];
    [self.navController showBackButtonWith:self andAction:@selector(back) withOtherBarButtons:@[barBtnClose]];
    
    UIScrollView *aScrollView = (UIScrollView *)[[_wkWebView subviews] objectAtIndex:0];

    [aScrollView setBounces:NO];
    [aScrollView setBackgroundColor:[UIColor clearColor]];
    NSArray *subViews = aScrollView.subviews;
    if (aScrollView.subviews.count > 0) {
        UIView *contentView = [subViews objectAtIndex:0];
        [contentView setBackgroundColor:[UIColor clearColor]];
    }
        // 加载网页文件
    NSLog(@"%@", _webUrl);
    [self loadUrl:_webUrl withParameters:self.params];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.wkWebView addObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress)) options:NSKeyValueObservingOptionNew context:nil];
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.wkWebView removeObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress))];

}
- (void)addProgressLayer{
    UIView *progress = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 3)];
    progress.backgroundColor = [UIColor clearColor];
    [self.view addSubview:progress];

    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(0, 0, 0, 3);
    layer.backgroundColor = [UIColor greenColor].CGColor;
    [progress.layer addSublayer:layer];
    self.progressLayer = layer;
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        self.progressLayer.opacity = 1;
            //不要让进度条倒着走...有时候goback会出现这种情况
        if ([change[@"new"] floatValue] < [change[@"old"] floatValue]) {
            return;
        }
        self.progressLayer.frame = CGRectMake(0, 0, self.view.bounds.size.width * [change[@"new"] floatValue], 3);
        if ([change[@"new"] floatValue] == 1) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.progressLayer.opacity = 0;
            });
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.progressLayer.frame = CGRectMake(0, 0, 0, 3);
            });
        }
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)dealloc{
    [self.wkWebView setNavigationDelegate:nil];
    [self.wkWebView setUIDelegate:nil];
}

- (void)refreshWithData:(id)data
{
    [self configWithData:data];
    [self refreshWithUrl:self.webUrl];
}

- (BOOL)canSlipOut
{
    return !_hideNav;
}

#pragma mark - Action

- (void)back
{
   [self navBack];
}

- (void)navBack{
    if ([_wkWebView canGoBack]) {
        btnClose.hidden = YES;
        [_wkWebView goBack];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_wkWebView reload];
        });
        return;
    }
    [self.navController back];
    if(_backBlock){
        _backBlock();
    }
}

- (NSString *)assembleUrl:(NSString *)url parameters:(NSDictionary *)parameters
{
    NSMutableString *requestUrl = [NSMutableString stringWithString:url];
    NSMutableString *parameterStr = [NSMutableString stringWithString:@""];
    NSArray *allkeys = [parameters allKeys];
    for (NSString *aKey in allkeys) {
        [parameterStr appendFormat:@"%@=%@&", aKey, [parameters objectForKey:aKey]];
    }
    NSString *parameter = parameterStr;
    if([parameterStr hasSuffix:@"&"]){
        parameter = [parameterStr substringWithRange:NSMakeRange(0, parameterStr.length-1)];
    }
    if (parameter.length > 0) {
        if ([requestUrl rangeOfString:@"?"].length == 0) {
            [requestUrl appendString:@"\?"];
        } else {
            if (![requestUrl hasSuffix:@"&"]) {
                [requestUrl appendString:@"&"];
            }
        }
        [requestUrl appendString:parameter];
    }
    return [NSString URLencode:requestUrl stringEncoding:NSUTF8StringEncoding];
}

- (void)loadUrl:(NSString *)url withParameters:(NSDictionary *)parameters
{
    if (url.length == 0) {
        NSLog(@"Cannot Load an empty url");
        return;
    }

    if ([url hasPrefix:@"http"]) {
        [self refreshWithUrl:[self assembleUrl:url parameters:parameters]];
    } else {
        // 本地网页
        NSString *path = [[NSBundle mainBundle] bundlePath];
        NSURL *baseURL = [NSURL fileURLWithPath:path];
        [_wkWebView loadHTMLString:_webUrl baseURL:baseURL];
    }
    
}

- (void)refreshWithUrl:(NSString *)url
{
    _isWebLoaded = NO;
    _executeStr = [[NSMutableString alloc] init];
    NSURLRequestCachePolicy cachePolicy = NSURLRequestReloadIgnoringCacheData;
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url] cachePolicy:cachePolicy timeoutInterval:WEB_REQUEST_TIMEOUT];
    NSString *parameter = request.URL.query;
    if (self.needLoadJSPOST && parameter.length>0) {
        NSMutableData *body = [NSMutableData data];
        [body appendData:
         [parameter dataUsingEncoding:NSUTF8StringEncoding]];
        NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[body length]];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:body];
    }

    [request setValue:[UserManager shareInstance].token forHTTPHeaderField:@"token"];
    [self refreshWithRequest:request];
}

- (void)refreshWithRequest:(NSMutableURLRequest *)request
{
    _isWebLoaded = NO;
    _executeStr = [[NSMutableString alloc] init];
    NSLog(@"Load Url : {%@}", request);
    [_wkWebView loadRequest:request];
}

- (void)executeThisJS:(NSString *)jsSentence
{
    if (_isWebLoaded == NO) {
        [_executeStr appendString:@";"];
        [_executeStr appendString:jsSentence];
        return;
    }
    [self.wkWebView evaluateJavaScript:jsSentence completionHandler:nil];

}

#pragma mark - WKNavigationDelegate

// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {

    _isWebLoaded = YES;
}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation
      withError:(NSError *)error {
    if ([error code] == NSURLErrorCancelled || [error code]==101)
    {
        return;
    }
    [self.navigationController setNavigationBarHidden:NO animated:YES];

}


// 在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {

    NSString *requestStr = [[navigationAction.request.URL absoluteString] stringByRemovingPercentEncoding];
    NSLog(@"Load URL : %@ ", navigationAction.request.URL);
    NSLog(@"requestStr : %@ ", requestStr);
//    if ([requestStr hasPrefix:@"CNT://"]) {
//        NSDictionary *paramStr = [[requestStr substringFromIndex:6] objectFromJSONString];
//        NSLog(@"paramStr: %@",paramStr);
//        self.manager.webController = self;
//        [self.manager routeManager:[[Route alloc] initWithDictionary:paramStr error:nil]];
//        decisionHandler(WKNavigationActionPolicyCancel);
//        return;
//    }

    decisionHandler(WKNavigationActionPolicyAllow);
}




#pragma mark - WKUIDelegate
// 创建一个新的WebView
- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures{
    if (!navigationAction.targetFrame.isMainFrame) {
        [webView loadRequest:navigationAction.request];
    }
    return nil;
}
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler
{

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:message
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定"
                                                        style:UIAlertActionStyleCancel
                                                      handler:^(UIAlertAction *action) {
                                                          completionHandler();
                                                      }]];
    [self presentViewController:alertController animated:YES completion:^{}];
}
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler{

    NSString *hostString = webView.URL.host;
    NSString *sender = [NSString stringWithFormat:@"%@", hostString];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:sender message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        completionHandler(NO);
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        completionHandler(YES);
    }]];
    [self presentViewController:alertController animated:YES completion:^{}];
}

- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * __nullable result))completionHandler {
    
    NSString *hostString = webView.URL.host;
    NSString *sender = [NSString stringWithFormat:@"%@", hostString];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:sender message:prompt preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.text = defaultText;
    }];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        completionHandler(nil);
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        NSString *input = ((UITextField *)alertController.textFields.firstObject).text;
        completionHandler(input);
    }]];
    [self presentViewController:alertController animated:YES completion:^{}];
}

-(void)closeAction{
    [self.navController back];
}

- (WebManager *)manager{
    if (!_manager) {
        _manager = [[WebManager alloc] init];
    }
    return _manager;
}
@end
