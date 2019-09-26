//
//  TFPositionManageCell.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/4/22.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFPositionManageCell.h"

@interface TFPositionManageCell()
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (weak, nonatomic) IBOutlet UIButton *editBtn;

/** type 0:选择 1：管理 */
@property (nonatomic, assign) NSInteger type;

/** model */
@property (nonatomic, strong) TFPositionModel *positionModel;
/** model */
@property (nonatomic, strong) HQDepartmentModel *departmentModel;

@end

@implementation TFPositionManageCell

-(void)awakeFromNib{
    [super awakeFromNib];
    
    self.nameLabel.textColor = LightBlackTextColor;
    self.nameLabel.font = FONT(16);
    
    [self.editBtn setImage:[UIImage imageNamed:@"编辑20"] forState:UIControlStateNormal];
    [self.editBtn setImage:[UIImage imageNamed:@"编辑20"] forState:UIControlStateHighlighted];
    
    [self.deleteBtn setImage:[UIImage imageNamed:@"回收站20"] forState:UIControlStateNormal];
    [self.deleteBtn setImage:[UIImage imageNamed:@"回收站20"] forState:UIControlStateHighlighted];
}
- (IBAction)deleteBtnClicked:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(positionManageCellDidDeleteBtnWithPositionModel:)]) {
        [self.delegate positionManageCellDidDeleteBtnWithPositionModel:self.positionModel];
    }
    
    if ([self.delegate respondsToSelector:@selector(positionManageCellDidDeleteBtnWithDepartmentModel:)]) {
        [self.delegate positionManageCellDidDeleteBtnWithDepartmentModel:self.departmentModel];
    }
    
}
- (IBAction)editBtnClicked:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(positionManageCellDidEditBtnWithPositionModel:)]) {
        [self.delegate positionManageCellDidEditBtnWithPositionModel:self.positionModel];
    }
    if ([self.delegate respondsToSelector:@selector(positionManageCellDidEditBtnWithDepartmentModel:)]) {
        [self.delegate positionManageCellDidEditBtnWithDepartmentModel:self.departmentModel];
    }
}

-(void)refreshPositionManageCellWithPositionModel:(TFPositionModel *)model{
    _positionModel = model;
    
    self.nameLabel.text = model.name;
}
- (void)refreshPositionManageCellWithDepartmentModel:(HQDepartmentModel *)model{
    _departmentModel = model;
    self.nameLabel.text = model.departmentName;
    
    if (self.type == 1) {
        if (!model.parentDepartmentId || [model.parentDepartmentId isEqualToNumber:@0]) {
            
            self.editBtn.hidden = YES;
            self.deleteBtn.hidden = YES;
        }else{
            self.editBtn.hidden = NO;
            self.deleteBtn.hidden = NO;
        }
    }
}


-(void)setType:(NSInteger)type{
    _type = type;
    
    switch (type) {
        case 0:
        {
            self.editBtn.hidden = YES;
            self.deleteBtn.hidden = YES;
            [self.deleteBtn setImage:[HQHelper createImageWithColor:ClearColor] forState:UIControlStateNormal];
            [self.deleteBtn setImage:[HQHelper createImageWithColor:ClearColor]  forState:UIControlStateHighlighted];
            [self.deleteBtn setImage:[UIImage imageNamed:@"完成30"] forState:UIControlStateSelected];
        }
            break;
        case 1:
        {
            self.editBtn.hidden = NO;
            self.deleteBtn.hidden = NO;
        }
            break;
            
        default:
            break;
    }
}

-(void)setSelect:(BOOL)select{
    _select = select;
    
    if (self.type == 0) {
        self.deleteBtn.userInteractionEnabled = NO;
        self.deleteBtn.hidden = NO;
        self.deleteBtn.selected = select;
    }
}

+ (instancetype)positionManageCell{
    return [[[NSBundle mainBundle] loadNibNamed:@"TFPositionManageCell" owner:self options:nil] lastObject];
}

+ (TFPositionManageCell *)positionManageCellWithTableView:(UITableView *)tableView withType:(NSInteger)type
{
    static NSString *indentifier = @"TFPositionManageCell";
    TFPositionManageCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [self positionManageCell];
    }
    
    cell.type = type;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.topLine.hidden = YES;
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
