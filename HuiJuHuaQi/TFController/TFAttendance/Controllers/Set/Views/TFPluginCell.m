//
//  TFPluginCell.m
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/7/3.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFPluginCell.h"

@interface TFPluginCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UISwitch *switchBtn;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;


@property (nonatomic, strong) TFPluginModel *model;

@end

@implementation TFPluginCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.headImage.layer.cornerRadius = 4;
    self.headImage.layer.masksToBounds = YES;
    
    self.nameLabel.font = FONT(16);
    self.nameLabel.textColor = LightBlackTextColor;
    
    self.descLabel.textColor = ExtraLightBlackTextColor;
    self.descLabel.font = FONT(12);
    
    [self.switchBtn setOnTintColor:GreenColor];
    
    self.headMargin = 0;
}
- (IBAction)switchBtnClicked:(UISwitch *)sender {
    
    if ([self.delegate respondsToSelector:@selector(pluginCellDidClickedSwitchBtn:model:)]) {
        [self.delegate pluginCellDidClickedSwitchBtn:sender model:self.model];
    }
}

-(void)refreshPluginCellWithModel:(TFPluginModel *)model{
    
    self.model = model;
    
    switch ([model.plugin_type integerValue]) {
        case 1:
            {
                self.headImage.image = IMG(@"quickPunch");
                self.nameLabel.text = model.plugin_name;
                self.descLabel.text = model.plugin_note;
                self.switchBtn.on = [model.plugin_status isEqualToNumber:@1];
            }
            break;
            
        default:
            break;
    }
    
}

+(instancetype)pluginCell{
    return [[[NSBundle mainBundle] loadNibNamed:@"TFPluginCell" owner:self options:nil] lastObject];
}
+(instancetype)pluginCellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"TFPluginCell";
    TFPluginCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [TFPluginCell pluginCell];
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
