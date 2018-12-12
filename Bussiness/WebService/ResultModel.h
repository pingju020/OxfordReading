//
//  ResultModel.h
//  KKMYForU
//
//  Created by yangjuanping on 13-11-5.
//  Copyright (c) 2013年 Rogrand. All rights reserved.
//  网络请求返回数据的body部分

#import <Foundation/Foundation.h>
#import "JSONModel.h"
@class PageInfo;
@interface ResultModel : JSONModel

@property (nonatomic, assign) int resultCode;/**< 返回结果状态:0成功,1失败 缺省值为0*/
@property (nonatomic, strong) NSString *resultMsg;/**< 返回提示信息*/
@property (nonatomic, strong) PageInfo<Optional> *pageInfo;/**< 数据分页信息*/
@property (nonatomic, strong) id<Optional,NSObject> data;/**< 单条数据信息 */
@property (nonatomic, strong) NSArray<Optional,NSObject> *dataList;/**< 多条数据信息 */
@property (nonatomic, strong) id<Optional> dataMap;/**< 其他需要返回的数据 */
@property (nonatomic, strong) NSString<Optional> *syncDate;/**< 同步时间 */
@property (nonatomic, copy)   NSString<Optional> *token;
@end

@protocol PageInfo <NSObject>
@end

@interface PageInfo : JSONModel
@property (nonatomic, assign) int pageIndex;
@property (nonatomic, assign) int pageSize;
@property (nonatomic, assign) int totalNum;
@property (nonatomic, assign) int totalPages;

@end
