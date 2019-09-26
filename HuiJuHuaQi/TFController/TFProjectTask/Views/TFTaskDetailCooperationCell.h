//
//  TFTaskDetailCooperationCell.h
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/4/16.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseCell.h"

NS_ASSUME_NONNULL_BEGIN

@protocol TFTaskDetailCooperationCellDelegate <NSObject>

@optional
-(void)taskDetailCooperationCellHandleSwitchBtn:(UISwitch *)switchBtn;

@end

@interface TFTaskDetailCooperationCell : HQBaseCell


@property (weak, nonatomic) IBOutlet UISwitch *switchBtn;
@property (nonatomic, weak) id <TFTaskDetailCooperationCellDelegate>delegate;

+(instancetype)taskDetailCooperationCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
