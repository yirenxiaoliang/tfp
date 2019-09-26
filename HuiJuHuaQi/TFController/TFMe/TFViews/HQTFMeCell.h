//
//  HQTFMeCell.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/2/17.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseCell.h"
#import "HQTFCoopItemModel.h"

@interface HQTFMeCell : HQBaseCell
+ (HQTFMeCell *)meCellWithTableView:(UITableView *)tableView;

/** model */
@property (nonatomic, strong) HQTFCoopItemModel *item;

@end
