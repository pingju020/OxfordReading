//
//  WebManager.h
//  ChineseClassTeacher
//
//  Created by yangjuanping on 2018/8/27.
//  Copyright © 2018年 qiaoqiaochinese. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"
#import "WebViewController.h"
@interface Route : JSONModel
@property (strong, nonatomic) NSNumber<Optional>* pgcode;
@property (strong, nonatomic) NSNumber<Optional>* result;
@end


@interface WebManager : NSObject
@property (strong, nonatomic) WebViewController *webController;


- (void)backWithNav:(UINavigationController *)nav callback:(void(^)())block;
- (void)routeManager:(Route*) route;
@end
