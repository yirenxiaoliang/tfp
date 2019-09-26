//
//  TFFourBtnCell.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/6/13.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseCell.h"

@interface TFFourBtnCell : HQBaseCell

-(void)refreshFourBtnCellWithEmployee:(HQEmployModel *)employee;
-(void)refreshFourBtnCellWithTime:(NSString *)time;

+ (TFFourBtnCell *)fourBtnCellWithTableView:(UITableView *)tableView;

@end
