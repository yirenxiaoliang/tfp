//
//  TFPutchRecordModel.h
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/3/8.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol TFPutchRecordModel

@end

@interface TFPutchRecordModel : JSONModel
/**
 "id":3,
 "expect_punchcard_time":"12346",
 "real_punchcard_time":"12346",
 "punchcard_type":"1",
 "punchcard_result":"1",
 "punchcard_status":"1",
 "punchcard_address":"1",
 "is_outworker":"1",
 "is_way":"1"
 */
/** 记录ID */
@property (nonatomic, strong) NSNumber<Optional> *id;
/** 期望打卡时间 */
@property (nonatomic, copy) NSString<Optional> *expect_punchcard_time;
/** 实际打卡时间 */
@property (nonatomic, copy) NSString<Optional> *real_punchcard_time;
/** 打卡类型1:上班卡，2:下班卡 */
@property (nonatomic, copy) NSString<Optional> *punchcard_type;
/** 打卡的key */
@property (nonatomic, copy) NSString<Optional> *punchcard_key;
/** 打卡结果 */
@property (nonatomic, copy) NSString<Optional> *punchcard_result;
/** 打卡状态，0:未打卡,1:正常,2:迟到,3:早退,4:旷工,5:缺卡 */
@property (nonatomic, copy) NSString<Optional> *punchcard_status;
/** 打卡地址 */
@property (nonatomic, copy) NSString<Optional> *punchcard_address;
/** 打卡地址name */
@property (nonatomic, copy) NSString<Optional> *punchcard_name;
/** 是否外勤打卡（0 是 1 不是） */
@property (nonatomic, copy) NSString<Optional> *is_outworker;
/** 打卡方式(0 地址 1 wifi) */
@property (nonatomic, copy) NSString<Optional> *is_way;
/** 记录index（第几次打卡） */
@property (nonatomic, copy) NSString<Ignore> *recordIndex;
/** 能否打卡 0：不能打 ，1：打地址，2：打WiFi ，3：打外勤 */
@property (nonatomic, copy) NSString<Ignore> *isPunch;
/** 记录已打卡 */
@property (nonatomic, copy) NSString<Ignore> *finish;
/** 记录可更新 0：不可， 1：可 */
@property (nonatomic, copy) NSString<Ignore> *change;
/** 是否为自由打卡 */
@property (nonatomic, copy) NSString<Ignore> *freedom;
/** 考勤类型 0:固定班次 1:排班制 2:自由打卡 */
@property (nonatomic, copy) NSString <Optional>*attendance_type;

/** ******************************班次信息*************************** */

@property (nonatomic, copy) NSString <Optional>*timeLimit;

/** 用于审批申请和详情 */
/** bean */
@property (nonatomic, copy) NSString <Optional>*bean_name;
/** data_id */
@property (nonatomic, copy) NSString <Optional>*data_id;
/** module_id */
@property (nonatomic, copy) NSString <Optional>*module_id;
/** 外勤照片 */
@property (nonatomic, copy) NSString <Optional>*photo;
/** 外勤备注 */
@property (nonatomic, copy) NSString <Optional>*remark;

@end

NS_ASSUME_NONNULL_END
