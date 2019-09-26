//
//  TFMutilStyleSelectPeopleController.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/1/5.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "YPTabBarController.h"

@interface TFMutilStyleSelectPeopleController : YPTabBarController

/** actionParameter */
@property (nonatomic, copy) ActionParameter actionParameter;

/** selectType 选择样式 0:默认为四种 1：选择联系人 2：部门 3：角色 4：动态参数 */
@property (nonatomic, assign) NSInteger selectType;

/** isSingleSelect 是否单选 NO:默认为多选 YES:单选  */
@property (nonatomic, assign) BOOL isSingleSelect;

/** 默认选中人员 */
@property (nonatomic, strong) NSArray *defaultPoeples;

/** 不可选中人员 */
@property (nonatomic, strong) NSArray *noSelectPoeples;

@property (nonatomic, strong) NSNumber *dismiss;

@property (nonatomic, copy) NSString *bean;

/** 取消 */
@property (nonatomic, copy) ActionHandler cancelAction;

@end
