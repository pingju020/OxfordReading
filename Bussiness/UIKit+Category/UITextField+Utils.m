//
//  UITextField+Utils.m
//  KKMY2_U
//
//  Created by yangjuanping on 14-8-4.
//  Copyright (c) 2014年 yangjuanping. All rights reserved.
//

#import "UITextField+Utils.h"
#import "NSString+Utils.h"

@implementation UITextField (Utils)

- (int)minLength
{
    return 1;
}

- (void)setMinLength:(int)minLength
{
    LogInfo(@"This function need be overwrite by [%@]", NSStringFromClass([self class]));
}

- (int)maxLength
{
    return 0;
}

- (void)setMaxLength:(int)maxLength
{
    LogInfo(@"This function need be overwrite by [%@]", NSStringFromClass([self class]));
}

- (NSString *)inputDescribe
{
    return nil;
}

- (void)setInputDescribe:(NSString *)inputDescribe
{
    LogInfo(@"This function need be overwrite by [%@]", NSStringFromClass([self class]));
}

- (BOOL)inhibitingInput
{
    return NO;
}

- (void)setInhibitingInput:(BOOL)inhibitingInput
{
    LogInfo(@"This function need be overwrite by [%@]", NSStringFromClass([self class]));
}


- (NSRange)selectedRange
{
    UITextPosition* beginning = self.beginningOfDocument;
    
    UITextRange* selectedRange = self.selectedTextRange;
    UITextPosition* selectionStart = selectedRange.start;
    UITextPosition* selectionEnd = selectedRange.end;
    
    const NSInteger location = [self offsetFromPosition:beginning toPosition:selectionStart];
    const NSInteger length = [self offsetFromPosition:selectionStart toPosition:selectionEnd];
    
    return NSMakeRange(location, length);
}

- (void)setSelectedRange:(NSRange)selectedRange
{
    UITextPosition* beginning = self.beginningOfDocument;
    
    UITextPosition* startPosition = [self positionFromPosition:beginning offset:selectedRange.location];
    UITextPosition* endPosition = [self positionFromPosition:beginning offset:selectedRange.location + selectedRange.length];
    UITextRange* selectionRange = [self textRangeFromPosition:startPosition toPosition:endPosition];
    
    [self setSelectedTextRange:selectionRange];
}

- (NSString *)checkContent
{
    // 检查是否为空
    NSString *descreibe = self.inputDescribe?self.inputDescribe:@"内容";
    if (self.minLength > 0) {
        if ([self.text trim].length <= 0) {
            return [NSString stringWithFormat:@"请输入%@", descreibe];
        }
    }
    if (self.minLength == self.maxLength && self.text.length != self.minLength) {
        return [NSString stringWithFormat:@"%@长度需控制在%d个字符", descreibe, self.minLength];
    }
    // 检查长度
    if (self.text.length < self.minLength) {
        return [NSString stringWithFormat:@"%@长度需控制在%d到%d个字符以内", descreibe, self.minLength, self.maxLength];
    }
    if (self.maxLength > 0 && self.text.length > self.maxLength) {
        return [NSString stringWithFormat:@"%@长度需控制在%d到%d个字符以内", descreibe, self.minLength, self.maxLength];
    }
    // 检查特殊字符
    if ([self.text isContainsSpecialString]) {
        return [NSString stringWithFormat:@"%@暂不支持特殊字符，请重新填写", descreibe];
    }
    return nil;
}

- (void)clearContent
{
    self.text = @"";
    self.inhibitingInput = NO;
}

@end
