
//
//  TFStatisticsListCell.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/3/5.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFStatisticsListCell.h"

@interface TFStatisticsListCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *sourceLabel;
@property (weak, nonatomic) IBOutlet UILabel *creatorLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleTopW;
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;

@end

@implementation TFStatisticsListCell

-(void)awakeFromNib{
    [super awakeFromNib];
    
    self.titleLabel.textColor = ExtraLightBlackTextColor;
    self.titleLabel.font = FONT(16);
    self.sourceLabel.textColor = FinishedTextColor;
    self.sourceLabel.font = FONT(14);
    self.creatorLabel.textColor = FinishedTextColor;
    self.creatorLabel.font = FONT(14);
    self.headMargin = 50;
}

-(void)setType:(NSInteger)type{
    _type = type;
    
    self.sourceLabel.hidden = YES;
    self.creatorLabel.hidden = YES;
    self.titleTopW.constant = 8;
    
    if (type == 0) {
        
        [self.iconImage setImage:[UIImage imageNamed:@"tableIcon"]];
    }else{
        
        [self.iconImage setImage:[UIImage imageNamed:@"pieChart"]];
    }
    
}

+ (instancetype)statisticsListCell{
    return [[[NSBundle mainBundle] loadNibNamed:@"TFStatisticsListCell" owner:self options:nil] lastObject];
}

+ (instancetype)statisticsCellWithTableView:(UITableView *)tableView{
    
    static NSString *indentifier = @"TFStatisticsListCell";
    
    TFStatisticsListCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    
    if (cell == nil) {
        cell = [self statisticsListCell];
    }
    
    return cell;
}

- (void)refreshStatisticsCellWithModel:(TFStatisticsItemModel *)model{
    
    if (self.type == 0) {
        
        self.titleLabel.text = model.report_label;
        self.sourceLabel.text = [NSString stringWithFormat:@"数据源：%@",model.data_source_label];
        self.creatorLabel.text = [NSString stringWithFormat:@"创建人：%@",model.create_by_name];
    }else{
        
        self.titleLabel.text = model.name;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
