//
//  TFAtdSingleLableCell.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/7/30.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseCell.h"

@interface TFAtdSingleLableCell : HQBaseCell
@property (weak, nonatomic) IBOutlet UILabel *singleLab;
+ (instancetype)atdSingleLableCellWithTableView:(UITableView *)tableView;
@end
