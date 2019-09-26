//
//  TFTwoLableCell.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/6/8.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseCell.h"
#import "TFDimensionModel.h"

@interface TFTwoLableCell : HQBaseCell

@property (weak, nonatomic) IBOutlet UILabel *oneLab;
@property (weak, nonatomic) IBOutlet UILabel *twoLab;

+ (instancetype)TwoLableCellWithTableView:(UITableView *)tableView;
/** index 0:日统计，1：月统计，2：我的
      type 0：打卡人数，1：迟到，2：早退，3：缺卡,4:旷工，5：外勤打卡，6：关联审批
 */
-(void)refreshCellWithIndex:(NSInteger)index type:(NSInteger)type model:(TFDimensionModel *)model;
@end
