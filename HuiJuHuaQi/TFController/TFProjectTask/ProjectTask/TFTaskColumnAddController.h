//
//  TFTaskColumnAddController.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/4/14.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseViewController.h"
#import "TFProjectRowModel.h"
#import "TFProjectColumnModel.h"

@interface TFTaskColumnAddController : HQBaseViewController

/** projectColumnModel */
@property (nonatomic, strong) TFProjectColumnModel *projectColumnModel;
/** projectId */
@property (nonatomic, strong) NSNumber *projectId;
/** sectionId */
@property (nonatomic, strong) NSNumber *sectionId;

/** index 0:分组 1:任务列 */
@property (nonatomic, assign) NSInteger index;

/** type 0:新增 1:修改 */
@property (nonatomic, assign) NSInteger type;

/** TFProjectRowModel */
@property (nonatomic, strong) TFProjectRowModel *projectRow;

/** refresh */
@property (nonatomic, copy) ActionParameter refresh;

@end
