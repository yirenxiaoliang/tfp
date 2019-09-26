//
//  TFPeopleManagePeopleCell.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/4/22.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFPeopleManagePeopleCell.h"
#import "UIButton+WebCache.h"

@interface TFPeopleManagePeopleCell ()

@property (weak, nonatomic) IBOutlet UIButton *headBtn;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UIButton *positionBtn;

@property (weak, nonatomic) IBOutlet UIButton *enterBtn;

@end

@implementation TFPeopleManagePeopleCell


-(void)awakeFromNib{
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.headBtn.layer.cornerRadius = 2;
    self.headBtn.layer.masksToBounds = YES;
    self.headBtn.userInteractionEnabled = NO;
    
    self.nameLabel.font = FONT(16);
    self.nameLabel.textColor = BlackTextColor;
    
    self.positionBtn.titleLabel.font = FONT(12);
    [self.positionBtn setTitleColor:LightGrayTextColor forState:UIControlStateNormal];
    [self.positionBtn setTitleColor:LightGrayTextColor forState:UIControlStateHighlighted];
    self.positionBtn.userInteractionEnabled = NO;
    
    [self.enterBtn setImage:[HQHelper createImageWithColor:ClearColor] forState:UIControlStateHighlighted];
    [self.enterBtn setImage:[HQHelper createImageWithColor:ClearColor] forState:UIControlStateNormal];
    [self.enterBtn setImage:[UIImage imageNamed:@"完成30"] forState:UIControlStateSelected];
    self.enterBtn.userInteractionEnabled = NO;
    
    self.positionBtn.imageView.layer.cornerRadius = 4;
    self.positionBtn.imageView.layer.masksToBounds = YES;
}


-(void)refreshPeopleManagePeopleCellWithModel:(HQEmployModel *)model type:(NSInteger)type{
    
    
    //[self.headBtn setImage:[UIImage imageNamed:@"微信"] forState:UIControlStateNormal];
    [self.headBtn sd_setBackgroundImageWithURL:[HQHelper URLWithString:model.photograph] forState:UIControlStateNormal placeholderImage:PlaceholderHeadImage];
    [self.headBtn sd_setBackgroundImageWithURL:[HQHelper URLWithString:model.photograph] forState:UIControlStateHighlighted placeholderImage:PlaceholderHeadImage];
    
    self.enterBtn.selected = ([model.selectState isEqualToNumber:@0] || model.selectState == nil)?NO:YES;
    
    self.nameLabel.text = model.employeeName;
    
    /** 角色类型0其他1所有者2管理员3成员4访客 */
    NSString *role = @"";
    switch ([model.roleType integerValue]) {
        case 0:
            role = @"";
            break;
        case 1:
            role = @"所有者";
            break;
        case 2:
            role = @"管理员";
            break;
        case 3:
            role = @"成员";
            break;
        case 4:
            role = @"访客";
            break;
            
        default:
            break;
    }

    if ([model.employeeStatus isEqualToNumber:@0] || model.employeeStatus == nil) {
        
        [self.positionBtn setImage:[HQHelper createImageWithColor:RedColor size:(CGSize){8,8}] forState:UIControlStateNormal];
        [self.positionBtn setImage:[HQHelper createImageWithColor:RedColor size:(CGSize){8,8}] forState:UIControlStateHighlighted];
        
        if (type == 0) {
            [self.positionBtn setTitle:[NSString stringWithFormat:@"  %@",TEXT(model.position)] forState:UIControlStateHighlighted];
            [self.positionBtn setTitle:[NSString stringWithFormat:@"  %@",TEXT(model.position)] forState:UIControlStateNormal];
        }else{
            
            [self.positionBtn setTitle:[NSString stringWithFormat:@"  %@",TEXT(role)] forState:UIControlStateHighlighted];
            [self.positionBtn setTitle:[NSString stringWithFormat:@"  %@",TEXT(role)] forState:UIControlStateNormal];
        }
        
    }else{
        
        [self.positionBtn setImage:[HQHelper createImageWithColor:ClearColor size:(CGSize){0,0}] forState:UIControlStateNormal];
        [self.positionBtn setImage:[HQHelper createImageWithColor:ClearColor size:(CGSize){0,0}] forState:UIControlStateHighlighted];
        
        if (type == 0) {
            [self.positionBtn setTitle:TEXT(model.position) forState:UIControlStateHighlighted];
            [self.positionBtn setTitle:TEXT(model.position) forState:UIControlStateNormal];
        }else{
            
            [self.positionBtn setTitle:TEXT(role) forState:UIControlStateHighlighted];
            [self.positionBtn setTitle:TEXT(role) forState:UIControlStateNormal];
        }
       
    }
    
    
}

+ (instancetype)peopleManagePeopleCell{
    return [[[NSBundle mainBundle] loadNibNamed:@"TFPeopleManagePeopleCell" owner:self options:nil] lastObject];
}

+ (TFPeopleManagePeopleCell *)peopleManagePeopleCellWithTableView:(UITableView *)tableView
{
    static NSString *indentifier = @"TFPeopleManagePeopleCell";
    TFPeopleManagePeopleCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [self peopleManagePeopleCell];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.topLine.hidden = YES;
    cell.headMargin = 85;
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
