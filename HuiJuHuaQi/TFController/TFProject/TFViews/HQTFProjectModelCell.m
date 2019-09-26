//
//  HQTFProjectModelCell.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/3/23.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQTFProjectModelCell.h"

@interface HQTFProjectModelCell ()


@end

@implementation HQTFProjectModelCell


-(void)awakeFromNib{
    [super awakeFromNib];
    
    self.titleBtn.layer.cornerRadius = 2;
    self.titleBtn.layer.masksToBounds = YES;
    
    self.contentLabel.font = FONT(16);
    [self.selectBtn setImage:[UIImage imageNamed:@"选中"] forState:UIControlStateSelected];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.selectBtn.userInteractionEnabled = NO;
}
+ (instancetype)projectModelCell{
    return [[[NSBundle mainBundle] loadNibNamed:@"HQTFProjectModelCell" owner:self options:nil] lastObject];
}

+ (HQTFProjectModelCell *)projectModelCellWithTableView:(UITableView *)tableView
{
    static NSString *indentifier = @"HQTFProjectModelCell";
    HQTFProjectModelCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    cell.topLine.hidden = YES;
    cell.bottomLine.hidden = YES;
    if (!cell) {
        cell = [self projectModelCell];
    }
    return cell;
}

-(void)refreshProjectModelCellWithModel:(TFProjectCatagoryItemModel *)model{
    
    
    self.contentLabel.text = model.categoryName;
    
    switch ([model.id integerValue]) {
        case 100:
        {
            [self.titleBtn setBackgroundImage:[UIImage imageNamed:@"项目协作1"] forState:UIControlStateNormal];
            [self.titleBtn setBackgroundImage:[UIImage imageNamed:@"项目协作1"] forState:UIControlStateHighlighted];
            [self.titleBtn setTitle:@"" forState:UIControlStateNormal];
        }
            break;
        case 200:
        {
            [self.titleBtn setBackgroundImage:[UIImage imageNamed:@"销售1"] forState:UIControlStateNormal];
            [self.titleBtn setBackgroundImage:[UIImage imageNamed:@"销售1"] forState:UIControlStateHighlighted];
            [self.titleBtn setTitle:@"" forState:UIControlStateNormal];
        }
            break;
        case 300:
        {
            [self.titleBtn setBackgroundImage:[UIImage imageNamed:@"生产1"] forState:UIControlStateNormal];
            [self.titleBtn setBackgroundImage:[UIImage imageNamed:@"生产1"] forState:UIControlStateHighlighted];
            [self.titleBtn setTitle:@"" forState:UIControlStateNormal];
        }
            break;
        case 400:
        {
            [self.titleBtn setBackgroundImage:[UIImage imageNamed:@"设计研发1"] forState:UIControlStateNormal];
            [self.titleBtn setBackgroundImage:[UIImage imageNamed:@"设计研发1"] forState:UIControlStateHighlighted];
            [self.titleBtn setTitle:@"" forState:UIControlStateNormal];
        }
            break;
        case 500:
        {
            [self.titleBtn setBackgroundImage:[UIImage imageNamed:@"互联网1"] forState:UIControlStateNormal];
            [self.titleBtn setBackgroundImage:[UIImage imageNamed:@"互联网1"] forState:UIControlStateHighlighted];
            [self.titleBtn setTitle:@"" forState:UIControlStateNormal];
        }
            break;
            
        default:
        {
//            [self.titleBtn setBackgroundImage:[HQHelper createImageWithColor:RedColor] forState:UIControlStateNormal];
//            [self.titleBtn setBackgroundImage:[HQHelper createImageWithColor:RedColor] forState:UIControlStateHighlighted];
//            [self.titleBtn setTitle:@"自定义" forState:UIControlStateNormal];
            
            [self.titleBtn setBackgroundImage:[UIImage imageNamed:@"项目协作1"] forState:UIControlStateNormal];
            [self.titleBtn setBackgroundImage:[UIImage imageNamed:@"项目协作1"] forState:UIControlStateHighlighted];
            [self.titleBtn setTitle:@"" forState:UIControlStateNormal];
        }
            break;
    }
}

-(void)setIsSelected:(BOOL)isSelected{
    _isSelected = isSelected;
    
    self.selectBtn.selected = isSelected;
    if (isSelected) {
        
        self.contentLabel.textColor = GreenColor;
    }else{
        
        self.contentLabel.textColor = BlackTextColor;
    }
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
