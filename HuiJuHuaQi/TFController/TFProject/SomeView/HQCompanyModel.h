//
//  HQCompanyModel.h
//  HuiJuHuaQi
//
//  Created by XieLB on 16/5/3.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"
#import "HQBaseVoModel.h"

@interface HQCompanyModel : HQBaseVoModel

////地址
//@property (nonatomic, strong) NSString <Optional> *address;
//
////名字
//@property (nonatomic, strong) NSString <Optional> *companyName;
//
//@property (nonatomic, strong) NSString <Optional> *id;
//
////法人ID
//@property (nonatomic, strong) NSString <Optional> *lealPersonId;
//
//
//@property (nonatomic, strong) NSString <Optional> *telphone;



/** 地址 */
@property (nonatomic, strong) NSString <Optional> *companyAddress;

/** 电话 */
@property (nonatomic, strong) NSString <Optional> *telephone;

/** 法人ID(对应用户ID) */
@property (nonatomic, strong) NSNumber <Optional>*lealPersonId;

/** 公司简称 */
@property (nonatomic, strong) NSString <Optional> *shortName;

/** 公司logo对应的图片路径 */
@property (nonatomic, strong) NSString <Optional> *attachmentUrl;

/** 地区 */
@property (nonatomic, strong) NSString <Optional> *region;
/** 地区id */
@property (nonatomic, strong) NSString <Optional> *regionId;

/** 行业 */
@property (nonatomic, strong) NSString <Optional> *industry;
/** 行业id */
@property (nonatomic, strong) NSString <Optional> *industryId;

/** 默认环信聊天的群组，由华企小秘书创建 */
@property (nonatomic, strong) NSString <Optional> *defaultChatGroup;

/** 代商ID，可为空 */
@property (nonatomic, strong) NSNumber <Optional>*agentId;

/** 备注，可为空 */
@property (nonatomic, copy) NSString <Optional> *mark;

/** 公司负责人，对应员工id **/
@property (nonatomic, strong) NSNumber <Optional>*principalId;


/** 公司名称 */
@property (nonatomic, copy) NSString <Optional> *company_name;

/** 公司名称 */
@property (nonatomic, copy) NSString <Optional> *companyName;
/** 是否为默认公司 */
@property (nonatomic, strong) NSNumber <Optional>*isDefault;
/** 创建人员工作态 */
@property (nonatomic, strong) NSNumber <Optional>*employeeStatus;
/** 创建人员 */
@property (nonatomic, copy) NSString <Optional>*employeeName;
/** 创建人员id */
@property (nonatomic, strong) NSNumber <Optional>*employeeId;


@end
