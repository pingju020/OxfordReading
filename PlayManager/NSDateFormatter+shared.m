//
//  NSDateFormatter+shared.m
//  CYMusic
//
//  Created by yangjuanping on 2018/8/13.
//  Copyright © 2018年 yangjuanping. All rights reserved.
//

#import "NSDateFormatter+shared.h"

@implementation NSDateFormatter (shared)

+ (instancetype)sharedDateFormatter {
    static NSDateFormatter * instancetype;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instancetype = [[NSDateFormatter alloc] init];
    });
    return instancetype;
}

@end
