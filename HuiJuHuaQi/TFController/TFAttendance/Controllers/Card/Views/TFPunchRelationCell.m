//
//  TFPunchRelationCell.m
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/4/11.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFPunchRelationCell.h"

@interface TFPunchRelationCell ()
@property (weak, nonatomic) IBOutlet UIImageView *tipImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;


@end

@implementation TFPunchRelationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.nameLabel.font = FONT(14);
    self.timeLabel.font = FONT(14);
}

-(void)refreshPunchRelationCellWithModel:(TFRelationModuleModel *)model{
    // 0("缺卡"), 1("请假"), 2("加班"), 3("出差"), 4("销假"), 5("外出");
    switch ([model.relevance_status integerValue]) {
        case 0:
            {
                self.nameLabel.textColor = ExtraLightBlackTextColor;
                self.timeLabel.textColor = ExtraLightBlackTextColor;
                self.tipImage.image = IMG(@"请假att");
            }
            break;
        case 1:
        {
            self.nameLabel.textColor = HexColor(0xF42E2E);
            self.timeLabel.textColor = HexColor(0x49629C);
            self.tipImage.image = IMG(@"请假att");
        }
            break;
        case 2:
        {
            self.nameLabel.textColor = ExtraLightBlackTextColor;
            self.timeLabel.textColor = ExtraLightBlackTextColor;
            self.tipImage.image = IMG(@"请假att");
        }
            break;
        case 3:
        {
            self.nameLabel.textColor = GreenColor;
            self.timeLabel.textColor = GreenColor;
            self.tipImage.image = IMG(@"出差att");
        }
            break;
        case 4:
        {
            self.nameLabel.textColor = HexColor(0xFF5E00);
            self.timeLabel.textColor = HexColor(0xFF5E00);
            self.tipImage.image = IMG(@"销假att");
        }
            break;
        case 5:
        {
            self.nameLabel.textColor = GreenColor;
            self.timeLabel.textColor = GreenColor;
            self.tipImage.image = IMG(@"外出att");
        }
            break;
            
        default:
            self.nameLabel.textColor = ExtraLightBlackTextColor;
            self.timeLabel.textColor = ExtraLightBlackTextColor;
            self.tipImage.image = IMG(@"");
            break;
    }
    
    self.nameLabel.text = model.chinese_name;
    self.timeLabel.text = [NSString stringWithFormat:@"%@ ~ %@",[HQHelper nsdateToTime:[model.start_time longLongValue] formatStr:@"yyyy-MM-dd HH:mm"],[HQHelper nsdateToTime:[model.end_time longLongValue] formatStr:@"yyyy-MM-dd HH:mm"]];
}

+(instancetype)punchRelationCell{
    return [[[NSBundle mainBundle] loadNibNamed:@"TFPunchRelationCell" owner:self options:nil] lastObject];
}

+(instancetype)punchRelationCellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"TFPunchRelationCell";
    TFPunchRelationCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [TFPunchRelationCell punchRelationCell];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
