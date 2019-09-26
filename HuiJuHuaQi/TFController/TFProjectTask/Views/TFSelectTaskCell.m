//
//  TFSelectTaskCell.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/6/4.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFSelectTaskCell.h"
#import "TFQuoteTaskItemModel.h"


@interface TFSelectTaskCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *peopleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;

@end

@implementation TFSelectTaskCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.titleLabel.textColor = BlackTextColor;
    self.titleLabel.font = FONT(16);
    
    self.peopleLabel.textColor = FinishedTextColor;
    self.peopleLabel.font = FONT(12);
    
    self.timeLabel.textColor = FinishedTextColor;
    self.timeLabel.font = FONT(12);
    
    self.headMargin = 52;
}

+ (instancetype)selectTaskCell
{
    return [[[NSBundle mainBundle] loadNibNamed:@"TFSelectTaskCell" owner:self options:nil] lastObject];
}

+ (TFSelectTaskCell *)selectTaskCellWithTableView:(UITableView *)tableView
{
    static NSString *indentifier = @"TFSelectTaskCell";
    TFSelectTaskCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [self selectTaskCell];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)refreshSelectTaskCellWithModel:(TFQuoteTaskItemModel *)model{
    
    self.titleLabel.text = model.task_name;
    self.peopleLabel.text = [NSString stringWithFormat:@"执行人：%@",TEXT(model.employee_name)];
    self.timeLabel.text = [NSString stringWithFormat:@"截止时间：%@",[HQHelper nsdateToTime:[model.end_time longLongValue] formatStr:@"yyyy-MM-dd HH:mm"]];
    
    if ([model.select isEqualToNumber:@1]) {
        self.selectBtn.selected = YES;
    }else{
        self.selectBtn.selected = NO;
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
