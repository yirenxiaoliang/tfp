//
//  TFPeopleManageDepartmentCell.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/4/22.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFPeopleManageDepartmentCell.h"

@interface TFPeopleManageDepartmentCell ()

@property (weak, nonatomic) IBOutlet UIButton *triImage;

@property (weak, nonatomic) IBOutlet UILabel *departmentLabel;
@property (weak, nonatomic) IBOutlet UILabel *peopleNumLabel;

@end

@implementation TFPeopleManageDepartmentCell


-(void)awakeFromNib{
    [super awakeFromNib];
    
    [self.triImage setImage:[UIImage imageNamed:@"departNoOpen"] forState:UIControlStateNormal];
    [self.triImage setImage:[UIImage imageNamed:@"departNoOpen"] forState:UIControlStateHighlighted];
    [self.triImage setImage:[UIImage imageNamed:@"departOpen"] forState:UIControlStateSelected];
    self.triImage.userInteractionEnabled = NO;
    
    self.departmentLabel.font = FONT(16);
    self.departmentLabel.textColor = LightBlackTextColor;
    
    self.peopleNumLabel.font = FONT(14);
    self.peopleNumLabel.textColor = LightBlackTextColor;
}


-(void)refreshPeopleManageDepartmentCellWithModel:(HQDepartmentModel *)model{

    self.triImage.selected = ([model.open isEqualToNumber:@0] || model == nil)?NO:YES;
    
    self.departmentLabel.text = model.departmentName;
    

    if (model.count) {
        
        self.peopleNumLabel.text = [NSString stringWithFormat:@"(%ld)",[model.count integerValue]];
    }else{
        
        if (model.employees.count) {
            self.peopleNumLabel.text = [NSString stringWithFormat:@"(%ld)",model.employees.count];
        }else{
            self.peopleNumLabel.text = @"(0)";
        }
    }
}


+ (instancetype)peopleManageDepartmentCell{
    return [[[NSBundle mainBundle] loadNibNamed:@"TFPeopleManageDepartmentCell" owner:self options:nil] lastObject];
}

+ (TFPeopleManageDepartmentCell *)peopleManageDepartmentCellWithTableView:(UITableView *)tableView
{
    static NSString *indentifier = @"TFPeopleManageDepartmentCell";
    TFPeopleManageDepartmentCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [self peopleManageDepartmentCell];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.topLine.hidden = NO;
    cell.bottomLine.hidden = YES;
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
