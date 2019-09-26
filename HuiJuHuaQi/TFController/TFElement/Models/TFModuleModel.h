//
//  TFModuleModel.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/12/8.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"

@protocol TFModuleModel 
@end

@interface TFModuleModel : JSONModel<NSCopying,NSMutableCopying>

/**
 "chinese_name":"测试删除",
 "create_by":"11",
 "create_time":1512613203611,
 "modify_time":"",
 "icon":"el-icon-star-off",
 "topper":1,
 "del_status":"0",
 "id":15,
 "modify_by":"",
 "application_id":11,
 "english_name":"bean1512613237585" */

/** create_by */
@property (nonatomic, copy) NSString <Optional>*create_by;
/** create_time */
@property (nonatomic, copy) NSString <Optional>*create_time;
/** modify_time */
@property (nonatomic, copy) NSString <Optional>*modify_time;
/** icon */
@property (nonatomic, copy) NSString <Optional>*icon;
/** topper */
@property (nonatomic, copy) NSString <Optional>*topper;
/** del_status */
@property (nonatomic, copy) NSString <Optional>*del_status;
/** modify_by */
@property (nonatomic, copy) NSString <Optional>*modify_by;
/** application_id */
@property (nonatomic, strong) NSNumber <Optional>*application_id;


/** english_name */
@property (nonatomic, copy) NSString <Optional>*english_name;
/** id */
@property (nonatomic, strong) NSNumber <Optional>*id;
/** chinese_name */
@property (nonatomic, copy) NSString <Optional>*chinese_name;
/** icon_color */
@property (nonatomic, copy) NSString <Optional>*icon_color;
/** icon_color */
@property (nonatomic, copy) NSString <Optional>*icon_type;
/** icon_color */
@property (nonatomic, copy) NSString <Optional>*icon_url;
/** data_type */
@property (nonatomic, strong) NSNumber <Optional>*data_type;

/** 选择 */
@property (nonatomic, strong) NSNumber <Ignore>*select;
/** 子菜单s */
@property (nonatomic, strong) NSArray <Ignore>*submenus;

/** 邮件未读s */
@property (nonatomic, strong) NSArray <Ignore>*emailUnreads;
/** 审批未读s */
@property (nonatomic, strong) NSArray <Ignore>*approvalUnreads;

@end
