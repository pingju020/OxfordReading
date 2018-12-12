//
//  UITextView+Utils.h
//  KKMY2_U
//
//  Created by yangjuanping on 14-8-4.
//  Copyright (c) 2014年 yangjuanping. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextView (Utils)

@property (nonatomic, assign) int minLength;                // 输入内容最小长度，默认为1
@property (nonatomic, assign) int maxLength;                // 输入内容最大长度，默认为0，表示无长度限制

@property (nonatomic, assign) BOOL inhibitingInput;         // 是否禁止

@property (nonatomic, strong) NSString *inputDescribe;      // 输入框描述

// 检查该文本框的内容，包括长度和是否存在特殊字符，返回为nil则通过检查，否则未通过
- (NSString *)checkContent;

// 清楚所有内容
- (void)clearContent;

@end
