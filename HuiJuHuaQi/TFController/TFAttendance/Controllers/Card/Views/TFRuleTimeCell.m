//
//  TFRuleTimeCell.m
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/6/18.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFRuleTimeCell.h"

@interface TFRuleTimeCell ()

@end

@implementation TFRuleTimeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.nameLabel.textColor = LightBlackTextColor;
    self.nameLabel.font = FONT(14);
    self.descLabel.textColor = GrayTextColor;
    self.descLabel.font = FONT(14);
    self.timeLabel.textColor = GrayTextColor;
    self.timeLabel.font = FONT(14);
    self.descLabel.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(descClicked)];
    [self.descLabel addGestureRecognizer:tap];
    
    self.contentView.backgroundColor = HexColor(0xF8FBFE);
    self.backgroundColor = HexColor(0xF8FBFE);
}

-(void)descClicked{
    if ([self.delegate respondsToSelector:@selector(ruleTimeCellDidClickedDesc)]) {
        [self.delegate ruleTimeCellDidClickedDesc];
    }
}

+(instancetype)ruleTimeCell{
    return [[[NSBundle mainBundle] loadNibNamed:@"TFRuleTimeCell" owner:self options:nil] lastObject];
}
+(instancetype)ruleTimeCellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"TFRuleTimeCell";
    TFRuleTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [TFRuleTimeCell ruleTimeCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.layer.masksToBounds = YES;
    }
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
