//
//  HQSelectLeaveCell.h
//  HuiJuHuaQi
//
//  Created by XieLB on 16/4/13.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseTableViewCell.h"

@interface HQSelectLeaveCell : HQBaseTableViewCell


@property (strong, nonatomic) IBOutlet UILabel *titleLabel;


@property (strong, nonatomic) IBOutlet UIImageView *selectImg;


+ (HQSelectLeaveCell *)selectLeaveCellWithTableView:(UITableView *)tableView;


@end
