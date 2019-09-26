//
//  HQInputMoneyCell.m
//  HuiJuHuaQi
//
//  Created by XieLB on 16/4/11.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQInputMoneyCell.h"

@implementation HQInputMoneyCell

+ (instancetype)inputMoney
{
    return [[[NSBundle mainBundle] loadNibNamed:@"HQInputMoneyCell" owner:self options:nil] lastObject];
}

+ (HQInputMoneyCell *)inputMoneyCelllWithTableView:(UITableView *)tableView
{
    static NSString *indentifier = @"inputMoneyCell";
    HQInputMoneyCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [self inputMoney];
        
//        [cell.moneyField addTarget:self
//                            action:@selector(moneyFieldChangeInputMoneyCell:)
//                  forControlEvents:UIControlEventEditingChanged];
    }
    
    
    cell.titleLabel.textColor = CellTitleNameColor;

    
    return cell;
}

//
//- (void)moneyFieldChangeInputMoneyCell:(UITextField *)textField
//{
//
//    if ([self.delegate respondsToSelector:@selector(moneyTextFieldChange:)]) {
//        
//        [self.delegate moneyTextFieldChange:textField.text];
//    }
//}


@end
