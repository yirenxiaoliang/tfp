//
//  TFStatisticsListCell.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/3/5.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseCell.h"
#import "TFStatisticsItemModel.h"
@interface TFStatisticsListCell : HQBaseCell

@property (weak, nonatomic) IBOutlet UIImageView *enterImage;
+ (instancetype)statisticsCellWithTableView:(UITableView *)tableView;

- (void)refreshStatisticsCellWithModel:(TFStatisticsItemModel *)model;
/** type 0:三行 1：一行 */
@property (nonatomic, assign) NSInteger type;


@end
