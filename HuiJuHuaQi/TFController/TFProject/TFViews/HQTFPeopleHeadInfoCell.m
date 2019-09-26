//
//  HQTFPeopleHeadInfoCell.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/2/24.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQTFPeopleHeadInfoCell.h"

@interface HQTFPeopleHeadInfoCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *taskLabel;
@property (weak, nonatomic) IBOutlet UIButton *statusImage;

@end

@implementation HQTFPeopleHeadInfoCell

-(void)awakeFromNib{
    [super awakeFromNib];
    self.headImage.layer.cornerRadius = 3;
    self.headImage.layer.masksToBounds = YES;
    self.nameLabel.textColor = BlackTextColor;
    self.nameLabel.font = FONT(18);
    
    self.taskLabel.textColor = ExtraLightBlackTextColor;
    self.taskLabel.font = FONT(14);
    self.headImage.contentMode = UIViewContentModeScaleAspectFill;
}

- (void)refreshPeopleHeadInfoCellWithModel:(TFProjectPricipalModel *)model{
    
    self.nameLabel.text = model.employeeName;
    
    if ([model.isCreator isEqualToNumber:@1]) {
        self.statusImage.hidden = NO;
    }else{
        self.statusImage.hidden = YES;
    }
    self.taskLabel.text = [NSString stringWithFormat:@"任务有%ld个",[model.taskCount integerValue]];
    
    [self.headImage sd_setImageWithURL:[HQHelper URLWithString:model.photograph] placeholderImage:PlaceholderHeadImage];
    
    
}


+ (instancetype)peopleHeadInfoCell{
    return [[[NSBundle mainBundle] loadNibNamed:@"HQTFPeopleHeadInfoCell" owner:self options:nil] lastObject];
}

+ (HQTFPeopleHeadInfoCell *)peopleHeadInfoCellWithTableView:(UITableView *)tableView
{
    static NSString *indentifier = @"HQTFPeopleHeadInfoCell";
    HQTFPeopleHeadInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [self peopleHeadInfoCell];
    }
    return cell;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
