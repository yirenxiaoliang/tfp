//
//  TFProjectShareInfoModel.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/4/17.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"

@protocol TFProjectShareInfoModel @end

@interface TFProjectShareInfoModel : JSONModel

//}

//{
//    "id" : 3,
//    "share_content" : "在线教育部门在全国范围开展",
//    "create_by" : 1,
//    "submit_status" : "0",
//    "share_ids" : "2",
//    "share_top_status" : "0",
//    "del_status" : "0",
//    "share_status" : "0",
//    "modify_by" : "",
//    "share_title" : "陈宇亮分享001",
//    "share_top_time" : "",
//    "project_id" : 11,
//    "create_time" : 1524712601928,
//    "modify_time" : "",
//    "share_relevance_arr" : ""
//}

@property (nonatomic, strong) NSNumber <Optional>*id;

@property (nonatomic, copy) NSString <Optional>*share_content;

@property (nonatomic, strong) NSNumber <Optional>*create_by;

@property (nonatomic, copy) NSString <Optional>*submit_status;

@property (nonatomic, copy) NSString <Optional>*share_ids;

@property (nonatomic, copy) NSString <Optional>*employee_pic;

@property (nonatomic, copy) NSString <Optional>*employee_name;

@property (nonatomic, copy) NSString <Optional>*share_top_status;

@property (nonatomic, copy) NSString <Optional>*top_status;

@property (nonatomic, copy) NSString <Optional>*del_status;

@property (nonatomic, copy) NSString <Optional>*share_status;

@property (nonatomic, copy) NSString <Optional>*modify_by;

@property (nonatomic, copy) NSString <Optional>*share_title;

@property (nonatomic, copy) NSString <Optional>*share_top_time;

@property (nonatomic, strong) NSNumber <Optional>*project_id;

@property (nonatomic, strong) NSNumber <Optional>*create_time;

@property (nonatomic, strong) NSNumber <Optional>*modify_time;

@property (nonatomic, copy) NSString <Optional>*share_relevance_arr;

/** 点赞状态 */
@property (nonatomic, strong) NSNumber <Optional>*share_praise_status;

/** 点赞数量 */
@property (nonatomic, strong) NSNumber <Optional>*share_praise_number;


//"create_obj":[]                            //创建人
//"share_obj":[]                             //分享人
//"praise_obj":[]                            //点赞人
@property (nonatomic, strong) NSArray <HQEmployModel,Optional>*share_obj;

@property (nonatomic, strong) NSArray <HQEmployModel,Optional>*praise_obj;

@end
