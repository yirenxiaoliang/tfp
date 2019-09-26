//
//  HQConstString.h
//  HuiJuHuaQi
//
//  Created by hq002 on 16/5/23.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HQConstString : NSObject

/** 管理员（包含所有权限） */
extern  NSString * const AuthorityType_ADMIN;
/** “考勤设置”界面编辑； 在“考勤中心”模块中 点击“考勤设置”按钮，可以查看设置且编辑、发布 考勤规则，对应控制台的权限 301（设置规则）； */
extern  NSString * const AuthorityType_ATTENDANCE_SETTING;
/** “公司考勤”界面查看； 在“考勤中心”模块中
 * 点击“考勤统计”中的“公司考勤”按钮，有该权限的可以查看公司各个考勤组的考勤状况，对应控制台的权限 302（查看统计）； */
extern  NSString * const AuthorityType_ATTENDANCE_FOR_COMPANY;
/** 投诉建议的标签管理 */
extern  NSString * const AuthorityType_SUGGESTION_TAG_MANAGER;
/** 发布通知 */
extern  NSString * const AuthorityType_PUBLISH_NOTIFY;
/** CRM查看权限 */
extern  NSString * const AuthorityType_LOOK_CRM_PERMISSION;
/** CRM管理权限 */
extern  NSString * const AuthorityType_CRM_MANAGER;
/** 发布紧急事务权限 */
extern NSString  * const AuthorityType_PUBLISH_URGENTMISSION;





/*************   判断权限  ********************/

/** 管理员（包含所有权限） */
+ (BOOL)isAdmin;

/** “考勤设置”界面编辑  */
+ (BOOL)isAttendanceSetting;

/** “公司考勤”界面查看； 在“考勤中心”模块中
 * 点击“考勤统计”中的“公司考勤”按钮，有该权限的可以查看公司各个考勤组的考勤状况，对应控制台的权限 302（查看统计）； */
+ (BOOL)isAttendanceForCompany;

/** 投诉建议的标签管理 */
+ (BOOL)isSuggestionTagManager;

/** 发布通知 */
+ (BOOL)isPublishNotify;

/** CRM查看权限 */
+ (BOOL)isLookCrmPermission;

/** CRM管理权限 */
+ (BOOL)isCrmManager;

/** 发布紧急事务权限 */
+ (BOOL)isPublishUrgentMission;



@end
