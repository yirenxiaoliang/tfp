//
//  TFChatTipCell.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2017/12/30.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseCell.h"

@interface TFChatTipCell : HQBaseCell

@property (weak, nonatomic) IBOutlet UILabel *timeLab;

@property (weak, nonatomic) IBOutlet UILabel *contentLab;

+ (instancetype)ChatTipCellWithTableView:(UITableView *)tableView;

@end
