//
//  TFPutchCardModel.h
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/3/8.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"
#import "TFAtdClassModel.h"
#import "TFAtdWatDataListModel.h"
#import "TFPutchRecordModel.h"
#import "TFRelationModuleModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TFPutchCardModel : JSONModel

/** 考勤组ID */
@property (nonatomic, strong) NSNumber <Optional>*id;
/** 考勤组名字 */
@property (nonatomic, copy) NSString <Optional>*name;
/** 考勤类型 0:固定班次 1:排班制 2:自由打卡 */
@property (nonatomic, copy) NSString <Optional>*attendance_type;
/** 考勤开始 */
@property (nonatomic, copy) NSString <Optional>*attendance_start_time;
/** 班次信息 */
@property (nonatomic, strong) TFAtdClassModel <Optional>*class_info;
/** 考勤地址 */
@property (nonatomic, strong) NSArray <TFAtdWatDataListModel,Optional>*attendance_address;
/** 考勤WiFi */
@property (nonatomic, strong) NSArray <TFAtdWatDataListModel,Optional>*attendance_wifi;
/** 能否外勤考勤 */
@property (nonatomic, copy) NSString <Optional>*outworker_status;
/** 能否人脸考勤 */
@property (nonatomic, copy) NSString <Optional>*face_status;
/** 后端记录考勤记录 */
@property (nonatomic, strong) NSArray <TFPutchRecordModel,Optional>*clock_record_list;
/** 显示记录列表 */
@property (nonatomic, strong) NSMutableArray <TFPutchRecordModel,Optional>*record_list;

/** 关联列表 */
@property (nonatomic, strong) NSMutableArray <TFRelationModuleModel,Optional>*relation_module;

@end

NS_ASSUME_NONNULL_END
