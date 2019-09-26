//
//  TFAttendanceCalendarCell.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/6/19.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseCell.h"

@protocol TFAttendanceCalendarCellDelegate <NSObject>

@optional
- (void)selectDateWithItem:(NSInteger)item;

@end

@interface TFAttendanceCalendarCell : HQBaseCell

- (void)configAttendanceCalendarCellWithTableView:(NSDate *)date;

+ (instancetype)attendanceCalendarCellWithTableView:(UITableView *)tableView;

@property (nonatomic, weak) id <TFAttendanceCalendarCellDelegate>delegate;

@end
