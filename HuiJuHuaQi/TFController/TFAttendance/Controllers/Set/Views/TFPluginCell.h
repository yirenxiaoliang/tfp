//
//  TFPluginCell.h
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/7/3.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseCell.h"
#import "TFPluginModel.h"


NS_ASSUME_NONNULL_BEGIN

@protocol TFPluginCellDelegate <NSObject>

@optional
-(void)pluginCellDidClickedSwitchBtn:(UISwitch *)switchBtn model:(TFPluginModel *)model;

@end

@interface TFPluginCell : HQBaseCell


@property (nonatomic, weak) id <TFPluginCellDelegate>delegate;

+(instancetype)pluginCellWithTableView:(UITableView *)tableView;

-(void)refreshPluginCellWithModel:(TFPluginModel *)model;

@end

NS_ASSUME_NONNULL_END
