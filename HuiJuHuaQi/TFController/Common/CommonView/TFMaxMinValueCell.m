//
//  TFMaxMinValueCell.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/9/25.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFMaxMinValueCell.h"

@interface TFMaxMinValueCell ()

@end

@implementation TFMaxMinValueCell

-(void)awakeFromNib{
    [super awakeFromNib];
    
    [self.textField1 addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];
    [self.textField1 setAdjustsFontSizeToFitWidth:YES];
    self.textField1.tag = 0x111;
    [self.textField2 addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];
    [self.textField2 setAdjustsFontSizeToFitWidth:YES];
    self.textField2.tag = 0x222;
}

- (void)textChange:(UITextField *)textField{
    
    
    if ([self.delegate respondsToSelector:@selector(maxMinValueCell: withTextField:)]) {
        [self.delegate maxMinValueCell:self withTextField:textField];
    }
    
}


+ (instancetype)maxMinValueCell
{
    return [[[NSBundle mainBundle] loadNibNamed:@"TFMaxMinValueCell" owner:self options:nil] lastObject];
}


+ (instancetype)maxMinValueCellWithTableView:(UITableView *)tableView
{
    static NSString *indentifier = @"maxMinValueCell";
    TFMaxMinValueCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [self maxMinValueCell];
    }
    cell.layer.masksToBounds = YES;
    cell.bottomLine.hidden = YES;
    return cell;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
