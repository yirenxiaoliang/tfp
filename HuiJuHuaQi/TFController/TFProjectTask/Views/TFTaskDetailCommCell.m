//
//  TFTaskDetailCommCell.m
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/5/13.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFTaskDetailCommCell.h"

@interface TFTaskDetailCommCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@end

@implementation TFTaskDetailCommCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.headImage.contentMode = UIViewContentModeCenter;
    self.titleLabel.font = FONT(14);
    self.titleLabel.textColor = HexAColor(0x848E99,1);
    self.timeLabel.font = FONT(12);
    self.timeLabel.textColor = LightGrayTextColor;
    self.contentLabel.font = FONT(14);
    self.contentLabel.textColor = BlackTextColor;
    self.contentLabel.numberOfLines = 0;
    self.contentView.backgroundColor = BackGroudColor;
}

-(void)refreshTaskDetailCommCellWithModel:(TFTaskHybirdDynamicModel *)model{
    
    self.headImage.image = IMG(@"子任务");
    self.titleLabel.text = [NSString stringWithFormat:@"%@ ",model.employee_name];
    self.timeLabel.text = [HQHelper nsdateToTimeNowYear:[model.create_time longLongValue]];
    self.contentLabel.text = model.content;
}
+(CGFloat)refreshTaskDetailCommCellHeightWithModel:(TFTaskHybirdDynamicModel *)model{
    CGFloat height = 0;
    CGSize size = [HQHelper sizeWithFont:FONT(14) maxSize:(CGSize){SCREEN_WIDTH-70,MAXFLOAT} titleStr:model.content];
    height += 50;// 固定高度
    height += size.height;
    if (height < 60) {
        height  = 60;
    }
    return height;
}

+(instancetype)taskDetailCommCellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"TFTaskDetailCommCell";
    TFTaskDetailCommCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [TFTaskDetailCommCell taskDetailCommCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.layer.masksToBounds = YES;
    }
    return cell;
}

+(instancetype)taskDetailCommCell{
    return [[[NSBundle mainBundle] loadNibNamed:@"TFTaskDetailCommCell" owner:self options:nil] lastObject];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
