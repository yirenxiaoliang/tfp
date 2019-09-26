//
//  TFKnowledgeFilterItemCell.m
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/1/24.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFKnowledgeFilterItemCell.h"

@interface TFKnowledgeFilterItemCell ()
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet UIImageView *enterImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation TFKnowledgeFilterItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.nameLabel.textColor = LightBlackTextColor;
    self.enterImage.image = IMG(@"enterDown");
    
}
- (IBAction)selectClicked:(id)sender {
    if ([self.delegate respondsToSelector:@selector(filterItemCellDidSelectBtn:)]) {
        [self.delegate filterItemCellDidSelectBtn:self];
    }
}

+(instancetype)knowledgeFilterItemCell{
    return [[[NSBundle mainBundle] loadNibNamed:@"TFKnowledgeFilterItemCell" owner:self options:nil] lastObject];
}

-(void)refreshKnowledgeFilterItemCellWithName:(TFCategoryModel *)model{
    
    self.nameLabel.text = model.name;
    self.selectBtn.selected = [model.select isEqualToNumber:@1]?YES:NO;
    if ([model.show isEqualToNumber:@1]) {
        self.enterImage.image = IMG(@"enterUp");
    }else{
        self.enterImage.image = IMG(@"enterDown");
    }
    self.enterImage.hidden = YES;
    self.backgroundColor = WhiteColor;
    self.headMargin = 0;
    self.bottomLine.hidden = NO;
    self.nameLabel.textColor = ExtraLightBlackTextColor;
}

-(void)refreshKnowledgeFilterItemCellWithCategory:(TFCategoryModel *)model{
    self.nameLabel.text = model.name;
    self.selectBtn.selected = [model.select isEqualToNumber:@1]?YES:NO;
    if ([model.show isEqualToNumber:@1]) {
        self.enterImage.image = IMG(@"enterUp");
    }else{
        self.enterImage.image = IMG(@"enterDown");
    }
    self.enterImage.hidden = NO;
    self.backgroundColor = WhiteColor;
    self.headMargin = 0;
    self.bottomLine.hidden = NO;
    self.nameLabel.textColor = ExtraLightBlackTextColor;
}

-(void)refreshKnowledgeFilterItemCellWithLabel:(TFCategoryModel *)model{
    
    self.nameLabel.text = model.name;
    self.selectBtn.selected = [model.select isEqualToNumber:@1]?YES:NO;
    if ([model.show isEqualToNumber:@1]) {
        self.enterImage.image = IMG(@"enterUp");
    }else{
        self.enterImage.image = IMG(@"enterDown");
    }
    self.enterImage.hidden = YES;
    self.backgroundColor = HexColor(0xf7f7f7);
    self.headMargin = 55;
    self.bottomLine.hidden = NO;
    self.nameLabel.textColor = GrayTextColor;
}

+(instancetype)knowledgeFilterItemCellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"TFKnowledgeFilterItemCell";
    TFKnowledgeFilterItemCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [self knowledgeFilterItemCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
