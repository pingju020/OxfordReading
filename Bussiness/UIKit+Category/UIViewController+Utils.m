//
//  UIViewController+Utils.m
//  KKMYForU
//
//  Created by yangjuanping on 13-11-22.
//  Copyright (c) 2013年 Rogrand. All rights reserved.
//

#import "UIViewController+Utils.h"
#import "BaseViewController.h"

@implementation UIViewController (Utils)

+ (instancetype)allocController{
    NSString * xibPath = [[NSBundle mainBundle] pathForResource:NSStringFromClass([self class]) ofType:@"nib"];
    if (xibPath) {
        return [[self alloc] initWithNibName:NSStringFromClass([self class]) bundle:nil];
    }else{
        return [[self alloc] init];
    }
}

- (BOOL)isViewShow
{
    LogInfo(@"This function need be overwrite by [%@]", NSStringFromClass([self class]));
    return NO;
}

- (void)setIsViewShow:(BOOL)isViewShow
{
    LogInfo(@"This function need be overwrite by [%@]", NSStringFromClass([self class]));
}

- (BOOL)isViewHadShow
{
    LogInfo(@"This function need be overwrite by [%@]", NSStringFromClass([self class]));
    if ([self isKindOfClass:[BaseViewController class]]) {
        return NO;
    } else {
        return YES;
    }
}

- (void)setIsViewHadShow:(BOOL)isViewHadShow
{
    LogInfo(@"This function need be overwrite by [%@]", NSStringFromClass([self class]));
}

- (void)configWithData:(id)data
{
    // need be overwrite
    LogInfo(@"This function need be overwrite by [%@]", NSStringFromClass([self class]));
}
- (void)configWithPushData:(id)data
{
    // need be overwrite
    LogInfo(@"This function need be overwrite by [%@]", NSStringFromClass([self class]));
}
- (void)configWithData:(id)data andAttach:(id)attachData
{
    // need be overwrite
    LogInfo(@"This function need be overwrite by [%@]", NSStringFromClass([self class]));
}


- (void)refreshWithData:(id)data
{
    // need be overwrite
    LogInfo(@"This function need be overwrite by [%@]", NSStringFromClass([self class]));
}

@end
