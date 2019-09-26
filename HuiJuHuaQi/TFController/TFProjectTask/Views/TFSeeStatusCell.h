//
//  TFSeeStatusCell.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/8/2.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseCell.h"

@interface TFSeeStatusCell : HQBaseCell

-(void)refreshSeeStatusCellWithModel:(id)model;

+ (TFSeeStatusCell *)seeStatusCellWithTableView:(UITableView *)tableView;
@end
