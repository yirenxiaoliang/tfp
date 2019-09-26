//
//  TFSeeStatusCell.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/8/2.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFSeeStatusCell.h"

@interface TFSeeStatusCell ()
@property (weak, nonatomic) IBOutlet UIButton *headBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *seeLabel;

@end

@implementation TFSeeStatusCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.headBtn.layer.cornerRadius = 15;
    self.headBtn.layer.masksToBounds = YES;
    self.headBtn.titleLabel.font = FONT(12);
    self.nameLabel.font = FONT(14);
    self.nameLabel.textColor = BlackTextColor;
    
    self.seeLabel.textAlignment = NSTextAlignmentCenter;
    self.seeLabel.textColor = LightBlackTextColor;
    self.seeLabel.font = FONT(12);
    
    self.timeLabel.textAlignment = NSTextAlignmentRight;
    self.timeLabel.textColor = ExtraLightBlackTextColor;
    self.timeLabel.font = FONT(12);
    self.headMargin = 54;
}

-(void)refreshSeeStatusCellWithModel:(id)model{
    
    NSDictionary *dict = model;
    
    [self.headBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:[dict valueForKey:@"employee_pic"]] forState:UIControlStateNormal completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        if (image) {
            [self.headBtn setTitle:@"" forState:UIControlStateNormal];
        }else{
            [self.headBtn setTitle:[HQHelper nameWithTotalName:[dict valueForKey:@"employee_name"]] forState:UIControlStateNormal];
            [self.headBtn setBackgroundImage:[HQHelper createImageWithColor:GreenColor] forState:UIControlStateNormal];
        }
    } ];
    
    self.nameLabel.text = [dict valueForKey:@"employee_name"];
    if ([[dict valueForKey:@"read_status"] isEqualToString:@"1"]) {
        self.seeLabel.textColor = GreenColor;
        self.seeLabel.text = @"已查看";
    }else{
        self.seeLabel.textColor = RedColor;
        self.seeLabel.text = @"未查看";
    }
    if (![[[dict valueForKey:@"read_time"] description] isEqualToString:@""]) {
        self.timeLabel.text = [HQHelper nsdateToTime:[[dict valueForKey:@"read_time"] longLongValue] formatStr:@"yyyy-MM-dd HH:mm"];
        self.timeLabel.hidden = NO;
    }else{
        self.timeLabel.hidden = YES;
    }
}

+ (instancetype)seeStatusCell
{
    return [[[NSBundle mainBundle] loadNibNamed:@"TFSeeStatusCell" owner:self options:nil] lastObject];
}

+ (TFSeeStatusCell *)seeStatusCellWithTableView:(UITableView *)tableView{
    
    static NSString *indentifier = @"TFSeeStatusCell";
    TFSeeStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [self seeStatusCell];
    }
    cell.topLine.hidden = YES;
    cell.bottomLine.hidden = NO;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
