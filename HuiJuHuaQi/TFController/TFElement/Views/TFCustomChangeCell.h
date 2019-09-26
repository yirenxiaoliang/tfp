//
//  TFCustomChangeCell.h
//  HuiJuHuaQi
//
//  Created by HQ-30 on 2017/12/13.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseCell.h"

@interface TFCustomChangeCell : HQBaseCell

@property (weak, nonatomic) UIImageView *box;

@property (weak, nonatomic) UILabel *name;

+ (instancetype)customChangeCellWithTableView:(UITableView *)tableView;

@end
