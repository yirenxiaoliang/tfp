//
//  TFAssistantListController.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2017/12/15.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseViewController.h"

@interface TFAssistantListController : HQBaseViewController

@property (nonatomic, copy) NSString *naviTitle;

//助手id
@property (nonatomic, strong) NSNumber *assistantId;

//应用id
@property (nonatomic, strong) NSNumber *applicationId;

//模块名
@property (nonatomic, copy) NSString *beanName;

/** 助手类型 1:应用小助手 2:企信小助手 3:审批小助手 4:文件库小助手 */
@property (nonatomic, assign) NSInteger type;

@property (nonatomic, strong) NSNumber *timeSp;

@property (nonatomic, copy) NSString *showType;

@property (nonatomic, copy) NSString *icon_url;
@property (nonatomic, copy) NSString *icon_color;
@property (nonatomic, copy) NSString *icon_type;

@property (nonatomic, copy) ActionHandler refresh;

@end
