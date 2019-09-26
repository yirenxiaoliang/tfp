//
//  TFAssistantPushModel.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/1/2.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"
#import "TFAssistantApproModel.h"
#import "TFAssistantFieldInfoModel.h"

@interface TFAssistantPushModel : JSONModel

/** 推送类型
 1：企信小助手
 2：@推送
 3：自定义应用
 4：审批
 5：文件库
 6：朋友圈
 7：备忘录
 8：邮件
 9：流程自动化
 10：移除成员
 11：添加群成员
 12：退群
 13：群信息变化
 14：任务小助手推送
 15：置顶与取消置顶
 16：标记一条已读
 17：标记全部已读
 18：免打扰状态变化
 19：只查看未读消息
 20：审批操作推送消息
 21：转让群推送
 25：个人任务
 26：项目任务
 1000：人员与组织架构变化
 1001：被系统强制离线
 1002：助手/应用更改
 1003：模块更改
 1004：应用删除
 1005：隐藏/显示应用及助手
 1100：被PC端强制离线
 */
@property (nonatomic, strong) NSNumber <Optional>*type;

@property (nonatomic, copy) NSString <Optional>*push_content;

@property (nonatomic, strong) NSNumber <Optional>*assistant_id;

@property (nonatomic, copy) NSString <Optional>*bean_name;

@property (nonatomic, copy) NSString <Optional>*bean_name_chinese;

@property (nonatomic, copy) NSString <Optional>*title;

@property (nonatomic, copy) NSString <Optional>*sender_name;

@property (nonatomic, strong) NSArray <TFAssistantFieldInfoModel,Optional>*field_info;

@property (nonatomic, strong) NSNumber <Optional>*create_time;

@property (nonatomic, strong) NSNumber <Optional>*datetime_create_time;

@property (nonatomic, copy) NSString <Optional>*read_status;

@property (nonatomic, strong) NSNumber <Optional>*group_id;

@property (nonatomic, strong) NSNumber <Optional>*id;

@property (nonatomic, strong) NSNumber <Optional>*data_id;

/** 审批小助手字段 */
//@property (nonatomic, copy) NSString <Optional>*param_fields;     0706：貌似被改成了对象
@property (nonatomic, strong) TFAssistantApproModel <Optional>*param_fields;

@property (nonatomic, strong) NSNumber <Optional>*style;

@property (nonatomic, copy) NSString <Optional>*icon_url;

@property (nonatomic, copy) NSString <Optional>*icon_color;

@property (nonatomic, copy) NSString <Optional>*icon_type;

@property (nonatomic, copy) NSString <Optional>*application_name;

@property (nonatomic, copy) NSString <Optional>*module_name;

@property (nonatomic, copy) NSString <Optional>*field;

@end
