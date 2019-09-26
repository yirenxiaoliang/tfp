//
//  TFAtdOneTFCell.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/7/30.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseCell.h"

@protocol TFAtdOneTFCellDelegate <NSObject>

@optional
- (void)enterBtnClicked:(NSInteger)flag;

@end

@interface TFAtdOneTFCell : HQBaseCell
@property (weak, nonatomic) IBOutlet UILabel *requireLab;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UITextField *contentTF;
@property (weak, nonatomic) IBOutlet UIButton *enterBtn;

+ (instancetype)atdOneTFCellWithTableView:(UITableView *)tableView;

@property (nonatomic, weak) id <TFAtdOneTFCellDelegate>delegate;

@end
