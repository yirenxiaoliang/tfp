//
//  TFMoveSelectCell.m
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/5/17.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFMoveSelectCell.h"

@interface TFMoveSelectCell ()


@property (nonatomic, strong) TFProjectNodeModel *model;

@end

@implementation TFMoveSelectCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+(instancetype)moveSelectCell{
    return [[[NSBundle mainBundle] loadNibNamed:@"TFMoveSelectCell" owner:self options:nil] lastObject];
}
- (IBAction)selectClicked:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(moveSelectCellDidClickedSelectWithModel:)]) {
        [self.delegate moveSelectCellDidClickedSelectWithModel:self.model];
    }
}

-(void)refreshMoveSelectCellWithModel:(TFProjectNodeModel *)model{
    self.model = model;
    if ([model.select isEqualToNumber:@1]) {
        self.selectBtn.selected = YES;
    }else{
        self.selectBtn.selected = NO;
    }
    if (model.child.count == 0) {
        self.arrow.hidden = YES;
    }else{
        self.arrow.hidden = NO;
    }
    self.nameLabel.text = model.node_name;
}

+(instancetype)moveSelectCellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"TFMoveSelectCell";
    TFMoveSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [TFMoveSelectCell moveSelectCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.layer.masksToBounds = YES;
    }
    return cell;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
