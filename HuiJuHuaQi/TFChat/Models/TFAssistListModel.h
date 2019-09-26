//
//  TFAssistListModel.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/1/2.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"
#import "TFAssistantFieldInfoModel.h"

@protocol TFAssistListModel @end

@interface TFAssistListModel : JSONModel

@property (nonatomic, strong) NSArray <TFAssistantFieldInfoModel,Optional>*field_info;

@property (nonatomic, copy) NSString <Optional>*bean_name;

@property (nonatomic, strong) NSNumber <Optional>*assistant_id;

@property (nonatomic, strong) NSNumber <Optional>*id;

/** 0:未查看 1:已查看 */
@property (nonatomic, copy) NSString <Optional>*read_status;

@property (nonatomic, copy) NSString <Optional>*push_content;

@property (nonatomic, copy) NSString <Optional>*bean_name_chinese;

@property (nonatomic, strong) NSNumber <Optional>*datetime_create_time;

//文件id
@property (nonatomic, strong) NSNumber <Optional>*data_id;

@property (nonatomic, strong) NSNumber <Optional>*style;

/** 消息推送类型 1:群操作 2:评论@ 3:自定义 4:审批 5:文件库 6:同事圈 */
@property (nonatomic, strong) NSNumber <Optional>*type;

/** 审批小助手字段 */
@property (nonatomic, copy) NSString <Optional>*param_fields;

/** 小助手名字 */
@property (nonatomic, strong) NSNumber <Ignore>*assistantName;


@property (nonatomic, copy) NSString <Optional>*icon_url;

@property (nonatomic, copy) NSString <Optional>*icon_color;

@property (nonatomic, copy) NSString <Optional>*icon_type;

@end

