//
//  TFTaskDetailStatusCell.h
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/4/17.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseCell.h"
#import "TFCustomerOptionModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TFTaskDetailStatusCell : HQBaseCell

@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *statusBtn;
/** type 0:状态 1：优先级
 *  status type == 0 时 0：未开始 1：进行中 2：暂停 3：已完成
 *  status type == 1 时 0：普通 1：紧急 2：非常紧急
 */
-(void)refreshTaskDetailStatusCellWithType:(NSInteger)type status:(NSInteger)status;

-(void)refreshTaskDetailStatusCellWithModel:(TFCustomerOptionModel *)model type:(NSInteger)type;

+(instancetype)taskDetailStatusCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
