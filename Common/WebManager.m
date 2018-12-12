//
//  WebManager.m
//  ChineseClassTeacher
//
//  Created by yangjuanping on 2018/8/27.
//  Copyright © 2018年 qiaoqiaochinese. All rights reserved.
//

#import "WebManager.h"
@implementation Route

@end
@implementation WebManager
- (void)routeManager:(Route*) route{
    if (route.pgcode.intValue == 100) {//资料提交审核web

    }else if(route.pgcode.intValue == 101){//教师提交评价
        if (route.result.intValue==1) {
            [self backWithNav:_webController.navController callback:^{

            }];
        }
    }
}
- (void)backWithNav:(UINavigationController *)nav callback:(void(^)())block{
    [nav popViewControllerAnimated:YES];
    if (block) {
        block();
    }
}
@end
