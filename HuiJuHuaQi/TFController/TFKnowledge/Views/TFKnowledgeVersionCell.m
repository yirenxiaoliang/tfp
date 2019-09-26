//
//  TFKnowledgeVersionCell.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/12/12.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFKnowledgeVersionCell.h"

@interface TFKnowledgeVersionCell()
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;

@end

@implementation TFKnowledgeVersionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.selectBtn setImage:IMG(@"没选中") forState:UIControlStateNormal];
    [self.selectBtn setImage:IMG(@"选中") forState:UIControlStateSelected];
    self.nameLabel.textColor = LightBlackTextColor;
    self.nameLabel.font = FONT(16);
    self.versionLabel.textColor = RGBColor(240, 137, 67);
    self.versionLabel.font = FONT(16);
    self.versionLabel.text = @"（当前版本）";
}

-(void)refreshCellWithModel:(TFKnowledgeVersionModel *)model{
    
    self.nameLabel.text = model.name;
    self.versionLabel.text = @"";
    self.select = [model.select isEqualToNumber:@1] ? YES : NO;
}

-(void)setSelect:(BOOL)select{
    _select = select;
    self.selectBtn.selected = select;
}

+(instancetype)knowledgeVersionCell{
    return [[[NSBundle mainBundle] loadNibNamed:@"TFKnowledgeVersionCell" owner:self options:nil] lastObject];
}

+(instancetype)knowledgeVersionCellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"TFKnowledgeVersionCell";
    
    TFKnowledgeVersionCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [self knowledgeVersionCell];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
