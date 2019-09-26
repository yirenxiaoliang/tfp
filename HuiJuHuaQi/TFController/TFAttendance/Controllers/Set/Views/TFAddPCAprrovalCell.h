//
//  TFAddPCAprrovalCell.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/6/15.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseCell.h"

@interface TFAddPCAprrovalCell : HQBaseCell

@property (weak, nonatomic) IBOutlet UILabel *requrieLAb;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@property (weak, nonatomic) IBOutlet UIButton *setBtn;

+ (instancetype)addPCAprrovalCellWithTableView:(UITableView *)tableView;
@end
