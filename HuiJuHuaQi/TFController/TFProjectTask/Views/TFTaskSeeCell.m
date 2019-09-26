//
//  TFTaskSeeCell.m
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/5/16.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFTaskSeeCell.h"

@interface TFTaskSeeCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation TFTaskSeeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.headImage.image = IMG(@"子任务");
    self.headImage.contentMode = UIViewContentModeCenter;
    self.nameLabel.font = FONT(14);
    self.nameLabel.textColor = HexAColor(0x848E99,1);
    self.timeLabel.font = FONT(12);
    self.timeLabel.textColor = LightGrayTextColor;
}

-(void)refreshtaskSeeCellWithModel:(TFTaskHybirdDynamicModel *)model{
    
    self.headImage.image = IMG(@"子任务");
    self.nameLabel.text = [NSString stringWithFormat:@"%@  查看了任务 ",model.employee_name];
    self.timeLabel.text = [HQHelper nsdateToTimeNowYear:[model.create_time longLongValue]];
}
+(instancetype)taskSeeCellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"TFTaskSeeCell";
    TFTaskSeeCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [TFTaskSeeCell taskSeeCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.layer.masksToBounds = YES;
    }
    return cell;
}

+(instancetype)taskSeeCell{
    return [[[NSBundle mainBundle] loadNibNamed:@"TFTaskSeeCell" owner:self options:nil] lastObject];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
