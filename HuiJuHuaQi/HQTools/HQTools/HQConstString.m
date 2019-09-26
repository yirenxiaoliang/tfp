//
//  HQConstString.m
//  HuiJuHuaQi
//
//  Created by hq002 on 16/5/23.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQConstString.h"
#import "HQCustomerStringCModel.h"

@implementation HQConstString

/** 管理员（包含所有权限） */
NSString * const AuthorityType_ADMIN = @"0001";

/** “考勤设置”界面编辑； 在“考勤中心”模块中 点击“考勤设置”按钮，可以查看设置且编辑、发布 考勤规则，对应控制台的权限 301（设置规则）； */
NSString * const AuthorityType_ATTENDANCE_SETTING = @"C1001";

/** “公司考勤”界面查看； 在“考勤中心”模块中
 * 点击“考勤统计”中的“公司考勤”按钮，有该权限的可以查看公司各个考勤组的考勤状况，对应控制台的权限 302（查看统计）； */
NSString * const AuthorityType_ATTENDANCE_FOR_COMPANY = @"C1002";

/** 投诉建议的标签管理 */
NSString * const AuthorityType_SUGGESTION_TAG_MANAGER = @"C7001";

/** 发布通知 */ 
NSString * const AuthorityType_PUBLISH_NOTIFY = @"C9001";

/** CRM查看权限 */
NSString * const AuthorityType_LOOK_CRM_PERMISSION = @"C5001";

/** CRM管理权限 */
NSString * const AuthorityType_CRM_MANAGER = @"C5002";

/** 发布紧急事务权限 */
NSString * const AuthorityType_PUBLISH_URGENTMISSION = @"CA001";


/*************   判断权限  ********************/

/** 管理员（包含所有权限） */
+ (BOOL)isAdmin
{
   return [HQConstString isAuthorityWithConstString:AuthorityType_ADMIN];
}


/** “考勤设置”界面编辑  */
+ (BOOL)isAttendanceSetting
{
    return [HQConstString isAuthorityWithConstString:AuthorityType_ATTENDANCE_SETTING];
}



/** “公司考勤”界面查看； 在“考勤中心”模块中
 * 点击“考勤统计”中的“公司考勤”按钮，有该权限的可以查看公司各个考勤组的考勤状况，对应控制台的权限 302（查看统计）； */
+ (BOOL)isAttendanceForCompany
{
    return [HQConstString isAuthorityWithConstString:AuthorityType_ATTENDANCE_FOR_COMPANY];
}


/** 投诉建议的标签管理 */
+ (BOOL)isSuggestionTagManager
{
    return [HQConstString isAuthorityWithConstString:AuthorityType_SUGGESTION_TAG_MANAGER];
}


/** 发布通知 */
+ (BOOL)isPublishNotify
{
    return [HQConstString isAuthorityWithConstString:AuthorityType_PUBLISH_NOTIFY];
}


/** CRM查看权限 */
+ (BOOL)isLookCrmPermission
{
    return [HQConstString isAuthorityWithConstString:AuthorityType_LOOK_CRM_PERMISSION];
}


/** CRM管理权限 */
+ (BOOL)isCrmManager
{
    return [HQConstString isAuthorityWithConstString:AuthorityType_CRM_MANAGER];
}


/** 发布紧急事务权限 */
+ (BOOL)isPublishUrgentMission
{
    return [HQConstString isAuthorityWithConstString:AuthorityType_PUBLISH_URGENTMISSION];
}



/** 公共方法 */
+ (BOOL)isAuthorityWithConstString:(NSString *)constString
{
    
    if (HQDebugSwitch) {
        return YES;
    }
    
    HQUserManager *user = [HQUserManager defaultUserInfoManager];
    HQUserLoginCModel *login = [user userLoginInfo];
    
#warning new Core Data
//    NSArray *auths = [login.authorityList allObjects];
    BOOL isAuthority = NO;
//    if (auths.count) {
//
//        for (HQCustomerStringCModel *authotity in auths) {
//            
//            //当有该权限或管理员权限时返回YES
//            if ([constString isEqualToString:authotity.desc]
//                ||  [AuthorityType_ADMIN isEqualToString:authotity.desc]) {
//                
//                isAuthority = YES;
//                break;
//            }
//        }
//    }
    return isAuthority;
}



@end
