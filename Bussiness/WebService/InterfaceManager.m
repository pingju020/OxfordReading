//
//  InterfaceManager.m
//  KKMYForM
//
//  Created by Xia Zhiyong on 13-11-8.
//  Copyright (c) 2013年 Xia Zhiyong. All rights reserved.
//

#import "InterfaceManager.h"
//#import "NSDictionary+Utils.h"
//#import "StudentModel.h"
//#import "TeacherModel.h"

#define DEFAULT_PAGE_COUNT 20

static NSMutableDictionary *s_dicRequests = nil;

@implementation InterfaceManager

+ (void)cancelRequestWith:(NSString *)requestId
{
    if (s_dicRequests) {
        InterfaceManagerBlock callback = [s_dicRequests objectForKey:requestId];
        if (callback) {
            [s_dicRequests removeObjectForKey:requestId];
            callback(NO, @"", nil);
        }
    }
}

+ (void)cancelAllRequest
{
    if (s_dicRequests) {
        NSArray *arrValues = [s_dicRequests allValues];
        [s_dicRequests removeAllObjects];
        for (InterfaceManagerBlock callback in arrValues) {
            callback(NO, @"", nil);
        }
    }
}

#pragma mark - Class Function

/** 统一接口请求 */
+ (NSURLSessionDataTask *)startRequest:(NSString *)action
            describe:(NSString *)describe
                body:(NSDictionary *)body
         returnClass:(Class)returnClass
          completion:(InterfaceManagerBlock)completion
{
   return [WebService startRequest:action
                        body:body
                 returnClass:returnClass
                     success:^(NSURLSessionTask *task, ResultModel *result)
     {
         [self succeedWithResult:result describe:describe callback:^(BOOL isSucceed, NSString *message, id data) {
             completion(isSucceed,message,data);
         }];
     } failure:^(NSURLSessionTask *task, NSError *error)
     {
         LogError(@"%@", error);
          completion(NO, @"request failed", nil);
     }];
}


/**
 *	@brief	请求成功数据处理
 *
 *	@param 	result      请求成功后返回的结构
 *	@param 	describe 	请求描述
 *	@param 	completion 	请求完成回调
 *

 */
+ (void)succeedWithResult:(ResultModel *)result
                 describe:(NSString *)describe
                 callback:(InterfaceManagerBlock)completion

{
    if (completion == nil) {
        completion = ^(BOOL isSucceed, NSString *message, id data) {};
    }
    if (result.resultCode > 0) {
        if (result.resultCode == 211) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kStrNotificationReLogin object:nil];
        }
        completion(NO, result.resultMsg,result);
    } else {
        completion(YES, result.resultMsg,result);
    }
}


#pragma mark -




@end
