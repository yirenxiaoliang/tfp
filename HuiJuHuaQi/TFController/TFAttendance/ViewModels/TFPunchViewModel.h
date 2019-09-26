//
//  TFPunchViewModel.h
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/3/5.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFPutchCardModel.h"
#import "TFLocationModel.h"


NS_ASSUME_NONNULL_BEGIN

@interface TFPunchViewModel : NSObject

/** 考勤组信息 */
@property (nonatomic, strong,nullable) TFPutchCardModel *cardModel;

/** 急速打卡请求 */
@property (nonatomic, strong) RACCommand *quickCommand;

/** 开启插件请求 */
@property (nonatomic, strong) RACCommand *pluginCommand;

/** 数据请求 */
@property (nonatomic, strong) RACCommand *dataCommand;

/** 当前需要进行的打卡数据 */
@property (nonatomic, strong) TFPutchRecordModel *currentRecord;

/** 当前的位置信息 */
@property (nonatomic, strong, nullable)  TFLocationModel *location;

/** 打卡 */
@property (nonatomic, strong) RACCommand *punchCommand;

@property (nonatomic, strong) RACSignal *refreshSignal;
/** 总的流程正常状态 0：正常 ，1：不正常 */
@property (nonatomic, assign) NSInteger tatol_status;

/** 判断打卡位置正常？ */
-(BOOL)judgeLocationIsTure;

double getDistance(double lat1, double lng1, double lat2,
                   double lng2);
@end

NS_ASSUME_NONNULL_END
