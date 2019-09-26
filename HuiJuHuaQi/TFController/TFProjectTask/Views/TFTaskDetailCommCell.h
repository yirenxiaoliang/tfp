//
//  TFTaskDetailCommCell.h
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/5/13.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseCell.h"
#import "TFTaskHybirdDynamicModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TFTaskDetailCommCell : HQBaseCell

+(instancetype)taskDetailCommCellWithTableView:(UITableView *)tableView;

-(void)refreshTaskDetailCommCellWithModel:(TFTaskHybirdDynamicModel *)model;
+(CGFloat)refreshTaskDetailCommCellHeightWithModel:(TFTaskHybirdDynamicModel *)model;

@end

NS_ASSUME_NONNULL_END
