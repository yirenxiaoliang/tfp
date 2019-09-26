//
//  HQSwitchCell.m
//  HuiJuHuaQi
//
//  Created by hq002 on 16/4/7.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQSwitchCell.h"

@interface HQSwitchCell ()

@end

@implementation HQSwitchCell


- (void)awakeFromNib{
    
    [super awakeFromNib];
    
    self.title.textColor = CellTitleNameColor;
    self.title.font = FONT(14);
    
    [self.switchBtn addTarget:self
                       action:@selector(switchBtnClick:)
             forControlEvents:UIControlEventValueChanged];
    self.switchBtn.on = NO;
    
    [self.switchBtn setOnTintColor:GreenColor];
}


- (void)switchBtnClick:(UISwitch *)button{
    
    if ([self.delegate respondsToSelector:@selector(switchCellDidSwitchButton:)]) {
        [self.delegate switchCellDidSwitchButton:button];
    }
}

/** 刷新助手设置 */
-(void)refreshAssistantSettingWithModel:(TFAssistantSettingModel *)model{
    
    self.switchBtn.on = [model.assiatNotice isEqualToNumber:@0]?NO:@1;
    
}

+ (instancetype)switchCell
{
    return [[[NSBundle mainBundle] loadNibNamed:@"HQSwitchCell" owner:self options:nil] lastObject];
}

+ (instancetype)switchCellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"switchCell";
    HQSwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [self switchCell];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

@end
