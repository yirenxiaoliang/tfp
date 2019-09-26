//
//  TFEmailsEditCell.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/4/20.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseCell.h"
#import "TFEmailsEditView.h"

@protocol TFEmailsEditCellDelegate <NSObject>

@optional
- (void)editCellHeight:(float)height;

@end

@interface TFEmailsEditCell : HQBaseCell

@property (nonatomic, strong) UILabel *requireLab;

@property (nonatomic, strong) UILabel *titleLab;

@property (nonatomic, strong) TFEmailsEditView *editView;

@property (nonatomic, strong) UIButton *addBtn;

@property (nonatomic, weak) id <TFEmailsEditCellDelegate>delegate;

+ (instancetype)emailsEditCellWithTableView:(UITableView *)tableView;

@end
