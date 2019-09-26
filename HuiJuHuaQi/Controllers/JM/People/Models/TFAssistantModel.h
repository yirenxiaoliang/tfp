//
//  TFAssistantModel.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/4/26.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"
#import "HQBaseVoModel.h"
#import "HQEmployModel.h"

@interface TFAssistantModel : HQBaseVoModel

/** 助手类型 根据类型确定头像、名字 */
@property (nonatomic, strong) NSNumber <Optional>*assitantType;
/** 描述 */
@property (nonatomic, copy) NSString <Optional>*desc;
/** 内容 */
@property (nonatomic, copy) NSString <Optional>*content;
/** 紧急度 0：普通 1：紧急 2：非常紧急 */
@property (nonatomic, strong) NSNumber <Optional>*priority;
/** 已读 */
@property (nonatomic, strong) NSNumber <Optional>*isRead;
/** 镖旗 */
@property (nonatomic, strong) NSNumber <Optional>*isFlag;
/** 开始时间 */
@property (nonatomic, strong) NSNumber <Optional>*startTime;
/** 结束时间 */
@property (nonatomic, strong) NSNumber <Optional>*endTime;
/** 创建人/负责人 */
@property (nonatomic, strong) HQEmployModel <Optional>*people;
/** 评论 */
@property (nonatomic, copy) NSString <Optional>*comment;


@end
