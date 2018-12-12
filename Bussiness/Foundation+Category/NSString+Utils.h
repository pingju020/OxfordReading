//
//  NSString+Utils.h
//  KKMYForU
//
//  Created by yangjuanping on 13-10-31.
//  Copyright (c) 2013年 Rogrand. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


// 本地临时文件缓存路径
#define		TEMP_FOLDER_NAME		@"tmp"
// 本地图片缓存路径
#define		IMAGE_FOLDER_NAME		@"images"
// 本地头像缓存路径
#define		kAvatarDir			@"avatars"
// 本地音频文件缓存路径
#define		kAudioDir				@"audio"

@interface NSString (Utils)

// 本地字符串替换
+ (NSString *)localizedString:(NSString *)format, ... NS_REQUIRES_NIL_TERMINATION ;
// NS_REQUIRES_NIL_TERMINATION;

// 获取域名
+ (NSString *)getBaseHost;

// 获取文本高度
- (CGSize)textSizeWithFont:(UIFont *)font;
// 多行文本获取高度
- (CGSize)multilineTextSizeWithFont:(UIFont *)font andMaxSize:(CGSize)maxSize;

// 检查电话号
- (BOOL)checkPhoneNum;
// 检查手机号
- (BOOL)checkMobileNum;
/** 检查输入字符串, 已不再使用, 请使用 isContainsSpecialString: */
- (BOOL)checkText;
+ (NSString *)disableEmoji:(NSString *)text;
- (BOOL) containEmoji;
// 是否包含表情
+ (BOOL)isContainsEmoji:(NSString *)string;
// 是否包含特殊字符
- (BOOL)isContainsSpecialString;
//判断字符串是否只有数字
- (BOOL)isOnlyNum;
// 尾部不包含特殊字符的字符串
- (NSString *)lastUsableString;
// 转换成带星星的电话号
- (NSString *)convertToCoverTel;
// 计算以小时为单位的时间
+ (NSString *)getHourWithMinute:(float)minute;
// 计算字符串高度
- (float)heightWithFont:(UIFont *)font andWidth:(float)width;
//- (float)calculateHeightWithFont:(UIFont *)font andWidth:(float)width;  // 已无地方调用
// 版本号检查
- (BOOL)isNewThanVersion:(NSString *)oldVersion;
// 时间戳转换
- (NSString *)convertToTimeString;
//昨天以前的显示完整日期，以后的显示小时分钟
- (NSString *)convertToTimeString1;
- (NSString *)convertTimeString;
- (NSString *)compareWihtTime:(NSString *)curTime;

+ (NSString *)generateUniqueId;
+ (NSString *)getDocumentLocation;
+ (NSString *)getTempLocation;
+ (NSString *)getImageLocation;
+ (NSString *)getAvatarLocation;
+ (NSString *)getAudioLocation;
+ (NSString *)timestampConvertString:(long long)time;

+ (NSString *)halfHourAfterCurrentTime;
+ (NSString *)oneDayAfterCurrentTime;
+ (NSString *)oneDayBeforeCurrentTime;
// 格式：yyyy-MM-dd 下午 HH:mm
+ (NSString *)dateFormatter:(NSTimeInterval)seconds;
+ (NSString *)timestampConvertString:(long long)time dataFormat:(NSString *)dataFormat;
+ (NSString*)getLaunchImage;

+ (NSString*)URLencode:(NSString *)originalString
        stringEncoding:(NSStringEncoding)stringEncoding;
//去除首尾空格
-(NSString *)trim;

//判断在srcStr中是否存在destStr，如果存在返回YES
+ (BOOL)isExistString:(NSString *)srcStr fingStr:(NSString *)destStr;


/**
 *	@brief	将字符串作md5值加密，如果传入的原文为空字符串“”或者nil则返回的密文为空字符串“”
 *
 *	@return	密文
 */
- (NSString *)md5;
-(NSString *)hmac:(NSString *)plaintext withKey:(NSString *)key;
- (NSString *) sha1_base64;
- (NSString *) md5_base64;
//获得设备型号
+ (NSString *)getCurrentDeviceModel;
+ (NSString *)httpHeaderAgent;
/** 安全取出非nilString, 避免显示(null) */
+ (NSString *)safeString:(id)obj;

/** 移除字符串中的所有空白 */
- (NSString *)removeBlank;

+ (NSString *)fileSizeToString:(unsigned long long)fileSize; /**< 文件的大小 */
+ (NSString *)getNetWorkStates;/**< 网络状态 */
+ (NSString *)adapterHtml:(NSString *)str;/**<适配html中的<,>,<=,>=*/
@end
