//
//  TFApplicationModel.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/12/8.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"
#import "TFModuleModel.h"

@protocol TFApplicationModel

@end

@interface TFApplicationModel : JSONModel

/**
 "create_by":"11",
 "company_id":36,
 "create_time":1512610618576,
 "modify_time":1512610661043,
 "name":"OA",
 "topper":1,
 "del_status":"0",
 "id":11,
 "modify_by":"11",
 "modules":Array[3] */

/** icon */
@property (nonatomic, copy) NSString <Optional>*icon;
/** create_by */
@property (nonatomic, copy) NSString <Optional>*create_by;
/** company_id */
@property (nonatomic, strong) NSNumber <Optional>*company_id;
/** create_time */
@property (nonatomic, strong) NSNumber <Optional>*create_time;
/** modify_time */
@property (nonatomic, strong) NSNumber <Optional>*modify_time;
/** topper */
@property (nonatomic, strong) NSNumber <Optional>*topper;
/** name */
@property (nonatomic, copy) NSString <Optional>*name;
/** del_status */
@property (nonatomic, copy) NSString <Optional>*del_status;
/** modify_by */
@property (nonatomic, copy) NSString <Optional>*modify_by;


/** modules */
@property (nonatomic, strong) NSMutableArray <Optional,TFModuleModel>*modules;
/** name */
@property (nonatomic, copy) NSString <Optional>*chinese_name;
/** id */
@property (nonatomic, strong) NSNumber <Optional>*id;
/** icon_color */
@property (nonatomic, copy) NSString <Optional>*icon_color;
/** icon_url */
@property (nonatomic, copy) NSString <Optional>*icon_url;
/** icon_url */
@property (nonatomic, copy) NSString <Optional>*icon_type;






@end
