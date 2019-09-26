//
//  TFAttendanceMonthCell.h
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/3/14.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFPunchCardInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TFAttendanceMonthCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *bottomLine;
@property (weak, nonatomic) IBOutlet UILabel *topLine;
-(void)refreshAttendanceMonthCellWithModel:(TFPunchCardInfoModel *)model;
+(instancetype)attendanceMonthCellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
