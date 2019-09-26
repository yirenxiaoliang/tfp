//
//  TFStatisticsCell.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/8/30.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseCell.h"

@interface TFStatisticsCell : HQBaseCell

+ (TFStatisticsCell *)statisticsCellWithTableView:(UITableView *)tableView;

/** 刷新cell 
 @prama type 统计图形类型
        0：饼状图
        1：条形图
        2：柱状图
        3：曲线图
        4：折线图
        5：漏斗图
        6：仪表表
  */
- (void)refreshStatisticsCellWithType:(NSInteger)type;

@end
