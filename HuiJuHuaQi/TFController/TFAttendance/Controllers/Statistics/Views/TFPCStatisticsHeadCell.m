//
//  TFPCStatisticsHeadCell.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/6/19.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFPCStatisticsHeadCell.h"

@interface TFPCStatisticsHeadCell ()
@property (weak, nonatomic) IBOutlet UIImageView *arrow;

@end

@implementation TFPCStatisticsHeadCell


- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.arrow.transform = CGAffineTransformRotate(self.arrow.transform, M_PI_2);
    
    [self.calendarBtn setTitleColor:GreenColor forState:UIControlStateNormal];
    [self.calendarBtn addTarget:self action:@selector(selectDate) forControlEvents:UIControlEventTouchUpInside];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(calendarClicked)];
    self.lable.userInteractionEnabled = YES;
    [self.lable addGestureRecognizer:tap];
}

-(void)calendarClicked{
    if ([self.delegate respondsToSelector:@selector(statisticsHeadCellDidSelectCalendar)]) {
        [self.delegate statisticsHeadCellDidSelectCalendar];
    }
}

-(void)selectDate{
    if ([self.delegate respondsToSelector:@selector(statisticsHeadCellDidSelectDate)]) {
        [self.delegate statisticsHeadCellDidSelectDate];
    }
}


+ (instancetype)TFPCStatisticsHeadCell
{
    return [[[NSBundle mainBundle] loadNibNamed:@"TFPCStatisticsHeadCell" owner:self options:nil] lastObject];
}

+ (instancetype)PCStatisticsHeadCellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"TFPCStatisticsHeadCell";
    TFPCStatisticsHeadCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [self TFPCStatisticsHeadCell];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    
}

@end
