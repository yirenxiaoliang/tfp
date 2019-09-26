//
//  HQWriteContentCell.m
//  HuiJuHuaQi
//
//  Created by hq002 on 16/3/14.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQWriteContentCell.h"

@interface HQWriteContentCell ()

@end

@implementation HQWriteContentCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    self.topLine.backgroundColor = CellSeparatorColor;
    self.bottomLine.backgroundColor = CellSeparatorColor;
    self.title.font = FONT(14);
    self.content.font = FONT(16);
    self.title.textColor = CellTitleNameColor;
    self.content.textColor = BlackTextColor;
}


+ (instancetype)writeContentCell
{
    return [[[NSBundle mainBundle] loadNibNamed:@"HQWriteContentCell" owner:self options:nil] lastObject];
}

+ (HQWriteContentCell *)writeContentCellWithTableView:(UITableView *)tableView
{
    static NSString *indentifier = @"writeContentCell";
    HQWriteContentCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [self writeContentCell];
    }
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
