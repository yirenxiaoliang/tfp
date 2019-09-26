//
//  TFModelEnterController.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/5/4.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseViewController.h"

@interface TFModelEnterController : HQBaseViewController

/** type 0:管理 1:跳转 2:审批 3:引用 4:加号 5:新建 6:知识库引用 7:备忘录引用 */
@property (nonatomic, assign) NSInteger type;

/** selectApp  1:引用审批 2:新建审批 */
@property (nonatomic, assign) NSInteger selectApp;


/** parameterAction */
@property (nonatomic, copy) ActionParameter parameterAction;

/** memoAction */
@property (nonatomic, copy) ActionParameter memoAction;


/** projectId */
@property (nonatomic, strong) NSNumber *projectId;
/** rowId */
@property (nonatomic, strong) NSNumber *rowId;
/** taskId */
@property (nonatomic, strong) NSNumber *taskId;
/** 是否有常用应用 */
@property (nonatomic, assign) BOOL openOften;
/** 是否有banner */
@property (nonatomic, assign) BOOL hasBanner;
/** 高度变化 */
@property (nonatomic, copy) ActionParameter heightBlock;

/** 用于子控制器时的刷新数据 */
-(void)refreshModuleData;

@end
