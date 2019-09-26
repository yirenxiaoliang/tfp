//
//  TFProjectShareListCell.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/4/13.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseCell.h"
#import "TFProjectShareInfoModel.h"

@interface TFProjectShareListCell : HQBaseCell


- (void)refreshProjectShareListCellWithData:(TFProjectShareInfoModel *)model;

+ (instancetype)projectShareListCellWithTableView:(UITableView *)tableView;







@end
