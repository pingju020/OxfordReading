//
//  UIViewController+Utils.h
//  KKMYForM
//
//  Created by yangjuanping on 13-11-22.
//  Copyright (c) 2013年 Rogrand. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Utils)

// 界面是否显示，这里必须调用了viewDidAppear才会为Yes
@property (nonatomic, assign) BOOL isViewShow;

@property (nonatomic, nonatomic) BOOL isViewHadShow;        // 是否已经显示过

+ (instancetype)allocController;

/** 界面跳转传值 */
- (void)configWithPushData:(id)data;
/** 使用该数据初始化界面 */
- (void)configWithData:(id)data;

/** 使用附加参数初始化该界面 */
- (void)configWithData:(id)data andAttach:(id)attachData;

/** 使用该数据刷新界面 */
- (void)refreshWithData:(id)data;

@end
