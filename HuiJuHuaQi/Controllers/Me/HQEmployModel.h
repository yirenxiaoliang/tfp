//
//  HQEmployModel.h
//  HuiJuHuaQi
//
//  Created by XieLB on 16/1/12.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"
#import "TFEmployModel.h"

@protocol HQEmployModel @end

@interface HQEmployModel : JSONModel

/** 员工id */
@property (nonatomic, strong) NSNumber <Optional>*id;
/** employee_id */
@property (nonatomic, strong) NSNumber <Optional>*employee_id;

/** 员工id */
@property (nonatomic, strong) NSNumber <Optional>*sign_id;

/** value */
@property (nonatomic, copy) NSString <Optional>*value;
/** 员工姓名 */
@property (nonatomic, copy) NSString <Optional>*employeeName;
/** 图片url，一般为员工的头像 */
@property (nonatomic, copy) NSString <Optional>*photograph;
/** 职位，对此员工在某部门的头衔 */
@property (nonatomic, copy) NSString <Optional>*position;
/** 职位id */
@property (nonatomic, copy) NSNumber <Optional>*positionId;
/** 部门id，未分组也有此id */
@property (nonatomic, strong) NSNumber <Optional>*departmentId;
/** 部门id，未分组也有此id */
@property (nonatomic, strong) NSMutableArray <Optional>*departmentIds;
/** 部门名 */
@property (nonatomic, copy) NSString <Optional>*department;
/** 部门名 */
@property (nonatomic, copy) NSString <Optional>*departmentName;
/** 角色类型0其他1所有者2管理员3成员4访客 */
@property (nonatomic, strong) NSNumber <Optional>*roleType;
/** roleId */
@property (nonatomic, strong) NSNumber <Optional>*roleId;
/** 角色名称 */
@property (nonatomic, copy) NSString <Optional>*roleName;
/** 联系手机号，一般为此员工在注册时使用的手机号 */
@property (nonatomic, copy) NSString <Optional>*telephone;
@property (nonatomic, copy) NSString <Optional>*mobile_phone;

/** 员工入职状态：0：正式；1：试用；2：实习 */
@property (nonatomic, strong) NSNumber <Optional>*workStatus;
/** 性别，0为雄，1为雌，默认为0 */
@property (nonatomic, strong) NSNumber <Optional>*gender;
/** 极光用户名 */
@property (nonatomic, copy) NSString <Optional>*imUserName;
/** 编号 */
@property (nonatomic, copy) NSString <Optional>* employeeNumber ;
/** 激活 */
@property (nonatomic, copy) NSString <Optional>* isActive;
/** 公司名 */
@property (nonatomic, copy) NSString <Optional>* companyName;
/** 签名 */
@property (nonatomic, copy) NSString <Optional>* personSignature;
/** 背景图片 */
@property (nonatomic, copy) NSString <Optional>* microblog_background;


/** 员工还是部门 1：人员 ，4：部门 */
@property (nonatomic, strong) NSNumber <Optional>*type;

/** 员工状态 */
@property (nonatomic, strong) NSNumber <Optional>*employeeStatus;
/** 公司id */
@property (nonatomic, strong) NSNumber <Optional>*companyId;
/** 用户id */
@property (nonatomic, strong) NSNumber <Optional>* userId ;
/** 审核状态 0未审核 1审核通过 */
@property (nonatomic, strong) NSNumber <Optional>* verifyStatus ;
/** 邮箱 */
@property (nonatomic, copy) NSString <Optional>* email;
/** 创建时间 */
@property (nonatomic, strong) NSNumber <Optional>* createDate ;
/** 年龄 */
@property (nonatomic, strong) NSNumber <Optional>* employeeAge ;
/** 0正常1停用 */
@property (nonatomic, strong) NSNumber <Optional>* disabled ;
/** 是否是此部门负责人 0否 1是 */
@property (nonatomic, strong) NSNumber <Optional>* isPrincipal ;
/** 是不是创建者 */
@property (nonatomic, strong) NSNumber <Optional>* isCreator ;
/** 婚姻状况 0其他 1已婚 2未婚 */
@property (nonatomic, strong) NSNumber <Optional>* maritalStatus ;
/** 在职时长 */
@property (nonatomic, strong) NSNumber <Optional>* incumbency ;

/** 点赞id */
@property (nonatomic, strong) NSNumber <Optional>* upvoteId ;
/**  */
@property (nonatomic, strong) NSNumber <Optional>* employeeId;

/** 项目负责人 */
@property (nonatomic, strong) NSNumber <Optional>* project_member_id ;
/** 项目负责人 */
@property (nonatomic, strong) NSNumber <Optional>* isProjectPrincipal ;
/** 项目创建人 */
@property (nonatomic, strong) NSNumber <Optional>* isProjectCreator ;

/** 自己加的字段 */
@property (nonatomic, strong) NSNumber <Ignore>*selectState;

@property (nonatomic, strong) NSNumber <Ignore>*disSelectState;

@property (nonatomic, copy) NSString <Ignore>*levelNum;

//@property (nonatomic, strong) NSMutableArray <Optional>*authNames;//协作人权限

@property (nonatomic, copy) NSString <Optional>*authName;//协作权限
//权限ID
@property (nonatomic, strong) NSNumber <Optional>*authId;

@property (nonatomic, strong) NSNumber <Optional>*manageId;
//管理员
@property (nonatomic, copy) NSString <Optional>*manage;

//文件id
@property (nonatomic, strong) NSNumber <Optional>*diskId;

/** 位置  */
@property (nonatomic, strong) NSNumber <Ignore>*location;
@property (nonatomic, strong) NSNumber <Ignore>*length;

/** 投诉建议抄送人 */
@property (nonatomic, copy) NSString <Optional>*picture;
/** 名字 */
@property (nonatomic, copy) NSString <Optional>*name;

@property (nonatomic, copy) NSString <Optional>*employee_name;

@property (nonatomic, strong) UIImage <Ignore>*image;


+ (HQEmployModel *)employeeWithEmployeeCModel:(TFEmployeeCModel *)employee;

//+ (TFEmployModel *)hqEmployeeToTfEmployee:(HQEmployModel *)employee;

@end
