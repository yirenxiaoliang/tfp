//
//  TFEmailsListCell.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/1/30.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseCell.h"
#import "TFEmailReceiveListModel.h"

@interface TFEmailsListCell : HQBaseCell

@property (weak, nonatomic) IBOutlet UIButton *rightStatusBtn;
@property (weak, nonatomic) IBOutlet UIButton *leftStatusBtn;
@property (weak, nonatomic) IBOutlet UIButton *threeStatusBtn;

@property (nonatomic, assign) BOOL select;

+ (instancetype)EmailsListCellWithTableView:(UITableView *)tableView;

- (void)refreshEmailListCellWithModel:(TFEmailReceiveListModel *)model;

@end
