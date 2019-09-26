//
//  TFChildTaskListController.h
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/5/27.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface TFChildTaskListController : HQBaseViewController
@property (nonatomic, copy) NSString *project_status;
@property (nonatomic, strong) NSDictionary *detailDict;
@property (nonatomic, assign) NSInteger taskType;
@property (nonatomic, assign) BOOL auth;
@property (nonatomic, copy) NSString *nodeCode;
@property (nonatomic, copy) ActionHandler refresh;
@property (nonatomic, strong) NSNumber *projectId;
@property (nonatomic, strong) NSNumber *dataId;
@property (nonatomic, strong) NSMutableArray *tasks;
@end

NS_ASSUME_NONNULL_END
