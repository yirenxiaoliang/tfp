//
//  TFAssistantTypeModel.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/6/5.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"
#import "HQBaseVoModel.h"

@interface TFAssistantTypeModel : HQBaseVoModel

/** 用户名 */
@property (nonatomic, copy) NSString <Optional>*imUserName;
/** 助手名 */
@property (nonatomic, copy) NSString <Optional>*assistName;
/** 未读数 */
@property (nonatomic, strong) NSNumber <Optional>*unreadCount;
/** 助手id 110:任务助手，111:日程助手，112:随手记助手，113:文件库助手，114:审批助手，115:公告助手，116:投诉建议助手，117:工作汇报助手*/
@property (nonatomic, strong) NSNumber <Optional>*assistId;
/** 置顶 null or 0 为 NO ，1 为 YES */
@property (nonatomic, strong) NSNumber <Optional>*top;


@end
