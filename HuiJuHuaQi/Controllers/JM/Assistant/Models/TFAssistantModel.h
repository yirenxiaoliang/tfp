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

@protocol TFAssistantModel
@end

@interface TFAssistantModel : HQBaseVoModel

/** 助手类型 根据类型确定头像、名字 */
@property (nonatomic, strong) NSNumber <Optional>*itemId;
/** ？*/
@property (nonatomic, strong) NSNumber <Optional>*itemType;
/** 助手名字 */
@property (nonatomic, copy) NSString <Optional>*name;

/** associateModuleId */
@property (nonatomic, strong) NSNumber <Optional>*associateModuleId;

/** 描述 */
@property (nonatomic, copy) NSString <Optional>*msgDesc;
/** 描述 */
@property (nonatomic, copy) NSString <Optional>*msgBody;

/** 内容 */
@property (nonatomic, copy) NSString <Optional>*sendContent;
/** 紧急度 0：普通 1：紧急 2：非常紧急 */
@property (nonatomic, strong) NSNumber <Optional>*priority;
/** 已读 */
@property (nonatomic, strong) NSNumber <Optional>*isRead;
/** 镖旗 */
//@property (nonatomic, strong) NSNumber <Optional>*isFlag;
/** 镖旗 */
@property (nonatomic, strong) NSNumber <Optional>*isHandle;
/** 开始时间 */
@property (nonatomic, strong) NSNumber <Optional>*startTime;
/** 结束时间 */
@property (nonatomic, strong) NSNumber <Optional>*endTime;

/** 业务创建人id */
@property (nonatomic, strong) NSNumber <Optional>*createrId;
/** 业务创建人Name */
@property (nonatomic, copy) NSString <Optional>*createrName;

/** 发送人id */
@property (nonatomic, strong) NSNumber <Optional>*senderId;
/** 发送人Name */
@property (nonatomic, copy) NSString <Optional>*senderName;

/** 发送人id */
@property (nonatomic, strong) NSNumber <Optional>*receiverId;
/** 发送人Name */
@property (nonatomic, copy) NSString <Optional>*receiverName;

/** 评论 */
@property (nonatomic, copy) NSString <Optional>*comment;

/** 用于工作汇报 0:计划 1：日报或周报 */
@property (nonatomic, strong) NSNumber <Optional>*type;
/** 用于文件库 */
@property (nonatomic, copy) NSString <Optional>*fileSrc;


@end
