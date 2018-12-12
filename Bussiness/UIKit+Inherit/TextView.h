//
//  TextView.h
//  KKMY2_U
//
//  Created by 黄磊 on 14-7-23.
//  Copyright (c) 2014年 yangjuanping. All rights reserved.
//  继承UITextView，添加placeholder

#import <UIKit/UIKit.h>


@protocol TextViewDelegate <UITextViewDelegate>
@optional
- (void)textInputTextDidChange:(id<UITextInput>)textInput;

@end

@interface TextView : UITextView

@property (nonatomic, assign) id<TextViewDelegate> delegate;

@property (nonatomic, strong) NSString *placeholder;

@property (nonatomic, assign) int minLength;                // 输入内容最小长度，默认为1
@property (nonatomic, assign) int maxLength;                // 输入内容最大长度，默认为0，表示无长度限制

@property (nonatomic, assign) BOOL inhibitingInput;         // 是否禁止

@property (nonatomic, strong) NSString *inputDescribe;      // 输入框描述

@end
