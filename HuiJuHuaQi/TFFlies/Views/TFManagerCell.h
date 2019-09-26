//
//  TFManagerCell.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2017/12/28.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseCell.h"
#import "TFManageItemModel.h"
#import "TFSettingItemModel.h"

@interface TFManagerCell : HQBaseCell

@property (weak, nonatomic) IBOutlet UIImageView *logoImg;
@property (weak, nonatomic) IBOutlet UILabel *authlab;

+ (instancetype)ManagerCellWithTableView:(UITableView *)tableView;

- (void)refreshManagerCellWithTableView:(TFManageItemModel *)model;

- (void)refreshSettingCellWithTableView:(TFSettingItemModel *)model;

@end
