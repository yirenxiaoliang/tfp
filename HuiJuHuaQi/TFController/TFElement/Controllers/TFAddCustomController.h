//
//  TFAddCustomController.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/11/29.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseViewController.h"
#import "TFRelevanceFieldModel.h"
#import "HQEmployModel.h"

@interface TFAddCustomController : HQBaseViewController

/** type 0:新增 1:详情 2：编辑 3：复制 7：重新编辑(含：发起人撤销、驳回到发起人)  */
@property (nonatomic, assign) NSInteger type;

/** bean */
@property (nonatomic, copy) NSString *bean;
/** taskKey */
@property (nonatomic, copy) NSString *taskKey;
/** isSeasPool 是否为公海池 0：非 1：是 */
@property (nonatomic, copy) NSString *isSeasPool;

/**是否为公海池管理员 */
@property (nonatomic, copy) NSString *isSeasAdmin;
/** 公海池id */
@property (nonatomic, strong) NSNumber *seaPoolId;
/** processFieldV */
@property (nonatomic, strong) NSNumber *processFieldV;
/** 模块Id */
@property (nonatomic, strong) NSNumber *moduleId;

/** id */
@property (nonatomic, strong) NSNumber *dataId;

/** height */
@property (nonatomic, assign) CGFloat tableViewHeight;

/** 刷新 */
@property (nonatomic, copy) ActionHandler refreshAction;

/** 导航栏透明 */
@property (nonatomic, assign) BOOL translucent;


/** 关联数组 */
@property (nonatomic, strong) NSArray <TFRelevanceFieldModel *>*relevances;

/** HQEmployModel *emp */
@property (nonatomic, strong) HQEmployModel *employ;

/** 用于父控制器刷新 */
@property (nonatomic, copy) ActionHandler fatherRefresh;

/** 邮箱回调 */
@property (nonatomic, copy) ActionParameter emailBlock;

/** 详情回调 */
@property (nonatomic, copy) ActionParameter detailBlock;

/** taskBlock回调 */
@property (nonatomic, copy) ActionParameter taskBlock;

/** customBlock回调 */
@property (nonatomic, copy) ActionParameter customBlock;

/** 评论、动态、邮件 */
@property (nonatomic, copy) ActionParameter commentBlock;

/** 高度变化 */
@property (nonatomic, copy) ActionParameter heightBlock;

/** 布局 */
@property (nonatomic, copy) ActionParameter layoutBlock;

/** lastDetailDict */
@property (nonatomic, strong) NSDictionary *lastDetailDict;
/** relevanceKey */
@property (nonatomic, copy) NSString *relevanceKey;

/** isChild */
@property (nonatomic, assign) BOOL isChild;

/** sorceBean */
@property (nonatomic, copy) NSString *sorceBean;
/** targetBean */
@property (nonatomic, copy) NSString *targetBean;

/** 是否为审批 */
@property (nonatomic, assign) BOOL isApproval;

@end
