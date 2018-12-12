//
//  UserManager.m
//  ChineseClass
//
//  Created by yangjuanping on 2018/5/6.
//  Copyright © 2018年 jiulong zhou. All rights reserved.
//

#import "UserManager.h"

@implementation UserManager

+ (instancetype)shareInstance{
    static UserManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!sharedInstance) {
            sharedInstance = [[self alloc] init];
        }
    });
    return sharedInstance;

}
- (void)resetData{
//    self.studentInfo = nil;
//    self.teacherInfo = nil;
}
- (NSString *)name{
    return @"";
//    NSString *name = self.studentInfo.name.length>0 ?self.studentInfo.name:self.studentInfo.nickName;
//    return name.length>0 ? name : self.studentInfo.uid;
}
- (NSString *)age{
//    if (!self.studentInfo.birthday) {
//        return  nil;
//    }
//    NSTimeInterval seconds = [[NSDate date] timeIntervalSince1970] - self.studentInfo.birthday.longLongValue/1000;
//    return [NSString stringWithFormat:@"%.f years old", seconds/(60*60*24*365)];
    return @"";
}
//- (void)saveStudent:(StudentModel *)student{
//    [[NSUserDefaults standardUserDefaults] setValue:[student toJSONString] forKey:kStrUserinfo];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//    self.studentInfo = student;
//}
//
//- (void)saveTeacher:(TeacherModel *)teacher{
//    [[NSUserDefaults standardUserDefaults] setValue:[teacher toJSONString] forKey:kStrUserinfo];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//    self.teacherInfo = teacher;
//}
//
//- (StudentModel *)studentInfo{
//    if (!_studentInfo) {
//        _studentInfo = [[StudentModel alloc] initWithString:[[NSUserDefaults standardUserDefaults] objectForKey:kStrUserinfo] error:nil];
//    }
//    return _studentInfo;
//}
//
//- (TeacherModel *)teacherInfo{
//    if (!_teacherInfo) {
//        _teacherInfo = [[TeacherModel alloc] initWithString:[[NSUserDefaults standardUserDefaults] objectForKey:kStrUserinfo] error:nil];
//    }
//    return _teacherInfo;
//}
- (NSString *)token{
    if (!_token) {
        _token = [[NSUserDefaults standardUserDefaults] valueForKey:kStrUserToken];
    }
    return _token;
}
@end
