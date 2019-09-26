//
//  TFTaskDynamicModel.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/2/28.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"

@interface TFTaskDynamicModel : JSONModel

/** 动态发布者 */
@property (nonatomic, strong) NSNumber *createrId;
/** 员工名 */
@property (nonatomic, copy) NSString <Optional>*employeeName;
/** 头像 */
@property (nonatomic, copy) NSString <Optional>*photograph;

/** 动态类型 0:聊天 1：语音 2：图片 3：优先级 4：截止日期 5：修改描述 6：添加标签 7：移除标签 */
@property (nonatomic, strong) NSNumber *dynamicType;

/** 动态内容 */
@property (nonatomic, copy) NSString *dynamicContent;

/** 语音地址 */
@property (nonatomic, copy) NSString *voiceUrl;

/** 语音时长 */
@property (nonatomic, assign) NSInteger voiceTime;

/** 图片数组 */
@property (nonatomic, strong) NSArray *images;

/** 动态发布时间 */
@property (nonatomic, strong) NSNumber *creatTime;

@end
