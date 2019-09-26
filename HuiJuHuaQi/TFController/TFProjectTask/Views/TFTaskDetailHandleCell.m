//
//  TFTaskDetailHandleCell.m
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/4/16.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFTaskDetailHandleCell.h"

@interface TFTaskDetailHandleCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headImage;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *startTime;
@property (weak, nonatomic) IBOutlet UIButton *endTime;
@property (weak, nonatomic) IBOutlet UILabel *toLabel;


@end

@implementation TFTaskDetailHandleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.toLabel.textColor = ExtraLightBlackTextColor;
    [self.startTime setTitleColor:LightGrayTextColor forState:UIControlStateNormal];
    [self.endTime setTitleColor:LightGrayTextColor forState:UIControlStateNormal];
    self.timeLabel.textColor = ExtraLightBlackTextColor;
    self.timeLabel.font = FONT(14);
    self.headImage.image = IMG(@"timePro");
}

-(void)refreshTaskDetailHandleCellWithStartTime:(long long)startTime endTime:(long long)endTime{
    
    if (startTime == 0) {
        [self.startTime setTitle:@"开始时间" forState:UIControlStateNormal];
    }else{
        [self.startTime setTitle:[HQHelper nsdateToTimeNowYear:startTime] forState:UIControlStateNormal];
    }
    if (endTime == 0) {
        [self.endTime setTitle:@"截止时间" forState:UIControlStateNormal];
    }else{
        [self.endTime setTitle:[HQHelper nsdateToTimeNowYear:endTime] forState:UIControlStateNormal];
    }
    
}
/** 添加开始时间 */
- (IBAction)start:(id)sender {
    if ([self.delegate respondsToSelector:@selector(addStartTime)]) {
        [self.delegate addStartTime];
    }
}
/** 添加结束时间 */
- (IBAction)end:(id)sender {
    if ([self.delegate respondsToSelector:@selector(addEndTime)]) {
        [self.delegate addEndTime];
    }
}


+(instancetype)taskDetailHandleCell{
    return [[[NSBundle mainBundle] loadNibNamed:@"TFTaskDetailHandleCell" owner:self options:nil] lastObject];
}
+(instancetype)taskDetailHandleCellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"TFTaskDetailHandleCell";
    TFTaskDetailHandleCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [TFTaskDetailHandleCell taskDetailHandleCell];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
