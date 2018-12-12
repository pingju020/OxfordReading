//
//  TextField.h
//  KKMY2_U
//
//  Created by 黄磊 on 14-5-3.
//  Copyright (c) 2014年 yangjuanping. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TextFieldDelegate <UITextFieldDelegate>

- (void)textInputTextDidChange:(id<UITextInput>)textInput;

@end

@interface TextField : UITextField

@property (nonatomic, assign) id<TextFieldDelegate> delegate;

@property (nonatomic, assign) float paddingLeft;            // default is 10
@property (nonatomic, assign) float paddingRight;           // default is 10

@property (nonatomic, assign) int minLength;                // 输入内容最小长度，默认为1
@property (nonatomic, assign) int maxLength;                // 输入内容最大长度，默认为0，表示无长度限制

@property (nonatomic, assign) BOOL inhibitingInput;         // 是否禁止

@property (nonatomic, strong) NSString *inputDescribe;      // 输入框描述

@end
