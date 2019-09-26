//
//  HQInputMoneyCell.h
//  HuiJuHuaQi
//
//  Created by XieLB on 16/4/11.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseTableViewCell.h"

//@protocol HQInputMoneyCellDelegate <NSObject>
//
//- (void)moneyTextFieldChange:(NSString *)string;
//
//@end

@interface HQInputMoneyCell : HQBaseTableViewCell


@property (strong, nonatomic) IBOutlet UILabel *titleLabel;


@property (strong, nonatomic) IBOutlet UITextField *moneyField;


//@property (nonatomic, weak) id <HQInputMoneyCellDelegate> delegate;


+ (HQInputMoneyCell *)inputMoneyCelllWithTableView:(UITableView *)tableView;


@end
