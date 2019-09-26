//
//  TFReferanceTimeCell.h
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/3/26.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseCell.h"
#import "TFDimensionModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TFReferanceTimeCell : HQBaseCell

+(instancetype)referanceTimeCellWithTableView:(UITableView *)tableView;

-(void)refreshReferanceTimeCellWithModel:(TFDimensionModel *)model;

@end

NS_ASSUME_NONNULL_END
