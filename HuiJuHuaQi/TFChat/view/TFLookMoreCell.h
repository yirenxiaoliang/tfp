//
//  TFLookMoreCell.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/8/9.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseCell.h"

@interface TFLookMoreCell : HQBaseCell

@property (weak, nonatomic) IBOutlet UIButton *buttonOne;

@property (weak, nonatomic) IBOutlet UILabel *lableOne;
@property (weak, nonatomic) IBOutlet UIButton *buttonTwo;

+ (instancetype)lookMoreCellWithTableView:(UITableView *)tableView;

@end
