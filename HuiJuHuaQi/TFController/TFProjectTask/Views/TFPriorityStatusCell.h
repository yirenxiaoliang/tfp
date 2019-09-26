//
//  TFPriorityStatusCell.h
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/4/18.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseCell.h"
#import "TFCustomerOptionModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TFPriorityStatusCell : HQBaseCell

@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
/** type 0:状态 1：优先级
 *  status type == 0 时 0：未开始 1：进行中 2：暂停 3：已完成
 *  status type == 1 时 0：普通 1：紧急 2：非常紧急
 */
-(void)refreshPriorityStatusCellWithType:(NSInteger)type status:(NSInteger)status;
/** 新的 */
-(void)refreshNewStatusCellWithModel:(TFCustomerOptionModel *)model;
/** 刷新状态 */
-(void)refreshStatusCellWithModel:(TFCustomerOptionModel *)model;
/** 刷新优先级 */
-(void)refreshPriorityStatusCellWithModel:(TFCustomerOptionModel *)model;



+(instancetype)priorityStatusCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
