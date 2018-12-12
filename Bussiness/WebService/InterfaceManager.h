//
//  InterfaceManager.h
//  KKMYForM
//
//  Created by Xia Zhiyong on 13-11-8.
//  Copyright (c) 2013年 Xia Zhiyong. All rights reserved.
//  接口管理类

#import "WebService.h"
#import "ResultModel.h"

#define SetObjForDic(dic,obj,key)    [dic setValue:obj forKey:key];

typedef void (^InterfaceManagerBlock)(BOOL isSucceed, NSString *message, id result);
typedef void (^InterfaceManagerBlockWithTask)(NSURLSessionTask *task,BOOL isSucceed, NSString *message, id data);

@interface InterfaceManager : NSObject

/** 取消对应请求，取消之后回调不会调用 */
+ (void)cancelRequestWith:(NSString *)requestId;

/** 取消所有请求，谨慎使用 */
+ (void)cancelAllRequest;
/**
 *	@brief	统一接口请求
 *
 *	@param 	action          接口名称
 *	@param 	describe        接口描述
 *	@param 	body            请求body
 *	@param 	returnClass 	接收的model
 *	@param 	completion      请求完成回调
 *

 */
+ (NSURLSessionDataTask *)startRequest:(NSString *)action
            describe:(NSString *)describe
                body:(NSDictionary *)body
         returnClass:(Class)returnClass
          completion:(InterfaceManagerBlock)completion;


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
                 callback:(InterfaceManagerBlock)completion;

@end

