//
//  HQMoneyTextCell.m
//  HuiJuHuaQi
//
//  Created by XieLB on 16/4/19.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQMoneyTextCell.h"

@implementation HQMoneyTextCell


- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.lineYLayout.constant = 0.5;
    
    self.topTitleLabel.text = @"金额(元)";
    self.topTitleLabel.textColor = CellTitleNameColor;
    self.topTitleLabel.font = FONT(17);
    
    self.bottomLabel.text = @"费用说明";
    self.bottomLabel.textColor = CellTitleNameColor;
    self.bottomLabel.font = FONT(17);
    
//    self.contentTextView.placeholder = @"如餐费、差旅费等";
//    self.contentTextView.font = FONT(17);
//    self.contentTextView.placeholderColor = CellSeparatorColor;
//    self.contentTextView.textAlignment = NSTextAlignmentRight;
    
    self.moneyTextField.font = FONT(17);
    self.moneyTextField.placeholder = @"请输入金额";
    self.moneyTextField.keyboardType = UIKeyboardTypeDecimalPad;
}




+ (instancetype)moneyTextCell
{
    return [[[NSBundle mainBundle] loadNibNamed:@"HQMoneyTextCell" owner:self options:nil] lastObject];
}



+ (HQMoneyTextCell *)moneyTextCellWithTableView:(UITableView *)tableView
{
    static NSString *indentifier = @"selectLeaveCell";
    HQMoneyTextCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [self moneyTextCell];
    }
    
    
    return cell;
}



@end
