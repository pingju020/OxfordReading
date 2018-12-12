//
//  WebService.m
//  KKMYForU
//
//  Created by Zhiyong on 13-11-4.
//  Copyright (c) 2013年 ags. All rights reserved.
//

#import "WebService.h"
//#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "NSString+Utils.h"
#import "UserManager.h"

#define REQUEST_TIMEOUT 15
#define UPLOAD_TIMEOUT 60
#define DOWNLOAD_TIMEOUT 60

#pragma mark - Network Data


@interface WebService ()

+ (ResultModel *)getResultWithString:(NSString *)aString
                         returnClass:(Class)returnClass
                            andError:(NSError**)err;


@end


@implementation WebService

#pragma 发起Get请求
+ (NSURLSessionDataTask *)startGetRequest:(NSString *)action
                                  body:(NSDictionary *)body
                           returnClass:(Class)returnClass
                               success:(RequestSuccessBlock)sblock
                               failure:(RequestFailureBlock)fblock
{
    LogInfo(@"...>>>requestUrl:%@ /n ...requestData:%@\n",action, body);
    NSString *url = [WebService pathUrl:action];
    AFHTTPSessionManager* manager = [WebService sessoionConfigration:[url hasPrefix:@"https://"]];
    return [manager POST:url
              parameters:body
                progress:^(NSProgress *uploadProgress){}
                 success:^(NSURLSessionTask *task, id responseObject) {
                     
                     NSString *responseStr = [WebService jsonStrFromTask:task
                                                                response:responseObject
                                                      responseSerializer:manager.responseSerializer];
                     [WebService callbackWithResponse:responseStr
                                          returnClass:returnClass
                                                 task:task
                                              success:sblock
                                              failure:fblock];
                     
                 } failure:^(NSURLSessionTask *task, NSError *error) {
                     // 请求失败
                     if (fblock) {
                         fblock(task, error);
                     }
                 }];
    
}

#pragma 发起POST请求
+ (NSURLSessionDataTask *)startRequest:(NSString *)action
                body:(NSDictionary *)body
         returnClass:(Class)returnClass
             success:(RequestSuccessBlock)sblock
             failure:(RequestFailureBlock)fblock
{
    LogInfo(@"...>>>requestUrl:%@ /n ...requestData:%@\n",action, body);
    NSString *url = [WebService pathUrl:action];
    AFHTTPSessionManager* manager = [WebService sessoionConfigration:[url hasPrefix:@"https://"]];
	return [manager POST:url
              parameters:body
                progress:^(NSProgress *uploadProgress){}
                 success:^(NSURLSessionTask *task, id responseObject) {
                     
        NSString *responseStr = [WebService jsonStrFromTask:task
                                                   response:responseObject
                                         responseSerializer:manager.responseSerializer];
        [WebService callbackWithResponse:responseStr
                             returnClass:returnClass
                                    task:task
                                 success:sblock
                                 failure:fblock];
        
    } failure:^(NSURLSessionTask *task, NSError *error) {
        // 请求失败
        if (fblock) {
            fblock(task, error);
        }
    }];
    
}

+ (void)startRequestForUpload:(NSString *)action
                         body:(NSDictionary *)body
                     filePath:(NSString *)path
                      fileKey:(NSString *)filekey
                  returnClass:(Class)returnClass
                      success:(RequestSuccessBlock)sblock
                      failure:(RequestFailureBlock)fblock
{	
    // 拼接发送数据
    LogInfo(@"...>>>...requestData:%@\n", body);
    
    NSString *url = [WebService pathUrl:action];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    AFHTTPSessionManager* manager = [WebService sessoionConfigration:[url hasPrefix:@"https://"]];
    [manager.requestSerializer setTimeoutInterval:UPLOAD_TIMEOUT];
    [manager POST:url parameters:body constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        NSData *audioData = [NSData dataWithContentsOfFile:path];
        NSString *mineType = @"audio/speex";
        if ([path hasSuffix:@"png"] || [path hasSuffix:@"jpg"]) {
            mineType = @"image/png";
        }
        if (audioData) {
            [formData appendPartWithFileData:audioData name:filekey fileName:[path lastPathComponent] mimeType:mineType];
        }
    }progress:^(NSProgress *uploadProgress){}
    success:^(NSURLSessionTask *task, id responseObject) {
        NSString *responseStr = [WebService jsonStrFromTask:task
                                                   response:responseObject
                                         responseSerializer:manager.responseSerializer];
        [WebService callbackWithResponse:responseStr
                             returnClass:returnClass
                                    task:task
                                 success:sblock
                                 failure:fblock];
    } failure:^(NSURLSessionTask *task, NSError *error) {
        // 请求失败
        LogError(@"...>>>...Network error: %@\n", [task error]);
        if (fblock)
        {
            fblock(task, error);
        }

    }];

//    //接收类型不一致请替换一致text/html或别的
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
//                                                         @"text/html",
//                                                         @"image/jpeg",
//                                                         @"image/png",
//                                                         @"application/octet-stream",
//                                                         @"text/json",
//                                                         nil];
//    
//    NSURLSessionDataTask *task = [manager POST:url parameters:body constructingBodyWithBlock:^(id<AFMultipartFormData> _Nonnull formData) {
//        
//        NSData *audioData = [NSData dataWithContentsOfFile:path];
//        NSString *mineType = @"audio/speex";
//        if ([path hasSuffix:@"png"] || [path hasSuffix:@"jpg"]) {
//            mineType = @"image/png";
//        }
//        if (audioData) {
//            [formData appendPartWithFileData:audioData name:filekey fileName:[path lastPathComponent] mimeType:mineType];
//        }
//        
//    } progress:^(NSProgress *_Nonnull uploadProgress) {
//        //打印下上传进度
//    } success:^(NSURLSessionDataTask *_Nonnull task,id _Nullable responseObject) {
//        //上传成功
//    } failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
//        //上传失败
//    }];
}

/** 单个文件下载 */
+ (void)startDownload:(NSString *)remotePath
         withSavePath:(NSString *)localPath
           completion:(void (^)(BOOL isSucceed, NSString *message))completion
        progressBlock:(void (^)(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead))progressBlock
{
    if (completion == nil) {
        completion = ^(BOOL isSucceed, NSString *message) {};
    }
        
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:remotePath]];
	
	//添加 User-Agent 后面追加 版本号
	NSString* userAgent = [NSString httpHeaderAgent];
	if (userAgent) {
		[request  setValue:userAgent forHTTPHeaderField:@"User-Agent"];
	}
    AFHTTPSessionManager* manager = [WebService sessoionConfigration:[remotePath hasPrefix:@"https://"]];
    [manager.requestSerializer setTimeoutInterval:DOWNLOAD_TIMEOUT];
	NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
		return [NSURL fileURLWithPath:localPath];;
	} completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
		if (error.code==200 || !error) {
			LogInfo(@"...>>>...Successfully downloaded file to %@\n", filePath);
			completion(YES, @"下载成功");
		}else{
			completion(NO,@"下载失败");
		}
	}];
	[downloadTask resume];
}

/** 下载分享图片 */
+ (void)downloadShareImg:(NSString *)imgUrl
{
    NSString *localUrl = [[NSString getTempLocation] stringByAppendingPathComponent:imgUrl.md5];
    if (![[NSFileManager defaultManager] fileExistsAtPath:localUrl]) {
        [WebService startDownload:imgUrl
                     withSavePath:localUrl
                       completion:^(BOOL isSucceed, NSString *message) {
                           if (isSucceed) {
                               LogInfo(@"download sharePic succeed");
                           } else {
                               LogError(@"%@", message);
                           }
                       }
                    progressBlock:nil];
    }
}

/**
 对传入的请求action请求组合

 @param action 请求动作
 @return 完整的请求地址
 */
+ (NSString *)pathUrl:(NSString *)action{
    NSString *pathUrl = nil;
    // 拼接请求url
    pathUrl = [action hasPrefix:@"http"] ? action :[NSString stringWithFormat:@"%@%@", kBaseUrl, action];

    LogTrace(@"...>>>...requestUrl:%@\n", pathUrl);
    return pathUrl;
}

/**
 对网络请求的配置

 @param isHttps 是否是https请求，如果是，则进行证书配置
 @return 返回AFHTTPSessionManager
 */
+ (AFHTTPSessionManager *)sessoionConfigration:(BOOL)isHttps{
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    if (isHttps) {
        NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"cert" ofType:@"cer"];
        NSData * certData =[NSData dataWithContentsOfFile:cerPath];
        NSSet * certSet = [[NSSet alloc] initWithObjects:certData, nil];
        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
            // 是否允许,NO-- 允许无效的证书
        [securityPolicy setAllowInvalidCertificates:YES];
        [securityPolicy setValidatesDomainName:NO];

            // 设置证书
        [securityPolicy setPinnedCertificates:certSet];
        manager.securityPolicy = securityPolicy;
    }
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setTimeoutInterval:REQUEST_TIMEOUT];
        //添加 User-Agent 后面追加版本号
    NSString* userAgent = [NSString httpHeaderAgent];
    if (userAgent) {
        [manager.requestSerializer  setValue:userAgent forHTTPHeaderField:@"User-Agent"];
    }
    [manager.requestSerializer setValue:[UserManager shareInstance].token forHTTPHeaderField:@"token"];
    return manager;
}

/**
 对请求回来的NSData数据进行json处理

 @param task NSURLSessionTask
 @param responseObject 返回的NSData
 @param responseSerializer 网络响应序列化
 @return json string
 */
+ (NSString *)jsonStrFromTask:(NSURLSessionTask *)task
                     response:(id) responseObject
           responseSerializer:(AFHTTPResponseSerializer *) responseSerializer{
        // 请求成功
    NSString *responseStr= nil;
    NSError *decodeError = nil;
    id response = [responseSerializer responseObjectForResponse:task.response
                                                           data:responseObject
                                                          error:&decodeError];
    /*判断是否有错，以及数据是否为NSData类型，如果不是，那么直接使用initWithData会crash*/
    if (!decodeError && [response isKindOfClass:[NSData class]]) {
        responseStr = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
    }
    LogInfo(@">>>requestUrl->%@...>>>...receiveData = %@",task.currentRequest.URL, responseStr);
    return responseStr;
}

/**
 对请求回来的jsonstr进行JSONModel转化然后block传回

 @param responseStr 请求结果 json string
 @param returnClass 要转化成的jsonmodel类
 @param task 网络请求NSURLSessionTask
 @param sblock 成功返回
 @param fblock 失败返回
 */
+ (void)callbackWithResponse:(NSString *)responseStr
                 returnClass:(Class)returnClass
                        task:(NSURLSessionTask *)task
                     success:(RequestSuccessBlock)sblock
                     failure:(RequestFailureBlock)fblock{
    NSError *err = nil;
        // 解析json
    ResultModel *result = [WebService getResultWithString:responseStr
                                              returnClass:returnClass
                                                 andError:&err];
    if (err) {
            // 数据解析错误，出现该错误说明与服务器接口对应出了问题
        LogDebug(@"...>>>...JSON Parse Error: %@\n", err);
        if (fblock) {
            fblock(nil, err);
        }
    } else {
        if (sblock) {
            sblock(task, result);
        }
    }
    
}

// 从字符串转换成ResultModel
+ (ResultModel *)getResultWithString:(NSString *)aString
						 returnClass:(Class)returnClass
							andError:(NSError**)err
{
	
	@try {
		ResultModel *aRespond = [[ResultModel alloc] initWithString:aString error:nil];
        if (returnClass) {
            if([aRespond.data isKindOfClass:[NSDictionary class]]){
                NSError *error = nil;
                aRespond.data = [[returnClass alloc] initWithDictionary:(NSDictionary *)aRespond.data error:&error];
                if (error) {
                    aRespond.resultMsg = @"Parse the JSON data failed";
                }else{
                    return aRespond;
                }
            }else if(aRespond.dataList.count >0){
                NSMutableArray *classArray = [NSMutableArray arrayWithCapacity:aRespond.dataList.count];
                for (NSDictionary *dic in aRespond.dataList) {
                    NSObject *object = [[returnClass alloc] initWithDictionary:dic error:nil];
                    if (object) {
                        [classArray addObject:object];
                    }
                }
                aRespond.dataList = classArray;
                return aRespond;
            }else{
                return aRespond;
            }
        }

		return aRespond;
	}
	@catch (NSException *exception)
	{
		LogDebug(@"%@", exception);
		*err = [[NSError alloc] initWithDomain:exception.reason code:-500 userInfo:exception.userInfo];
		return nil;
	}
	@finally {
		//
	}
	
}
@end
