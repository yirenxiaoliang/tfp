//
//  HQBenchTimeCell.h
//  HuiJuHuaQi
//
//  Created by XieLB on 16/9/2.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseTableViewCell.h"


@protocol HQBenchTimeCellDelegate <NSObject>

/**
 *  选择的某个日期
 *
 *  @param selectTimeSp 选择的时间戳
 */
- (void)selectTimeSpWithTimeCellDelegate:(long long)selectTimeSp;

@end


@interface HQBenchTimeCell : HQBaseTableViewCell


@property (assign, nonatomic) id <HQBenchTimeCellDelegate> delegate;


+ (instancetype)benchTimeCellWithTableView:(UITableView *)tableView;


- (void)refreshBenchTimeCellWithSelectTimeSp:(long long)selectTimeSp;



@end




