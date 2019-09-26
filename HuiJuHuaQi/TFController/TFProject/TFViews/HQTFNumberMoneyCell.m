//
//  HQTFNumberMoneyCell.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/2/25.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQTFNumberMoneyCell.h"

@interface HQTFNumberMoneyCell ()
@property (weak, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet UIButton *number;
@property (weak, nonatomic) IBOutlet UIButton *money;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewW;

@end

@implementation HQTFNumberMoneyCell

-(void)awakeFromNib{
    [super awakeFromNib];
    
    self.view.backgroundColor = CellSeparatorColor;
    self.viewW.constant = 0.5;
    self.number.selected = YES;
    [self.number addTarget:self action:@selector(numberClick) forControlEvents:UIControlEventTouchUpInside];
    [self.money addTarget:self action:@selector(moneyClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)numberClick{
    
    self.number.selected = YES;
    self.money.selected = NO;
    
    if ([self.delegate respondsToSelector:@selector(numberMoneyCellDidSelectedWithValue:)]) {
        [self.delegate numberMoneyCellDidSelectedWithValue:0];
    }
}

- (void)moneyClick{
    
    self.number.selected = NO;
    self.money.selected = YES;
    if ([self.delegate respondsToSelector:@selector(numberMoneyCellDidSelectedWithValue:)]) {
        [self.delegate numberMoneyCellDidSelectedWithValue:1];
    }
}

+ (instancetype)numberMoneyCell{
    return [[[NSBundle mainBundle] loadNibNamed:@"HQTFNumberMoneyCell" owner:self options:nil] lastObject];
}

+ (HQTFNumberMoneyCell *)numberMoneyCellWithTableView:(UITableView *)tableView
{
    static NSString *indentifier = @"HQTFNumberMoneyCell";
    HQTFNumberMoneyCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [self numberMoneyCell];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.topLine.hidden = YES;
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
