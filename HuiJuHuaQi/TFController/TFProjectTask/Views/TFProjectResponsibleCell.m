//
//  TFProjectResponsibleCell.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/4/12.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFProjectResponsibleCell.h"

@interface TFProjectResponsibleCell ()


@end

@implementation TFProjectResponsibleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.headImage.layer.cornerRadius = 20;
    self.headImage.layer.masksToBounds = YES;
    
    self.titleLabel.textColor = CellTitleNameColor;
    self.titleLabel.font = FONT(14);
    
}
+ (instancetype)projectResponsibleCell
{
    return [[[NSBundle mainBundle] loadNibNamed:@"TFProjectResponsibleCell" owner:self options:nil] lastObject];
}


+ (instancetype)projectResponsibleCellWithTableView:(UITableView *)tableView
{
    static NSString *indentifier = @"TFProjectResponsibleCell";
    TFProjectResponsibleCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [self projectResponsibleCell];
    }
    cell.layer.masksToBounds = YES;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
