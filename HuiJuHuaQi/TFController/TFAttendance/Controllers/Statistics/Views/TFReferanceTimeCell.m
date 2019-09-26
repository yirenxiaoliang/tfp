//
//  TFReferanceTimeCell.m
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/3/26.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFReferanceTimeCell.h"

@interface TFReferanceTimeCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *startTime;
@property (weak, nonatomic) IBOutlet UILabel *endTime;


@end

@implementation TFReferanceTimeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.startTime.textColor = ExtraLightBlackTextColor;
    self.endTime.textColor = ExtraLightBlackTextColor;
    self.startTime.font = FONT(12);
    self.endTime.font = FONT(12);
    self.timeLabel.font = FONT(10);
    self.timeLabel.textColor = GreenColor;
    self.headImage.layer.cornerRadius = 23;
    self.headImage.layer.masksToBounds = YES;
    self.headImage.layer.borderColor =  HexColor(0xBFE4FF).CGColor;
    self.headImage.layer.borderWidth = 0.5;
    self.headImage.backgroundColor = HexColor(0xE8F5FF);
}

-(void)refreshReferanceTimeCellWithModel:(TFDimensionModel *)model{
    
    self.timeLabel.text = [NSString stringWithFormat:@"时长%@",model.duration];
    self.startTime.text = [NSString stringWithFormat:@"开始时间：%@",[HQHelper nsdateToTime:[model.startTime?:model.start_time longLongValue] formatStr:@"yyyy年MM月dd日(EEEE) HH:mm"]];
    self.endTime.text = [NSString stringWithFormat:@"结束时间：%@",[HQHelper nsdateToTime:[model.endTime?:model.end_time longLongValue] formatStr:@"yyyy年MM月dd日(EEEE) HH:mm"]];
    
}

+(instancetype)referanceTimeCell{
    return [[[NSBundle mainBundle] loadNibNamed:@"TFReferanceTimeCell" owner:self options:nil] lastObject];
}
+(instancetype)referanceTimeCellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"TFReferanceTimeCell";
    TFReferanceTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [TFReferanceTimeCell referanceTimeCell];
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
