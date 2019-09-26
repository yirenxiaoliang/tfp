//
//  TFPCPeoplesCell.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/6/7.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseCell.h"
#import "TFRankPeopleModel.h"

@interface TFPCPeoplesCell : HQBaseCell

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *statusBtnW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *statusBtnH;

@property (weak, nonatomic) IBOutlet UIButton *statusBtn;
@property (weak, nonatomic) IBOutlet UILabel *memberLab;
@property (weak, nonatomic) IBOutlet UILabel *positionLab;

/** 打卡人员 */
- (void)configPCPeoplesCellWithModel:(TFEmployModel *)model;

//配置排行榜数据
- (void)configStatisticsChartsCellWithModel:(TFRankPeopleModel *)model index:(NSInteger)index;

//配置排班详情数据
- (void)configClassesDetailCellWithData:(HQEmployModel *)model;

+ (instancetype)PCPeoplesCellWithTableView:(UITableView *)tableView;

@end
