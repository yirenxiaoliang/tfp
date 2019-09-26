//
//  TFManagerCell.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2017/12/28.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFManagerCell.h"

@interface TFManagerCell ()

@property (weak, nonatomic) IBOutlet UIButton *photoImg;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;

@end

@implementation TFManagerCell

- (void)awakeFromNib {

    [super awakeFromNib];
    
    self.photoImg.layer.cornerRadius = self.photoImg.width/2.0;
    self.photoImg.layer.masksToBounds = YES;
}

- (void)refreshManagerCellWithTableView:(TFManageItemModel *)model {

    if (![model.picture isEqualToString:@""] && model.picture != nil) {
        
        [self.photoImg sd_setBackgroundImageWithURL:[HQHelper URLWithString:model.picture] forState:UIControlStateNormal];
        [self.photoImg setTitle:@"" forState:UIControlStateNormal];
    }
    else {
    
        [self.photoImg sd_setBackgroundImageWithURL:nil forState:UIControlStateNormal];
        [self.photoImg setTitle:[HQHelper nameWithTotalName:model.employee_name] forState:UIControlStateNormal];
        [self.photoImg setTitleColor:WhiteColor forState:UIControlStateNormal];
        [self.photoImg setBackgroundColor:GreenColor];
    }
    
    self.nameLab.text = model.employee_name;
    
    
}

- (void)refreshSettingCellWithTableView:(TFSettingItemModel *)model {
    
    if (![model.picture isEqualToString:@""] && model.picture != nil) {
        
        [self.photoImg sd_setBackgroundImageWithURL:[HQHelper URLWithString:model.picture] forState:UIControlStateNormal];
        [self.photoImg setTitle:@"" forState:UIControlStateNormal];
    }
    else {
        
        [self.photoImg sd_setBackgroundImageWithURL:nil forState:UIControlStateNormal];
        [self.photoImg setTitle:[HQHelper nameWithTotalName:model.employee_name] forState:UIControlStateNormal];
        [self.photoImg setTitleColor:WhiteColor forState:UIControlStateNormal];
        [self.photoImg setBackgroundColor:GreenColor];
    }
    
    self.nameLab.text = model.employee_name;
    self.authlab.textColor = GreenColor;
    
}

+ (instancetype)TFManagerCell
{
    return [[[NSBundle mainBundle] loadNibNamed:@"TFManagerCell" owner:self options:nil] lastObject];
}



+ (instancetype)ManagerCellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"TFManagerCell";
    TFManagerCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [self TFManagerCell];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    
}

@end
