//
//  HQInputNumCell.m
//  HuiJuHuaQi
//
//  Created by XieLB on 16/4/11.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQInputNumCell.h"

@implementation HQInputNumCell

+ (instancetype)inputNumCell
{
    return [[[NSBundle mainBundle] loadNibNamed:@"HQInputNumCell" owner:self options:nil] lastObject];
}

+ (HQInputNumCell *)inputNumCelllWithTableView:(UITableView *)tableView
{
    static NSString *indentifier = @"inputNumCell";
    HQInputNumCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [self inputNumCell];
        
//        [cell.numberField addTarget:self
//                             action:@selector(numberFieldChangeInputMoneyCell:)
//                   forControlEvents:UIControlEventEditingChanged];
    }
    

    return cell;
}


- (void)setTitleNameStr:(NSString *)titleNameStr
{
    _titleNameLabel.text = titleNameStr;
    
    CGFloat titleWidth = [HQHelper sizeWithFont:_titleNameLabel.font
                                        maxSize:CGSizeMake(1000, 20)
                                       titleStr:titleNameStr].width;
    _titleWidthLayout.constant = titleWidth;
}


- (void)setUnitStr:(NSString *)unitStr
{
    _unitLabel.text = unitStr;
    
    CGFloat titleWidth = [HQHelper sizeWithFont:_unitLabel.font
                                        maxSize:CGSizeMake(1000, 20)
                                       titleStr:unitStr].width;
    _unitWidthLayout.constant = titleWidth;
}




//- (void)numberFieldChangeInputMoneyCell:(UITextField *)textField
//{
//    
//    if ([self.delegate respondsToSelector:@selector(numTextFieldChange:)]) {
//        
//        [self.delegate numTextFieldChange:textField.text];
//    }
//}


@end
