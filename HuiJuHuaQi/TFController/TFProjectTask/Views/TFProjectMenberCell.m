//
//  TFProjectMenberCell.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/4/12.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFProjectMenberCell.h"

@interface TFProjectMenberCell ()

@property (weak, nonatomic) IBOutlet UIImageView *headImg;

@end

@implementation TFProjectMenberCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.headImage.layer.cornerRadius = 22.5;
    self.headImage.layer.masksToBounds = YES;
    self.nameLabel.textColor = BlackTextColor;
    self.nameLabel.font = FONT(16);
    self.powerLabel.textColor = HexColor(0x3689e9);
    self.powerLabel.font = FONT(16);
    self.headImg.hidden = YES;
}

-(void)setType:(NSInteger)type{
    _type = type;
    
    if (self.type == 0) {
        self.powerLabel.hidden = NO;
    }else{
        self.powerLabel.hidden = YES;
    }
}

+ (instancetype)projectMenberCell
{
    return [[[NSBundle mainBundle] loadNibNamed:@"TFProjectMenberCell" owner:self options:nil] lastObject];
}


+ (instancetype)projectMenberCellWithTableView:(UITableView *)tableView
{
    static NSString *indentifier = @"TFProjectMenberCell";
    TFProjectMenberCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [self projectMenberCell];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.layer.masksToBounds = YES;
    return cell;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
