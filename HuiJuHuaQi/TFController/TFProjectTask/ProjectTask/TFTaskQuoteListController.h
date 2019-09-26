//
//  TFTaskQuoteListController.h
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/5/27.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface TFTaskQuoteListController : HQBaseViewController

/** 数据 */
@property (nonatomic, strong) NSMutableArray *relations;
/**  0：引用 1：被引用 */
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) BOOL quoteAuth;
@property (nonatomic, assign) BOOL cancelAuth;
@property (nonatomic, strong) NSNumber *projectId;
@property (nonatomic, strong) NSNumber *dataId;
@property (nonatomic, copy) NSString *project_status;
@property (nonatomic, strong) NSDictionary *detailDict;
@property (nonatomic, assign) NSInteger taskType;

@property (nonatomic, copy) ActionHandler refresh;
@end

NS_ASSUME_NONNULL_END
