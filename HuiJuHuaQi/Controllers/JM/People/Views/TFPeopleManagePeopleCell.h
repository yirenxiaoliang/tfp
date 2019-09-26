//
//  TFPeopleManagePeopleCell.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/4/22.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseCell.h"
#import "HQEmployModel.h"

@interface TFPeopleManagePeopleCell : HQBaseCell

+ (TFPeopleManagePeopleCell *)peopleManagePeopleCellWithTableView:(UITableView *)tableView;

-(void)refreshPeopleManagePeopleCellWithModel:(HQEmployModel *)model type:(NSInteger)type;



@end
