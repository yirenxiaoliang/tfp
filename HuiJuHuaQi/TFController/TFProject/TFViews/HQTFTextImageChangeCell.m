//
//  HQTFTextImageChangeCell.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/2/27.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQTFTextImageChangeCell.h"

@interface HQTFTextImageChangeCell ()


@end

@implementation HQTFTextImageChangeCell


-(void)awakeFromNib{
    [super awakeFromNib];
    
    self.leftBtn.titleLabel.font = FONT(14);
    [self.leftBtn setTitleColor:ExtraLightBlackTextColor forState:UIControlStateNormal];
    [self.leftBtn setTitleColor:ExtraLightBlackTextColor forState:UIControlStateHighlighted];
    
    self.middleBtn.titleLabel.font = FONT(16);
    [self.middleBtn setTitleColor:LightBlackTextColor forState:UIControlStateNormal];
    [self.middleBtn setTitleColor:LightBlackTextColor forState:UIControlStateHighlighted];
    
    self.rightBtn.titleLabel.font = FONT(16);
    [self.rightBtn setTitleColor:GreenColor forState:UIControlStateNormal];
    [self.rightBtn setTitleColor:GreenColor forState:UIControlStateHighlighted];
    
    self.leftBtn.userInteractionEnabled = NO;
    self.middleBtn.userInteractionEnabled = NO;
    self.rightBtn.userInteractionEnabled = NO;
    
}

-(void)setTitle:(NSString *)title{
    _title = title;
    
    [self.leftBtn setTitle:title forState:UIControlStateHighlighted];
    [self.leftBtn setTitle:title forState:UIControlStateNormal];
}

-(void)setTitleImg:(NSString *)titleImg{
    
    _titleImg = titleImg;
    
    [self.leftBtn setImage:[UIImage imageNamed:titleImg] forState:UIControlStateNormal];
    [self.leftBtn setImage:[UIImage imageNamed:titleImg] forState:UIControlStateHighlighted];
    
}

-(void)setTitleColor:(UIColor *)titleColor{
    
    _titleColor = titleColor;
    [self.leftBtn setTitleColor:titleColor forState:UIControlStateNormal];
    [self.leftBtn setTitleColor:titleColor forState:UIControlStateHighlighted];
}

-(void)setContent:(NSString *)content{
    _content = content;
    
    [self.middleBtn setTitle:content forState:UIControlStateHighlighted];
    [self.middleBtn setTitle:content forState:UIControlStateNormal];
}
-(void)setContentColor:(UIColor *)contentColor{
    _contentColor = contentColor;
    
    [self.middleBtn setTitleColor:contentColor forState:UIControlStateHighlighted];
    [self.middleBtn setTitleColor:contentColor forState:UIControlStateNormal];
    
}

-(void)setDesc:(NSString *)desc{
    _desc = desc;
    
    [self.rightBtn setTitle:desc forState:UIControlStateHighlighted];
    [self.rightBtn setTitle:desc forState:UIControlStateNormal];
}

-(void)setDescColor:(UIColor *)descColor{
    _descColor = descColor;
    
    [self.rightBtn setTitleColor:descColor forState:UIControlStateHighlighted];
    [self.rightBtn setTitleColor:descColor forState:UIControlStateNormal];
}

-(void)setDescImg:(NSString *)descImg{
    
    _descImg = descImg;
    
    [self.rightBtn setImage:[UIImage imageNamed:descImg] forState:UIControlStateNormal];
    [self.rightBtn setImage:[UIImage imageNamed:descImg] forState:UIControlStateHighlighted];
    
}

+ (instancetype)textImageChangeCell{
    return [[[NSBundle mainBundle] loadNibNamed:@"HQTFTextImageChangeCell" owner:self options:nil] lastObject];
}

+ (HQTFTextImageChangeCell *)textImageChangeCellWithTableView:(UITableView *)tableView
{
    static NSString *indentifier = @"HQTFTextImageChangeCell";
    HQTFTextImageChangeCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [self textImageChangeCell];
    }
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
