//
//  NSString+Utils.m
//  KKMYForU
//
//  Created by yangjuanping on 13-10-31.
//  Copyright (c) 2013年 Rogrand. All rights reserved.
//

#import "NSString+Utils.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>
#include <sys/types.h>
#include <sys/sysctl.h>
#import "AppDelegate.h"
#import "GTMBase64.h"

#define ONE_DATE_TIME (24 * 60 * 60)

#define TWO_DATE_TIME (2 * ONE_DATE_TIME)

#define THREE_DATE_TIME (3 * ONE_DATE_TIME)

#define CUR_TIMEZONE (8 * 60 * 60)

// 基域名
static NSString *s_baseHost = nil;
// 图片服务器
static NSString *s_sourceUrl = nil;

// 本地音频存储路径
static NSString *locDocumentPath = nil;
// 本地音频存储路径
static NSString *locAudioPath = nil;
// 本地图片存储路径
static NSString *locImagePath = nil;
// 本地头像存储路径
static NSString *locAvatarPath = nil;
// 本地临时文件存储路径
static NSString *locTempPath = nil;
//  本地启动页图片
static NSString *launchImagePath = nil;

@implementation NSString (Utils)

+ (NSString *)localizedString:(NSString *)format, ...
{
    NSString *returnStr = NSLocalizedString(format, nil);
    if (returnStr) {
        va_list arguments;
        NSString *eachReplaceStr;
        int index = 0;
        
        va_start(arguments, format);
        while ((eachReplaceStr = va_arg(arguments, id))) {
            NSString *str = [NSString stringWithFormat:@"{%d}", index];
            returnStr = [returnStr stringByReplacingOccurrencesOfString:str withString:eachReplaceStr];
            index++;
        }
        va_end(arguments);
    }
    return returnStr;
}

+ (NSString *)getBaseHost
{
    if (s_baseHost == nil) {
            s_baseHost = kBaseHost;
    }
    return s_baseHost;
}

- (CGSize)textSizeWithFont:(UIFont *)font
{
    return [self sizeWithAttributes:@{NSFontAttributeName:font}];
}

- (CGSize)multilineTextSizeWithFont:(UIFont *)font andMaxSize:(CGSize)maxSize
{
    return [self boundingRectWithSize:maxSize
                              options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                           attributes:@{NSFontAttributeName:font}
                              context:nil].size;
}

- (BOOL)checkPhoneNum
{
    //    if (self.length > 6) {
    //        return YES;
    //    }
    //    return NO;
    //检查所有手机与座机
    NSString *mobile =  @"((\\d{11})|^((\\d{7,8})|(\\d{4}|\\d{3})-(\\d{7,8})|(\\d{4}|\\d{3})-(\\d{7,8})-(\\d{4}|\\d{3}|\\d{2}|\\d{1})|(\\d{7,8})-(\\d{4}|\\d{3}|\\d{2}|\\d{1}))$)";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", mobile];
    if ([regextestmobile evaluateWithObject:self]) {
        return YES;
    }else{
        return NO;
    }
}

- (BOOL)checkMobileNum
{
    if ([self length] <= 0) {
        return NO;
    }
    if ([self length] != 11) {
        return NO;
    }
    NSString *mobileCheck = @"^((13[0-9])|(14[0-9])|(15[0-9])|(18[0-9])|(17[0-9]))\\d{8}$";
    NSPredicate *regextestmobile1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", mobileCheck];
    if ([regextestmobile1 evaluateWithObject:self] == YES) {
        return YES;
    } else {
        return NO;
    }
    //    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9]|70)\\d{8}$";
    //    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    //    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    //    NSString * CT = @"^1((33|53|8[019])[0-9]|349)\\d{7}$";
    //    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    //    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    //    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    //    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    //    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    //    if (([regextestmobile evaluateWithObject:self] == YES)
    //        || ([regextestcm evaluateWithObject:self] == YES)
    //        || ([regextestct evaluateWithObject:self] == YES)
    //        || ([regextestcu evaluateWithObject:self] == YES))
    //    {
    //        return YES;
    //    }
    //    else
    //    {
    //        return NO;
    //    }
}

/** 已不再使用 */
- (BOOL)checkText
{
    return YES;
    //    NSString *matchStr = @"^[A-Za-z0-9\u4E00-\u9FA5_-]+$";
    //    NSPredicate *regextest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", matchStr];
    //    if ([regextest evaluateWithObject:self] == YES) {
    //        return YES;
    //    } else {
    //        return NO;
    //    }
}
+ (NSString *)disableEmoji:(NSString *)text
{
	NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]" options:NSRegularExpressionCaseInsensitive error:nil];
	NSString *modifiedString = [regex stringByReplacingMatchesInString:text
															   options:0
																 range:NSMakeRange(0, [text length])
														  withTemplate:@""];
	return modifiedString;
}
+ (BOOL)isContainsEmoji:(NSString *)string
{

    __block BOOL isEomji = NO;

    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
                               options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock: ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop)
     {
         const unichar hs = [substring characterAtIndex:0];
         
         // surrogate pair
         if (0xd800 <= hs && hs <= 0xdbff) {
             if (substring.length > 1) {
                 const unichar ls = [substring characterAtIndex:1];
                 const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                 if (0x1d000 <= uc && uc <= 0x1f77f) {
                     isEomji = YES;
                 }
             }
         } else if (substring.length > 1) {
             const unichar ls = [substring characterAtIndex:1];
             if (ls == 0x20e3) {
                 isEomji = YES;
             }
         } else {
             // non surrogate
             if (0x2100 <= hs && hs <= 0x27ff && hs != 0x263b) {
                 isEomji = YES;
             } else if (0x2B05 <= hs && hs <= 0x2b07) {
                 isEomji = YES;
             } else if (0x2934 <= hs && hs <= 0x2935) {
                 isEomji = YES;
             } else if (0x3297 <= hs && hs <= 0x3299) {
                 isEomji = YES;
                 
             } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50|| hs == 0x231a ) {
                 isEomji = YES;
             }
         }
     }];
    
    return isEomji;
}
- (BOOL)isContainsSpecialString
{
    __block BOOL isEomji = NO;
    [self enumerateSubstringsInRange:NSMakeRange(0, [self length])
                             options:NSStringEnumerationByComposedCharacterSequences
                          usingBlock: ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop)
     {
         const unichar hs = [substring characterAtIndex:0];
         
         // surrogate pair
         if (substring.length > 1) {
             isEomji = YES;
         } else {
             // non surrogate
             if (0x2100 <= hs && hs <= 0x27ff && hs != 0x263b) {
                 isEomji = YES;
             } else if (0x2B05 <= hs && hs <= 0x2b07) {
                 isEomji = YES;
             } else if (0x2934 <= hs && hs <= 0x2935) {
                 isEomji = YES;
             } else if (0x3297 <= hs && hs <= 0x3299) {
                 isEomji = YES;
                 
             } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50|| hs == 0x231a ) {
                 isEomji = YES;
             }
         }
     }];
    return isEomji;
}

- (BOOL)isOnlyNum
{
    NSCharacterSet*cs;
    cs = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
    NSString*filtered = [[self componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    return  [self isEqualToString:filtered];
}

- (NSString *)lastUsableString
{
    __block int startIndex = 0;
    [self enumerateSubstringsInRange:NSMakeRange(0, [self length])
                             options:NSStringEnumerationByComposedCharacterSequences
                          usingBlock: ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop)
     {
         // surrogate pair
         if (substring.length > 1) {
             startIndex = (int)(substringRange.location + substringRange.length);
         }
     }];
    return [self substringFromIndex:startIndex];
}

// 转换成带星星的电话号
- (NSString *)convertToCoverTel
{
    NSString *telCover = nil;
    if(self.length >= 4)
    {
        NSMutableString *starString = [NSMutableString string];
        for (int i=2; i < self.length-4; i++) {
            [starString appendString:@"*"];
        }
        telCover = [self stringByReplacingCharactersInRange:NSMakeRange(2, self.length-4) withString:starString];
    }
    return telCover;
}

+ (NSString *)getHourWithMinute:(float)minute
{
    if (minute < 60) {
        return @"<1";
    }
    int hour = minute / 60;
    return [NSString stringWithFormat:@"%d", hour];
}

- (float)heightWithFont:(UIFont *)font andWidth:(float)width
{
    float height = 0;
//    float theHeight = 0;
//    NSArray *array = [self componentsSeparatedByString:@"\n"];
//    for (NSString *str in array) {
//        if (str == nil || [str isEqualToString:@""] == YES) {
//            CGSize size = textSizeWithFont(@"test", font);
//            theHeight = size.height;
//            height += theHeight;
//            continue;
//        }
//        CGSize size = textSizeWithFont(str, font);
//        theHeight = size.height;
//        int count = size.width / width;
//        height += theHeight * (count + 1);
//    }
//    height = height - theHeight;
    return height;
}

/*
 - (float)calculateHeightWithFont:(UIFont *)font andWidth:(float)width
 {
 // 判断是否存在换行符
 NSRange range = [self rangeOfString:@"\n"];
 if (range.location == NSNotFound) { // 不存在
 
 CGSize size = textSizeWithFont(self, font);
 int rowNum = size.width / width;
 return (rowNum+1) * size.height;
 
 }else {                             // 存在
 
 float height = 0;
 float theHeight = 0;
 NSArray *array = [self componentsSeparatedByString:@"\n"];
 for (NSString *str in array) {
 if (str == nil || [str isEqualToString:@""] == YES) {
 CGSize size = textSizeWithFont(@"test", font);
 theHeight = size.height;
 height += theHeight;
 continue;
 }
 CGSize size = textSizeWithFont(str, font);
 theHeight = size.height;
 int count = size.width / width;
 height += theHeight * (count + 1);
 }
 return height;
 
 }
 }
 */

- (BOOL)isNewThanVersion:(NSString *)oldVersion
{
    NSArray *arrayNew = [self componentsSeparatedByString:@"."];
    NSArray *arrayOld = [oldVersion componentsSeparatedByString:@"."];
    int len = MIN((int)arrayNew.count, (int)arrayOld.count);
    for (int i = 0; i < len; i++) {
        if ([[arrayNew objectAtIndex:i] intValue] > [[arrayOld objectAtIndex:i] intValue]) {
            return YES;
        } else if ([[arrayNew objectAtIndex:i] intValue] < [[arrayOld objectAtIndex:i] intValue]) {
            return NO;
        }
    }
    return NO;
}
- (NSString *)convertToTimeString1
{
    if (self.length <10){
        return nil;
    }
    long long thisTimestamp = [[self substringToIndex:10] longLongValue];
    
    long long curTimestamp = [[NSDate date] timeIntervalSince1970];
    NSUInteger seconds= [[NSTimeZone systemTimeZone] secondsFromGMTForDate:[NSDate date]];
    long long todayTimestamp = curTimestamp - (curTimestamp % ONE_DATE_TIME) - seconds;
    long long dTimestamp = todayTimestamp - thisTimestamp;
    if (dTimestamp > 0) {
        // 一天前, 使用: 昨天 HH:mm
        if (dTimestamp > ONE_DATE_TIME) {
            NSString *timeStr = [NSString timestampConvertString:thisTimestamp dataFormat:@"yyyy.MM.dd"];
            return timeStr;
        }else{
            return @"昨天";
        }
    } else{
        NSString *timeStr = [NSString timestampConvertString:thisTimestamp dataFormat:@"HH:mm"];
        return [NSString stringWithFormat:@"%@", timeStr];
    }
}
- (NSString *)convertToTimeString
{
    if (self.length <10)
    {
        return nil;
    }
    long long thisTimestamp = [[self substringToIndex:10] longLongValue];
    
    long long curTimestamp = [[NSDate date] timeIntervalSince1970];
    NSUInteger seconds= [[NSTimeZone systemTimeZone] secondsFromGMTForDate:[NSDate date]];
    long long todayTimestamp = curTimestamp - (curTimestamp % ONE_DATE_TIME) - seconds;
    long long dTimestamp = todayTimestamp - thisTimestamp;
    if (dTimestamp > TWO_DATE_TIME) {
        // 三天前, 使用: yyyy-MM-dd HH:mm
        return [NSString timestampConvertString:thisTimestamp dataFormat:@"yyyy-MM-dd HH:mm"];
    } else if (dTimestamp > ONE_DATE_TIME) {
        // 两天前, 使用: 前天 HH:mm
        NSString *timeStr = [NSString timestampConvertString:thisTimestamp dataFormat:@"HH:mm"];
        return [NSString stringWithFormat:@"前天 %@", timeStr];
    } else if (dTimestamp > 0) {
        // 一天前, 使用: 昨天 HH:mm
        NSString *timeStr = [NSString timestampConvertString:thisTimestamp dataFormat:@"HH:mm"];
        return [NSString stringWithFormat:@"昨天 %@", timeStr];
    } else if (thisTimestamp < todayTimestamp + ONE_DATE_TIME) {
        NSString *timeStr = [NSString timestampConvertString:thisTimestamp dataFormat:@"HH:mm"];
        return [NSString stringWithFormat:@"今天 %@", timeStr];
    } else {
        // 今天以后, 使用: yyyy-MM-dd HH:mm
        return [NSString timestampConvertString:thisTimestamp dataFormat:@"yyyy-MM-dd HH:mm"];
    }
    return nil;
}

// 转为 发布 4-14 12:00
- (NSString *)convertTimeString
{
    if (self.length <10)
    {
        return nil;
    }
    long long thisTimestamp = [[self substringToIndex:10] longLongValue];
    return [NSString timestampConvertString:thisTimestamp dataFormat:@"MM/dd HH:mm"];
    
}

- (NSString *)compareWihtTime:(NSString *)curTime
{
    if (self.length <10)
    {
        return nil;
    }
    long long thisTimestamp = [[self substringToIndex:10] longLongValue];
    long long curTimestamp = [[curTime substringToIndex:10] longLongValue];
    
    long long dTime = curTimestamp - thisTimestamp;
    
    if (dTime < 60) {
        return @"刚刚";
    }
    
    if (dTime < 60 * 60) {
        return [NSString stringWithFormat:@"%lld分钟前", dTime / 60];
    }
    
    if (dTime < 60 * 60 * 24) {
        return [NSString stringWithFormat:@"%lld小时前", dTime / (60 * 60)];
    }
    
    return [NSString timestampConvertString:thisTimestamp dataFormat:@"MM月dd日"];
}


+ (NSString *)generateUniqueId
{
    CFUUIDRef   uuid;
    CFStringRef uuidStr;
    
    uuid = CFUUIDCreate(NULL);
    assert(uuid != NULL);
    
    uuidStr = CFUUIDCreateString(NULL, uuid);
    assert(uuidStr != NULL);
    
    CFRelease(uuid);
    
    return (NSString *)CFBridgingRelease(uuidStr);
}

+ (NSString *)getDocumentLocation
{
    if (locDocumentPath == nil) {
        NSArray  *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        if(documentPaths.count > 0)
        {
            locDocumentPath = [documentPaths objectAtIndex:0];
        }
    }
    
    return locDocumentPath;
}

+ (NSString *)getTempLocation
{
    if (locTempPath == nil) {
        NSError * error;
        NSString * docpath = nil;
        NSArray  *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        if(documentPaths.count > 0)
        {
            docpath = [documentPaths objectAtIndex:0];
            if(docpath)
            {
                docpath = [docpath stringByAppendingPathComponent:TEMP_FOLDER_NAME];
                if(![[NSFileManager defaultManager] fileExistsAtPath:docpath])
                {
                    [[NSFileManager defaultManager] createDirectoryAtPath:docpath withIntermediateDirectories:YES attributes:nil error:&error];
                    if(error!=nil)
                    {
                        return nil; // Cannot create a directory
                    }
                }
                locTempPath = docpath;
            }
        }
    }
    return locTempPath;
}

+ (NSString *)getImageLocation
{
    if (locImagePath == nil) {
        NSError * error;
        NSString * docpath = nil;
        NSArray  *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        if(documentPaths.count > 0)
        {
            docpath = [documentPaths objectAtIndex:0];
            if(docpath)
            {
                docpath = [docpath stringByAppendingPathComponent:IMAGE_FOLDER_NAME];
                if(![[NSFileManager defaultManager] fileExistsAtPath:docpath])
                {
                    [[NSFileManager defaultManager] createDirectoryAtPath:docpath withIntermediateDirectories:YES attributes:nil error:&error];
                    if(error!=nil)
                    {
                        return nil; // Cannot create a directory
                    }
                }
                locImagePath = docpath;
            }
        }
    }
    return locImagePath;
}

+ (NSString *)getAvatarLocation
{
    if (locAvatarPath == nil) {
        NSError * error;
        NSString * docpath = nil;
        NSArray  *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        if(documentPaths.count > 0)
        {
            docpath = [documentPaths objectAtIndex:0];
            if(docpath)
            {
                docpath = [docpath stringByAppendingPathComponent:kAvatarDir];
                if(![[NSFileManager defaultManager] fileExistsAtPath:docpath])
                {
                    [[NSFileManager defaultManager] createDirectoryAtPath:docpath withIntermediateDirectories:YES attributes:nil error:&error];
                    if(error!=nil)
                    {
                        return nil; // Cannot create a directory
                    }
                }
                locAvatarPath = docpath;
            }
        }
    }
    return locAvatarPath;
}


+ (NSString *)getAudioLocation
{
    if (locAudioPath == nil) {
        NSError * error;
        NSString * docpath = nil;
        NSArray  *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        if(documentPaths.count > 0)
        {
            docpath = [documentPaths objectAtIndex:0];
            if(docpath)
            {
                docpath = [docpath stringByAppendingPathComponent:kAudioDir];
                if(![[NSFileManager defaultManager] fileExistsAtPath:docpath])
                {
                    [[NSFileManager defaultManager] createDirectoryAtPath:docpath withIntermediateDirectories:YES attributes:nil error:&error];
                    if(error!=nil)
                    {
                        return nil; // Cannot create a directory
                    }
                }
                locAudioPath = docpath;
            }
        }
    }
    return locAudioPath;
}
// 本地启动图片路径
#define kLaunchImage @"launchImage"
+ (NSString*)getLaunchImage
{
    if (launchImagePath == nil) {
        NSError * error;
        NSString * docpath = nil;
        NSArray  *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        if(documentPaths.count > 0)
        {
            docpath = [documentPaths objectAtIndex:0];
            if(docpath)
            {
                docpath = [docpath stringByAppendingPathComponent:kLaunchImage];
                if(![[NSFileManager defaultManager] fileExistsAtPath:docpath])
                {
                    [[NSFileManager defaultManager] createDirectoryAtPath:docpath withIntermediateDirectories:YES attributes:nil error:&error];
                    if(error!=nil)
                    {
                        return nil; // Cannot create a directory
                    }
                }
                launchImagePath = docpath;
            }
        }
    }
    return launchImagePath;
}

// 时间戳为毫秒
+ (NSString *)timestampConvertString:(long long)time {
    
    NSString *timeStr = [NSString timestampConvertString:time dataFormat:@"HH:mm"];
    
    return timeStr;
}

+ (NSString *)timestampConvertString:(long long)time dataFormat:(NSString *)dataFormat
{
    NSString *myStr = [NSString stringWithFormat:@"%lld", time];
    
    // 至少10位
    if (myStr.length < 10) {
        return nil;
    }
    
    NSString *myStr_s = [myStr substringToIndex:10];
    //LogInfo(@"...%@...", myStr_s);
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[myStr_s longLongValue]];
    //LogInfo(@"date:%@", [date description]);
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    //[formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //[formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    [formatter setDateFormat:dataFormat];
    
    NSString *timeStr = [formatter stringFromDate:date];
    //LogInfo(@"timeStr:%@", timeStr);
    
    return timeStr;
}



// 获取半小时后的时间字串
+ (NSString *)halfHourAfterCurrentTime {
    
    //    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //    [formatter setDateFormat:@"yyyyMMddHHmm"];  // 到分
    //
    //    NSDate *date = [NSDate date];
    //    NSString *timeStr = [formatter stringFromDate:date];
    //    long long timeCount = [timeStr longLongValue];
    //    LogInfo(@"current:%lld", timeCount);
    //    timeCount += 30;
    //    LogInfo(@"halfHour:%lld", timeCount);
    
    NSDate *date = [NSDate date];
    NSDate *nextDate = [date dateByAddingTimeInterval:(30*60)]; // 加半小时
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];  // 到分
    NSString *timeStr = [formatter stringFromDate:nextDate];
    LogInfo(@"half an hour time string:%@", timeStr);
    return timeStr;
    
}

// 获取24小时后的时间字串
+ (NSString *)oneDayAfterCurrentTime {
    
    NSDate *date = [NSDate date];
    NSDate *nextDate = [date dateByAddingTimeInterval:(24*3600)];   // 加一天
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];  // 到分
    NSString *timeStr = [formatter stringFromDate:nextDate];
    LogInfo(@"24 hours time string:%@", timeStr);
    return timeStr;
    
}

// 获取24小时前的时间字串
+ (NSString *)oneDayBeforeCurrentTime {
    
    NSDate *date = [NSDate date];
    NSDate *nextDate = [date dateByAddingTimeInterval:-(24*3600)];   // 减一天
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];  // 到分
    NSString *timeStr = [formatter stringFromDate:nextDate];
    LogInfo(@"24 hours time string:%@", timeStr);
    return timeStr;
    
}
// 格式：yyyy-MM-dd 下午 HH:mm
+ (NSString *)dateFormatter:(NSTimeInterval)seconds{
    
    long long thisTimestamp = [[[NSString stringWithFormat:@"%f",seconds] substringToIndex:10] longLongValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:thisTimestamp];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];  // 到分
    NSString *timeStr = [formatter stringFromDate:date];
    NSString* hourStr = [timeStr substringFromIndex:11];
    if ([[timeStr substringWithRange:NSMakeRange(11, 2)] intValue]>12) {
        timeStr = [[[timeStr substringToIndex:10] stringByAppendingString:@" 下午 "] stringByAppendingString:hourStr];
    }else
    {
        timeStr = [[[timeStr substringToIndex:10] stringByAppendingString:@" 上午 "] stringByAppendingString:hourStr];
    }
    LogInfo(@"24 hours time string:%@", timeStr);
    return timeStr;
    
    
}


+ (NSString*)URLencode:(NSString *)originalString
        stringEncoding:(NSStringEncoding)stringEncoding {
    
    NSArray *escapeChars = [NSArray arrayWithObjects:@";" , @"/" , @"?" , @":" ,
                            @"@" , @"&" , @"=" , @"+" ,    @"$" , @"," ,
                            @"!", @"'", @"(", @")", @"*", nil];
    
    NSArray *replaceChars = [NSArray arrayWithObjects:@"%3B" , @"/", @"?" , @":" ,
                             @"%40" , @"&" , @"=" , @"%2B" , @"%24" , @"%2C" ,
                             @"%21", @"%27", @"%28", @"%29", @"%2A", nil];
    
    int len = (int)[escapeChars count];
    
    NSMutableString *temp = [[originalString
                              stringByAddingPercentEscapesUsingEncoding:stringEncoding]
                             mutableCopy];
    
    int i;
    for (i = 0; i < len; i++) {
        
        [temp replaceOccurrencesOfString:[escapeChars objectAtIndex:i]
                              withString:[replaceChars objectAtIndex:i]
                                 options:NSLiteralSearch
                                   range:NSMakeRange(0, [temp length])];
    }
    
    NSString *outStr = [NSString stringWithString: temp];
    
    return outStr;
}

//去掉空格
-(NSString *)trim
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

+ (BOOL)isExistString:(NSString *)srcStr fingStr:(NSString *)destStr
{
    if (destStr.length==0 || srcStr.length==0)
    {
        return NO;
    }
    for (int i=0; i<srcStr.length; i+=destStr.length)
    {
        NSString *subStr = [srcStr substringWithRange:NSMakeRange(i, destStr.length)];
        if ([subStr isEqualToString:destStr])
        {
            return YES;
        }
    }
    return NO;
}

- (NSString *)md5
{
    if (self == nil || self.length == 0) {
        return @"";
    }
    const char* str = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), result);
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH*2];
    for(int i = 0; i<CC_MD5_DIGEST_LENGTH; i++) {
        [ret appendFormat:@"%02X",result[i]];   // md5加密字串转大写
    }
    return ret;
}
-(NSString *)hmac:(NSString *)plaintext withKey:(NSString *)key
{
    const char *cKey  = [key cStringUsingEncoding:NSASCIIStringEncoding];
    const char *cData = [plaintext cStringUsingEncoding:NSASCIIStringEncoding];
    unsigned char cHMAC[CC_SHA1_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA1, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    NSData *HMACData = [NSData dataWithBytes:cHMAC length:sizeof(cHMAC)];
    const unsigned char *buffer = (const unsigned char *)[HMACData bytes];
    NSMutableString *HMAC = [NSMutableString stringWithCapacity:HMACData.length * 2];
    for (int i = 0; i < HMACData.length; ++i){
        [HMAC appendFormat:@"%02x", buffer[i]];
    }
    return HMAC;
}

- (NSString *) sha1_base64
{
    const char *cstr = [self cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:self.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, (CC_LONG)data.length, digest);
    
    NSData * base64 = [[NSData alloc]initWithBytes:digest length:CC_SHA1_DIGEST_LENGTH];
    base64 = [GTMBase64 encodeData:base64];
    
    NSString * output = [[NSString alloc] initWithData:base64 encoding:NSUTF8StringEncoding];
    return output;
}

- (NSString *) md5_base64
{
    const char *cStr = [self UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), digest );
    
    NSData * base64 = [[NSData alloc]initWithBytes:digest length:CC_MD5_DIGEST_LENGTH];
    base64 = [GTMBase64 encodeData:base64];
    
    NSString * output = [[NSString alloc] initWithData:base64 encoding:NSUTF8StringEncoding];
    return output;
}
//获得设备型号
+ (NSString *)getCurrentDeviceModel
{
    int mib[2];
    size_t len;
    char *machine;
    
    mib[0] = CTL_HW;
    mib[1] = HW_MACHINE;
    sysctl(mib, 2, NULL, &len, NULL, 0);
    machine = malloc(len);
    sysctl(mib, 2, machine, &len, NULL, 0);
    
    NSString *platform = [NSString stringWithCString:machine encoding:NSASCIIStringEncoding];
    free(machine);
    
    //iPhone
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G (A1203)";
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G (A1241/A1324)";
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS (A1303/A1325)";
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4 (A1332)";
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4 (A1332)";
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4 (A1349)";
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S (A1387/A1431)";
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5 (A1428)";
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5 (A1429/A1442)";
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c (A1456/A1532)";
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c (A1507/A1516/A1526/A1529)";
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s (A1453/A1533)";
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s (A1457/A1518/A1528/A1530)";
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6 (A1549/A1586)";
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus (A1522/A1524)";
    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6s (A1633/A1688/A1691/A1700)";
    if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus (A1634/A1687/A1690/A1699)";
    
    //iPod Touch
    if ([platform isEqualToString:@"iPod1,1"])   return @"iPod Touch (A1213)";
    if ([platform isEqualToString:@"iPod2,1"])   return @"iPod Touch 2G (A1288)";
    if ([platform isEqualToString:@"iPod3,1"])   return @"iPod Touch 3G (A1318)";
    if ([platform isEqualToString:@"iPod4,1"])   return @"iPod Touch 4G (A1367)";
    if ([platform isEqualToString:@"iPod5,1"])   return @"iPod Touch 5G (A1421/A1509)";
    if ([platform isEqualToString:@"iPod7,1"])   return @"iPod Touch 6G (A1574)";
    
    //iPad
    if ([platform isEqualToString:@"iPad1,1"])   return @"iPad (A1219/A1337)";
    if ([platform isEqualToString:@"iPad2,1"])   return @"iPad 2 (A1395)";
    if ([platform isEqualToString:@"iPad2,2"])   return @"iPad 2 (A1396)";
    if ([platform isEqualToString:@"iPad2,3"])   return @"iPad 2 (A1397)";
    if ([platform isEqualToString:@"iPad2,4"])   return @"iPad 2 (A1395+New Chip)";
    if ([platform isEqualToString:@"iPad3,1"])   return @"iPad 3 (A1416)";
    if ([platform isEqualToString:@"iPad3,2"])   return @"iPad 3 (A1403)";
    if ([platform isEqualToString:@"iPad3,3"])   return @"iPad 3 (A1430)";
    if ([platform isEqualToString:@"iPad3,4"])   return @"iPad 4 (A1458)";
    if ([platform isEqualToString:@"iPad3,5"])   return @"iPad 4 (A1459)";
    if ([platform isEqualToString:@"iPad3,6"])   return @"iPad 4 (A1460)";
    
    //iPad Air
    if ([platform isEqualToString:@"iPad4,1"])   return @"iPad Air (A1474)";
    if ([platform isEqualToString:@"iPad4,2"])   return @"iPad Air (A1475)";
    if ([platform isEqualToString:@"iPad4,3"])   return @"iPad Air (A1476)";
    if ([platform isEqualToString:@"iPad5,3"])   return @"iPad Air 2 (A1566)";
    if ([platform isEqualToString:@"iPad5,4"])   return @"iPad Air 2 (A1567)";
    
    //iPad mini
    if ([platform isEqualToString:@"iPad2,5"])   return @"iPad mini 1G (A1432)";
    if ([platform isEqualToString:@"iPad2,6"])   return @"iPad mini 1G (A1454)";
    if ([platform isEqualToString:@"iPad2,7"])   return @"iPad mini 1G (A1455)";
    if ([platform isEqualToString:@"iPad4,4"])   return @"iPad mini 2 (A1489)";
    if ([platform isEqualToString:@"iPad4,5"])   return @"iPad mini 2 (A1490)";
    if ([platform isEqualToString:@"iPad4,6"])   return @"iPad mini 2 (A1491)";
    if ([platform isEqualToString:@"iPad4,7"])   return @"iPad mini 3 (A1599)";
    if ([platform isEqualToString:@"iPad4,8"])   return @"iPad mini 3 (A1600)";
    if ([platform isEqualToString:@"iPad4,9"])   return @"iPad mini 3 (A1601)";
    if ([platform isEqualToString:@"iPad5,1"])   return @"iPad mini 4 (A1538)";
    if ([platform isEqualToString:@"iPad5,2"])   return @"iPad mini 4 (A1550)";
    
    if ([platform isEqualToString:@"i386"])      return @"iPhone Simulator";
    if ([platform isEqualToString:@"x86_64"])    return @"iPhone Simulator";
    return platform;
}
/*
 app_name			应用名称，
 app_version			应用版本号，如：4.2.3
 os_name				操作系统名称，如：iPhone OS、Android
 os_version			操作系统版本，如：iOS 8.1、Android 4.4
 device_brand		设备品牌，如：iPhone、iPad
 device_model		设备型号，如：iPad2、iPhone4、iPhone5、iPhone6
 device_resolution	设备分辨率，如：768*1024
 
 组装字符串格式：
	[device_brand]/[device_model]/[device_resolution] [os_name]/[os_version] [app_name]/[app_version]
	
 iOS实际组装字符串参考：
	iPhone/iPhone6/320*480 iPhone OS/iOS 8.1 KKMY_U/4.2.3
 */
+ (NSString *)httpHeaderAgent{
    NSString * agent = [NSString stringWithFormat:@"iPhone/%@/%.0f*%.0f iOS/%@ %@ %@/%@",
                        [NSString getCurrentDeviceModel],
                        kScreenWidth,
                        kScreenHeight,
                        [UIDevice currentDevice].systemName,
                        [UIDevice currentDevice].systemVersion,
                        [[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleExecutableKey] ?: [[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleIdentifierKey],
                        [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"] ?: [[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleVersionKey]];
    return agent;
}

+ (NSString *)safeString:(id)obj{
    if (obj) {
        return [NSString stringWithFormat:@"%@",obj];
    }else{
        NSString * blankString = @"";
        return blankString;
    }
}

- (NSString *)removeBlank{
    if (self == nil || [self isEqual:[NSNull null]]) {
        return nil;
    }
    return [self stringByReplacingOccurrencesOfString:@"\\s+" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, [self length])];
}
+ (NSString *)fileSizeToString:(unsigned long long)fileSize{
    NSInteger KB = 1024;
    NSInteger MB = KB*KB;
    NSInteger GB = MB*KB;
    
    if (fileSize < 10)
    {
        return @"0B";
        
    }else if (fileSize < KB)
    {
        return @"< 1KB";
        
    }else if (fileSize < MB)
    {
        return [NSString stringWithFormat:@"%.1fK",((CGFloat)fileSize)/KB];
        
    }else if (fileSize < GB)
    {
        return [NSString stringWithFormat:@"%.1fM",((CGFloat)fileSize)/MB];
        
    }else
    {
        return [NSString stringWithFormat:@"%.1fG",((CGFloat)fileSize)/GB];
    }
}

+ (NSString *)getNetWorkStates{
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *children = [[[app valueForKeyPath:@"statusBar"]valueForKeyPath:@"foregroundView"]subviews];
    NSString *state = @"无网络";
    int netType = 0;
    //获取到网络返回码
    for (id child in children) {
        if ([child isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")]) {
            //获取到状态栏
            netType = [[child valueForKeyPath:@"dataNetworkType"]intValue];
            
            switch (netType) {
                case 0:
                    state = @"无网络";
                    //无网模式
                    break;
                case 1:
                    state = @"2G";
                    break;
                case 2:
                    state = @"3G";
                    break;
                case 3:
                    state = @"4G";
                    break;
                case 5:
                {
                    state = @"WIFI";
                }
                    break;
                default:
                    break;
            }
        }
    }
    //根据状态选择
    return state;
}
/**
 *  适配html中的<,>,<=,>=
 *
 *  @param str html中的包含<,>,<=,>=转义的字符串
 *
 *  @return 转成<,>,<=,>=的字符串
 */
+ (NSString *)adapterHtml:(NSString *)str
{
    NSString *adapterStr = nil;
    if([str rangeOfString:@"&lt;"].length>0){//"<"
        adapterStr = [str stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    }else if ([str rangeOfString:@"&le;"].length>0){//"<="
        adapterStr = [str stringByReplacingOccurrencesOfString:@"&le;" withString:@"<="];
    }else if([str rangeOfString:@"&gt;"].length>0){//">"
        adapterStr = [str stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    }else if ([str rangeOfString:@"&ge;"].length>0){//">="
        adapterStr = [str stringByReplacingOccurrencesOfString:@"&ge;" withString:@">="];
    }else{
        adapterStr = str;
    }
    return adapterStr;
}
- (BOOL) emojiInUnicode:(short)code
{
	if (code == 0x0023
		|| code == 0x002A
		|| (code >= 0x0030 && code <= 0x0039)
		|| code == 0x00A9
		|| code == 0x00AE
		|| code == 0x203C
		|| code == 0x2049
		|| code == 0x2122
		|| code == 0x2139
		|| (code >= 0x2194 && code <= 0x2199)
		|| code == 0x21A9 || code == 0x21AA
		|| code == 0x231A || code == 0x231B
		|| code == 0x2328
		|| code == 0x23CF
		|| (code >= 0x23E9 && code <= 0x23F3)
		|| (code >= 0x23F8 && code <= 0x23FA)
		|| code == 0x24C2
		|| code == 0x25AA || code == 0x25AB
		|| code == 0x25B6
		|| code == 0x25C0
		|| (code >= 0x25FB && code <= 0x25FE)
		|| (code >= 0x2600 && code <= 0x2604)
		|| code == 0x260E
		|| code == 0x2611
		|| code == 0x2614 || code == 0x2615
		|| code == 0x2618
		|| code == 0x261D
		|| code == 0x2620
		|| code == 0x2622 || code == 0x2623
		|| code == 0x2626
		|| code == 0x262A
		|| code == 0x262E || code == 0x262F
		|| (code >= 0x2638 && code <= 0x263A)
		|| (code >= 0x2648 && code <= 0x2653)
		|| code == 0x2660
		|| code == 0x2663
		|| code == 0x2665 || code == 0x2666
		|| code == 0x2668
		|| code == 0x267B
		|| code == 0x267F
		|| (code >= 0x2692 && code <= 0x2694)
		|| code == 0x2696 || code == 0x2697
		|| code == 0x2699
		|| code == 0x269B || code == 0x269C
		|| code == 0x26A0 || code == 0x26A1
		|| code == 0x26AA || code == 0x26AB
		|| code == 0x26B0 || code == 0x26B1
		|| code == 0x26BD || code == 0x26BE
		|| code == 0x26C4 || code == 0x26C5
		|| code == 0x26C8
		|| code == 0x26CE
		|| code == 0x26CF
		|| code == 0x26D1
		|| code == 0x26D3 || code == 0x26D4
		|| code == 0x26E9 || code == 0x26EA
		|| (code >= 0x26F0 && code <= 0x26F5)
		|| (code >= 0x26F7 && code <= 0x26FA)
		|| code == 0x26FD
		|| code == 0x2702
		|| code == 0x2705
		|| (code >= 0x2708 && code <= 0x270D)
		|| code == 0x270F
		|| code == 0x2712
		|| code == 0x2714
		|| code == 0x2716
		|| code == 0x271D
		|| code == 0x2721
		|| code == 0x2728
		|| code == 0x2733 || code == 0x2734
		|| code == 0x2744
		|| code == 0x2747
		|| code == 0x274C
		|| code == 0x274E
		|| (code >= 0x2753 && code <= 0x2755)
		|| code == 0x2757
		|| code == 0x2763 || code == 0x2764
		|| (code >= 0x2795 && code <= 0x2797)
		|| code == 0x27A1
		|| code == 0x27B0
		|| code == 0x27BF
		|| code == 0x2934 || code == 0x2935
		|| (code >= 0x2B05 && code <= 0x2B07)
		|| code == 0x2B1B || code == 0x2B1C
		|| code == 0x2B50
		|| code == 0x2B55
		|| code == 0x3030
		|| code == 0x303D
		|| code == 0x3297
		|| code == 0x3299
		// 第二段
		|| code == 0x23F0) {
		return YES;
	}
	return NO;
}
/**
 * 一种非官方的, 采用私有Unicode 区域
 * e0 - e5  01 - 59
 */
- (BOOL) emojiInSoftBankUnicode:(short)code
{
	return ((code >> 8) >= 0xE0 && (code >> 8) <= 0xE5 && (Byte)(code & 0xFF) < 0x60);
}

- (BOOL) containEmoji
{
	NSUInteger len = [self lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
	if (len < 3) {  // 大于2个字符需要验证Emoji(有些Emoji仅三个字符)
		return NO;
	}

	// 仅考虑字节长度为3的字符,大于此范围的全部做Emoji处理
	NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];

	Byte *bts = (Byte *)[data bytes];
	Byte bt;
	short v;
	for (NSUInteger i = 0; i < len; i++) {
		bt = bts[i];

		if ((bt | 0x7F) == 0x7F) {  // 0xxxxxxx  ASIIC编码
			continue;
		}
		if ((bt | 0x1F) == 0xDF) {  // 110xxxxx  两个字节的字符
			i += 1;
			continue;
		}
		if ((bt | 0x0F) == 0xEF) {  // 1110xxxx  三个字节的字符(重点过滤项目)
			// 计算Unicode下标
			v = bt & 0x0F;
			v = v << 6;
			v |= bts[i + 1] & 0x3F;
			v = v << 6;
			v |= bts[i + 2] & 0x3F;

			//            NSLog(@"%02X%02X", (Byte)(v >> 8), (Byte)(v & 0xFF));

			if ([self emojiInSoftBankUnicode:v] || [self emojiInUnicode:v]) {
				return YES;
			}

			i += 2;
			continue;
		}
		if ((bt | 0x3F) == 0xBF) {  // 10xxxxxx  10开头,为数据字节,直接过滤
			continue;
		}

		return YES;                 // 不是以上情况的字符全部超过三个字节,做Emoji处理
	}
	
	return NO;
}
@end
