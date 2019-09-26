//
//  TFStatisticsPeoplesCell.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/6/5.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseCell.h"

@interface TFStatisticsPeoplesCell : HQBaseCell

@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIButton *enterBtn;

@property (weak, nonatomic) IBOutlet UILabel *memberLab;

+ (instancetype)statisticsPeoplesWithTableView:(UITableView *)tableView;

@end
