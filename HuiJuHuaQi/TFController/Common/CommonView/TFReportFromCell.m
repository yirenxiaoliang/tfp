//
//  TFReportFromCell.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2017/6/2.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFReportFromCell.h"

@interface TFReportFromCell ()

@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UILabel *formLab;
@property (weak, nonatomic) IBOutlet UIImageView *photoImgV;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;

@end

@implementation TFReportFromCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundView.backgroundColor = [UIColor clearColor];
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.bgView.backgroundColor = WhiteColor;
    
    self.formLab.textColor = HexAColor(0x69696C,1);
    self.nameLab.textColor = HexAColor(0x4A4A4A,1);
    self.timeLab.textColor = HexAColor(0xA0A0AE,1);
}



+ (instancetype)TFReportFromCell
{
    return [[[NSBundle mainBundle] loadNibNamed:@"TFReportFromCell" owner:self options:nil] lastObject];
}

+ (instancetype)reportFromCellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"TFReportFromCell";
    TFReportFromCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [self TFReportFromCell];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

@end
