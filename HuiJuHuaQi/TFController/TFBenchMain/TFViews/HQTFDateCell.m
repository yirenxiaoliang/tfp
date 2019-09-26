//
//  HQTFDateCell.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/2/14.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQTFDateCell.h"
#import "NSDate+NSString.h"


@interface HQTFDateCell ()

@property (weak, nonatomic) IBOutlet UIButton *dateButton;

@end


@implementation HQTFDateCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.dateButton.transform = CGAffineTransformMakeRotation(M_PI/2);
    [self.dateButton setBackgroundImage:[HQHelper createImageWithColor:WhiteColor] forState:UIControlStateNormal];
    [self.dateButton setBackgroundImage:[HQHelper createImageWithColor:WhiteColor] forState:UIControlStateHighlighted];
    [self.dateButton setBackgroundImage:[HQHelper createImageWithColor:HexAColor(0xff6260, 1)] forState:UIControlStateSelected];
    self.dateButton.layer.cornerRadius = 15;
    self.dateButton.layer.masksToBounds = YES;
    [self.dateButton setTitleColor:WhiteColor forState:UIControlStateSelected];
    self.dateButton.titleLabel.font = FONT(16);
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.dateButton.userInteractionEnabled = NO;
    
}
+ (instancetype)dateCell
{
    return [[[NSBundle mainBundle] loadNibNamed:@"HQTFDateCell" owner:self options:nil] lastObject];
}

- (void)setDate:(NSDate *)date{
    _date = date;
    
    [self.dateButton setTitle:[[date getDay] substringToIndex:2] forState:UIControlStateNormal];
    [self.dateButton setTitle:[[date getDay] substringToIndex:2] forState:UIControlStateHighlighted];
    [self.dateButton setTitle:[[date getDay] substringToIndex:2] forState:UIControlStateSelected];
}

-(void)setRedSelected:(BOOL)redSelected{
    _redSelected = redSelected;
    
    self.dateButton.selected = redSelected;
    
}

+ (HQTFDateCell *)dateCellWithTableView:(UITableView *)tableView
{
    static NSString *indentifier = @"HQTFDateCell";
    HQTFDateCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [self dateCell];
    }
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
