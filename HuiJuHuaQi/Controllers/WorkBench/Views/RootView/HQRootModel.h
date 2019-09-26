//
//  HQRootModel.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 16/6/29.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum FunctionModelType{
    FunctionModelTypeSubscribe = 1,  // 考勤类型
    FunctionModelTypeApproval,       // 审批类型
    FunctionModelTypeTask,           // 任务类型
    FunctionModelTypePrejectPartner, // 项目协同
    FunctionModelTypeSchedule,       // 日程类型
    FunctionModelTypeReport,         // 报告类型
    FunctionModelTypeAdvice,         // 投诉建议类型
    FunctionModelTypeCrm,            // Crm类型
    FunctionModelTypeDocument,       // 收藏类型
    FunctionModelTypeMore,           // 更多功能
    FunctionModelTypeNotice,         // 公告类型
    FunctionModelTypeUrgent,         // 紧急事务类型
    FunctionModelTypeNote,         // 随手记
    FunctionModelTypeFile,         // 文件库
    FunctionModelTypeVote,           // 投票类型
    FunctionModelTypeContact,        // 通讯录
    FunctionModelTypeCircle,         // 企业圈
    FunctionModelTypeCourse,          // 课程
    FunctionModelTypePlane,          // 机票
    FunctionModelTypeVideo,          // 视频
    FunctionModelTypeTrain,          // 火车票
    FunctionModelTypeWeather,          // 天气
    FunctionModelTypeMap,          // 地图
    FunctionModelTypeShopping,         // 购物
    FunctionModelTypePersonnel,         // 人事
    
    /** =========用于审批====== */
    
    FunctionModelTypeAll = 10000, // 全部
    FunctionModelTypeNormal = 10001, // 通用审批
    FunctionModelTypeHoliday,  // 请假
    FunctionModelTypeOverTime, // 加班
    FunctionModelTypeOutWork, // 出差
    FunctionModelTypeOut, // 外出
    FunctionModelTypeSign, // 补签卡
    FunctionModelTypeBack, // 报销
    FunctionModelTypeCancel, // 销假
    FunctionModelTypeWork, // 招聘申请
    FunctionModelTypePeople, // 人事调动
    FunctionModelTypeFoods, // 物品申领
    FunctionModelTypeTaskDeley, // 任务延期
    
    /** 用于销售 */
    FunctionModelTypeSellStart = 20000, // 销售开始
    FunctionModelTypeSellActivity, // 市场活动
    FunctionModelTypeSellCustomer, // 客户
    FunctionModelTypeSellPrice, // 报价
    FunctionModelTypeSellOffer, // 订单
    FunctionModelTypeSellContract, // 合同
    FunctionModelTypeSellMoney, // 回款
    FunctionModelTypeSellBill, // 发票
    FunctionModelTypeSellHighsee, // 公海池
    FunctionModelTypeGoods // 商品
    
    
    
}FunctionModelType;

@interface HQRootModel : NSObject<NSCoding>
/** 模块名字 */
@property (nonatomic , strong) NSString *name;
/** 模块图标 */
@property (nonatomic , strong) NSString *image;
/** 图标数量 */
@property (nonatomic , assign) NSInteger markNum;
/** 是否有逾期事务 */
@property (nonatomic , assign) BOOL OutDate;
/** 用于标记背景颜色 */
@property (nonatomic , assign) BOOL backColor;
/** 用于标记按钮显示 */
@property (nonatomic , assign) BOOL deleteShow;
/** 模块功能类型 */
@property (nonatomic , assign) FunctionModelType functionModelType;
/** 模块id */
@property (nonatomic , strong) NSNumber *modelId;

@end
