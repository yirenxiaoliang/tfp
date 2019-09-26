//
//  TFSelectTaskRowController.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/8/29.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseViewController.h"
#import "TFProjectSectionModel.h"

@interface TFSelectTaskRowController : HQBaseViewController

/** datas */
@property (nonatomic, strong) NSArray *datas;

/** parameter */
@property (nonatomic, copy) ActionParameter parameter;

/** selectModel */
@property (nonatomic, strong) TFProjectSectionModel *selectModel;

/** type 0:选择分组 1:选择列 2:选择子列 */
@property (nonatomic, assign) NSInteger type;


@end
