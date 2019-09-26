//
//  TFCustomerPieCell.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/8/22.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseCell.h"

@interface TFCustomerPieCell : HQBaseCell

+ (TFCustomerPieCell *)customerPieCellWithTableView:(UITableView *)tableView withType:(NSInteger)type;

-(void)refreshCellWithModels:(NSArray *)models;

@end
