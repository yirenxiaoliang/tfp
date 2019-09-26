//
//  TFEmailsTagCell.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/3/23.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseCell.h"
#import "TFEmailsAccountTagView.h"

@interface TFEmailsTagCell : HQBaseCell

+ (instancetype)emailsTagCellWithTableView:(UITableView *)tableView;

@property (nonatomic, weak) TFEmailsAccountTagView *accountTagView;

@end
