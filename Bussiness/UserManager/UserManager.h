//
//  UserManager.h
//  ChineseClass
//
//  Created by yangjuanping on 2018/5/6.
//  Copyright © 2018年 jiulong zhou. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "StudentModel.h"
//#import "TeacherModel.h"
@interface UserManager : NSObject
//@property (nonatomic,strong) StudentModel *studentInfo;
//@property (nonatomic,strong) TeacherModel *teacherInfo;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *age;
@property (nonatomic,strong) NSString *points;
@property (nonatomic,strong) NSString *token;
+ (instancetype)shareInstance;
//- (void)saveStudent:(StudentModel *)student;
//- (void)saveTeacher:(TeacherModel *)teacher;
- (void)resetData;
@end
