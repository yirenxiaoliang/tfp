//
//  TFPCMonthItemController.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/6/8.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseViewController.h"

@interface TFPCMonthItemController : HQBaseViewController

/** 标题 */
@property (nonatomic, copy) NSString *naviTitle;
/** 统计维度类型,0：打卡人数，1：迟到，2：早退，3：缺卡,4:旷工，5：外勤打卡，6：关联审批 */
@property (nonatomic, assign) NSInteger type;
/** 时间戳 */
@property (nonatomic, assign) long long date;
/** 人员数据 */
@property (nonatomic, strong) NSArray *peoples;
/** 0:日统计， 1：月统计， 2：我的 */
@property (nonatomic, assign) NSInteger index;

@end
