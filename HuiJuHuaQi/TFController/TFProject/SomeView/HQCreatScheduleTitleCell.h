//
//  HQCreatScheduleTitleCell.h
//  HuiJuHuaQi
//
//  Created by hq002 on 16/3/24.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseCell.h"
#import "HQAdviceTextView.h"

@interface HQCreatScheduleTitleCell : HQBaseCell

@property (nonatomic ,weak) HQAdviceTextView *textVeiw;
+ (instancetype)creatScheduleTitleCellWithTableView:(UITableView *)tableView;
@end
