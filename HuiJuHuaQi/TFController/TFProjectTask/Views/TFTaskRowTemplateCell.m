//
//  TFTaskRowTemplateCell.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/5/3.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFTaskRowTemplateCell.h"

@interface TFTaskRowTemplateCell()

@end

@implementation TFTaskRowTemplateCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.nameLabel.textColor = LightBlackTextColor;
    self.nameLabel.font = FONT(16);
    self.templateLabel.textColor = ExtraLightBlackTextColor;
    self.templateLabel.font = FONT(14);
    self.templateLabel.layer.cornerRadius = 4;
    self.templateLabel.layer.masksToBounds = YES;
    
    self.nameLabel.text = @"";
    self.templateLabel.text = @"";
    
    [self.arrowBtn setImage:[UIImage imageNamed:@"下一级浅灰"] forState:UIControlStateNormal];
    [self.arrowBtn setImage:[UIImage imageNamed:@"下一级浅灰"] forState:UIControlStateHighlighted];
    [self.arrowBtn setImage:[UIImage imageNamed:@"清除"] forState:UIControlStateSelected];
    [self.arrowBtn addTarget:self action:@selector(enterClicked:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)enterClicked:(UIButton *)button{
    
    if ([self.delegate respondsToSelector:@selector(taskRowTemplateCellDidClickedEnterButton:)]) {
        [self.delegate taskRowTemplateCellDidClickedEnterButton:button];
    }
}

+ (instancetype)TFTaskRowTemplateCell
{
    return [[[NSBundle mainBundle] loadNibNamed:@"TFTaskRowTemplateCell" owner:self options:nil] lastObject];
}

+ (TFTaskRowTemplateCell *)taskRowTemplateCellWithTableView:(UITableView *)tableView
{
    static NSString *indentifier = @"TFTaskRowTemplateCell";
    TFTaskRowTemplateCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [self TFTaskRowTemplateCell];
    }
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
