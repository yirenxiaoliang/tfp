//
//  TFPeopleManageDepartmentCell.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/4/22.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseCell.h"
#import "HQDepartmentModel.h"
@interface TFPeopleManageDepartmentCell : HQBaseCell

-(void)refreshPeopleManageDepartmentCellWithModel:(HQDepartmentModel *)model;
+ (TFPeopleManageDepartmentCell *)peopleManageDepartmentCellWithTableView:(UITableView *)tableView;

@end
