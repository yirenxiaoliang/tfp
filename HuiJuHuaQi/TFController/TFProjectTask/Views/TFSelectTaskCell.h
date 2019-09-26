//
//  TFSelectTaskCell.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/6/4.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseCell.h"

@interface TFSelectTaskCell : HQBaseCell

+ (TFSelectTaskCell *)selectTaskCellWithTableView:(UITableView *)tableView;

- (void)refreshSelectTaskCellWithModel:(id)model;


@end
