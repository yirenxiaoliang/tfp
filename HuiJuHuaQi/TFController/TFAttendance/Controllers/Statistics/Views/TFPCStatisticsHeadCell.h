//
//  TFPCStatisticsHeadCell.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/6/19.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseCell.h"

@protocol TFPCStatisticsHeadCellDelegate <NSObject>

@optional
-(void)statisticsHeadCellDidSelectDate;
-(void)statisticsHeadCellDidSelectCalendar;

@end

@interface TFPCStatisticsHeadCell : HQBaseCell

@property (nonatomic, weak) id <TFPCStatisticsHeadCellDelegate>delegate;

@property (weak, nonatomic) IBOutlet UIButton *calendarBtn;

@property (weak, nonatomic) IBOutlet UILabel *lable;

+ (instancetype)PCStatisticsHeadCellWithTableView:(UITableView *)tableView;
@end
