//
//  TFChatTipCell.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2017/12/30.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFChatTipCell.h"

@interface TFChatTipCell ()

@end

@implementation TFChatTipCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    self.contentView.backgroundColor = kUIColorFromRGB(0xF2F2F2);
    
    self.timeLab.layer.cornerRadius = 5.0;
    self.timeLab.layer.masksToBounds = YES;
    
    self.contentLab.layer.cornerRadius = 5.0;
    self.contentLab.layer.masksToBounds = YES;
}


+ (instancetype)TFChatTipCell
{
    return [[[NSBundle mainBundle] loadNibNamed:@"TFChatTipCell" owner:self options:nil] lastObject];
}



+ (instancetype)ChatTipCellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"TFChatTipCell";
    TFChatTipCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [self TFChatTipCell];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    
}

@end
