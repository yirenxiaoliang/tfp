//
//  HQSwitchCell.h
//  HuiJuHuaQi
//
//  Created by hq002 on 16/4/7.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseCell.h"
#import "TFAssistantSettingModel.h"

@protocol HQSwitchCellDelegate <NSObject>

@optional
- (void)switchCellDidSwitchButton:(UISwitch *)switchButton;
@end

@interface HQSwitchCell : HQBaseCell
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UISwitch *switchBtn;
+ (instancetype)switchCellWithTableView:(UITableView *)tableView;
@property (nonatomic , weak)id<HQSwitchCellDelegate> delegate;

/** 刷新助手设置 */
-(void)refreshAssistantSettingWithModel:(TFAssistantSettingModel *)model;

@end
