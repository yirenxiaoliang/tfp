//
//  TFDataListModel.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/3/26.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"
#import "TFNoteCreaterModel.h"

@protocol TFNoteDataListModel @end

@interface TFNoteDataListModel : JSONModel

//{
//    "share_ids": "null",
//    "create_time": 1522035491113,
//    "remind_status": "0",
//    "modify_time": "",
//    "del_status": "0",
//    "modify_by": "",
//    "title": "我鼓风机房刷卡缴费开发的管理地方",
//    "create_by": 1,
//    "items_arr": "",
//    "remind_time": 0,
//    "id": 3,
//    "pic_url": ""
//},

@property (nonatomic, copy) NSString <Optional>*share_ids;

@property (nonatomic, strong) NSNumber <Optional>*create_time;

@property (nonatomic, copy) NSString <Optional>*remind_status;

@property (nonatomic, copy) NSString <Optional>*modify_time;

@property (nonatomic, copy) NSString <Optional>*del_status;

@property (nonatomic, copy) NSString <Optional>*modify_by;

@property (nonatomic, copy) NSString <Optional>*title;

@property (nonatomic, strong) NSNumber <Optional>*create_by;

@property (nonatomic, strong) NSArray <Optional>*items_arr;

@property (nonatomic, strong) NSNumber <Optional>*remind_time;

@property (nonatomic, strong) NSNumber <Optional>*id;

@property (nonatomic, copy) NSString <Optional>*pic_url;

@property (nonatomic, strong) TFNoteCreaterModel <Optional>*createObj;

@property (nonatomic, strong) NSNumber <Ignore>*index;
/** 0:未选中 1:选中 */
@property (nonatomic, strong) NSNumber <Ignore>*isEdit;

/** 0:未选中 1:选中 */
@property (nonatomic, strong) NSNumber <Ignore>*isSelect;

@end
