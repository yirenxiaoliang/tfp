//
//  HQTFPeopleHeadInfoCell.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/2/24.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseCell.h"
#import "TFProjectPricipalModel.h"

@interface HQTFPeopleHeadInfoCell : HQBaseCell

+ (HQTFPeopleHeadInfoCell *)peopleHeadInfoCellWithTableView:(UITableView *)tableView;

- (void)refreshPeopleHeadInfoCellWithModel:(TFProjectPricipalModel *)model;

@end
