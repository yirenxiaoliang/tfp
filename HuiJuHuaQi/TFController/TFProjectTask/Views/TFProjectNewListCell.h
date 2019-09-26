//
//  TFProjectNewListCell.h
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/4/16.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseCell.h"
#import "TFProjectModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TFProjectNewListCell : HQBaseCell

- (void)refreshProjectListCellWithProjectModel:(TFProjectModel *)model;

+(instancetype)projectNewListCellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
