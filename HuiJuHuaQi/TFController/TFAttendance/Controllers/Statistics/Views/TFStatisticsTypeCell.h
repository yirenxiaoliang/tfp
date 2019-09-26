//
//  TFStatisticsTypeCell.h
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/3/26.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseCell.h"
#import "TFDimensionModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TFStatisticsTypeCell : HQBaseCell

+(instancetype)statisticsTypeCellWithTableView:(UITableView *)tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timeW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headW;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

/** 刷新数据
 *  model : 数据
 *  index ： 0,日统计；1,月统计；2,我的统计
 *  type ： 统计维度类型,0：打卡人数，1：迟到，2：早退，3：缺卡,4:旷工，5：外勤打卡，6：关联审批
 *  row :  行数
 */
-(void)refreshStatisticsTypeCellWithModel:(TFDimensionModel *)model index:(NSInteger)index type:(NSInteger)type row:(NSInteger)row;

@end

NS_ASSUME_NONNULL_END
