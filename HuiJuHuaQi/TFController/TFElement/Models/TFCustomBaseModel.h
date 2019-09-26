//
//  TFCustomBaseModel.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/8/22.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"
#import "TFCustomerLayoutModel.h"
#import "HQEmployModel.h"

@interface TFCustomBaseModel : JSONModel

/** 模块中文名称 */
@property (nonatomic, copy) NSString <Optional>*title;
/** 审批ID */
@property (nonatomic, copy) NSString <Optional>*processId;

/** 模块英文名称 */
@property (nonatomic, copy) NSString <Optional>*bean;

/** 模块版本 */
@property (nonatomic, copy) NSString <Optional>*version;

/** 模块图标 */
@property (nonatomic, copy) NSString <Optional>*icon;

/** 布局信息 */
@property (nonatomic, strong) NSArray <TFCustomerLayoutModel,Optional>*layout;

/** 布局信息（任务布局） */
@property (nonatomic, strong) TFCustomerLayoutModel <Optional>*enableLayout;

/** APP终端 */
@property (nonatomic, copy) NSString <Optional>*terminalApp;

/** 模块页码 */
@property (nonatomic, copy) NSString <Optional>*pageNum;

/** 详情评论控件 */
@property (nonatomic, copy) NSString <Optional>*commentControl;

/** 公司id */
@property (nonatomic, copy) NSString <Optional>*companyId;

/** PC终端 */
@property (nonatomic, copy) NSString <Optional>*terminalPc;

/** 详情动态控件 */
@property (nonatomic, copy) NSString <Optional>*dynamicControl;

/** 布局状态 */
@property (nonatomic, copy) NSString <Optional>*layoutState;

/** 应用id */
@property (nonatomic, copy) NSString <Optional>*applicationId;


@end
