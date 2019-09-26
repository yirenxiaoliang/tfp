//
//  TFPunchCardInfoModel.h
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/3/14.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol TFPunchCardInfoModel <NSObject>

@end

@interface TFPunchCardInfoModel : JSONModel
/**
 "punchcardState":4,
 "punchcardType":1,
 "isWay":"0",
 "isOutworker":"1",
 "isWayInfo":"广东省深圳市南山区科技南四路与高新南一道交叉口西100米",
 "expectPunchcardTime":1552266000000,
 "realPunchcardTime":1552296791478
 */
/** 打卡状态（1迟到, 2早退, 3缺卡, 4旷工, 5外勤打卡, 6关联审批, 7正常, 8未到打卡时间） */
@property (nonatomic, strong) NSNumber <Optional>*punchcardState;
/** 打卡类型（1:上班卡,2:下班卡） */
@property (nonatomic, strong) NSNumber <Optional>*punchcardType;
/**     打卡方式（0:地址,1:wifi） */
@property (nonatomic, copy) NSString <Optional>*isWay;
/** 是否外勤打卡（0:是,1:不是） */
@property (nonatomic, copy) NSString <Optional>*isOutworker;
/** 打卡地址/wifi名称 */
@property (nonatomic, copy) NSString <Optional>*isWayInfo;
/** 期望打卡时间 */
@property (nonatomic, strong) NSNumber <Optional>*expectPunchcardTime;
/** 实际打卡时间 */
@property (nonatomic, strong) NSNumber <Optional>*realPunchcardTime;


@end

NS_ASSUME_NONNULL_END
