//
//  TFProjectLabelCell.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/5/3.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFProjectLabelCell.h"


@interface TFProjectLabelCell()

@property (weak, nonatomic) IBOutlet UIImageView *labelImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelW;

@end


@implementation TFProjectLabelCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.nameLabel.textColor = LightBlackTextColor;
    self.nameLabel.font = FONT(16);
    
    self.labelImage.image = [UIImage imageNamed:@"标签切图"];
    
    [self.deleteBtn setImage:[UIImage imageNamed:@"删除"] forState:UIControlStateNormal];
    [self.deleteBtn setImage:[UIImage imageNamed:@"删除"] forState:UIControlStateHighlighted];
    
    [self.selectBtn addTarget:self action:@selector(selectDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.deleteBtn addTarget:self action:@selector(deleteDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)refreshProjectLabelWithModel:(TFProjectLabelModel *)model{
    
    self.nameLabel.text = model.name;
    
//    self.labelImage.backgroundColor = [RGBColor(arc4random_uniform(255), arc4random_uniform(255), arc4random_uniform(255))];
    self.labelImage.backgroundColor = [HQHelper colorWithHexString:model.colour];
    
    if ([model.select isEqualToNumber:@1]) {
        self.selectBtn.selected = YES;
    }else{
        self.selectBtn.selected = NO;
    }
}


- (void)selectDidClicked:(UIButton *)button{
    
    button.selected = !button.selected;
    if ([self.delegate respondsToSelector:@selector(projectLabelCellDidClickedSelectBtn:)]) {
        [self.delegate projectLabelCellDidClickedSelectBtn:button];
    }
}
- (void)deleteDidClicked:(UIButton *)button{
    
    if ([self.delegate respondsToSelector:@selector(projectLabelCellDidClickedDeleteBtn:)]) {
        [self.delegate projectLabelCellDidClickedDeleteBtn:button];
    }
}


+ (instancetype)TFProjectLabelCell
{
    return [[[NSBundle mainBundle] loadNibNamed:@"TFProjectLabelCell" owner:self options:nil] lastObject];
}

+ (TFProjectLabelCell *)projectLabelCellWithTableView:(UITableView *)tableView
{
    static NSString *indentifier = @"TFProjectLabelCell";
    TFProjectLabelCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [self TFProjectLabelCell];
    }
    return cell;
}

-(void)setType:(NSInteger)type{
    _type = type;
    
    if (type == 0) {
        
        self.selectBtn.hidden = YES;
        self.deleteBtn.hidden = NO;
        self.labelW.constant = 0;
    }else{
        
        self.deleteBtn.hidden = YES;
        self.selectBtn.hidden = NO;
        self.labelW.constant = 30;
    }
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
