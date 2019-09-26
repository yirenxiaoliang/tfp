//
//  TFTaskSeeCell.h
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/5/16.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseCell.h"
#import "TFTaskHybirdDynamicModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TFTaskSeeCell : HQBaseCell

-(void)refreshtaskSeeCellWithModel:(TFTaskHybirdDynamicModel *)model;
+(instancetype)taskSeeCellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
