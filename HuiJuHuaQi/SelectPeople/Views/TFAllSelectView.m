//
//  TFAllSelectView.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/1/5.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFAllSelectView.h"

@interface TFAllSelectView ()

@end

@implementation TFAllSelectView

-(void)awakeFromNib{
    [super awakeFromNib];
    
    [self.allSelectBtn setTitle:@"  全选" forState:UIControlStateNormal];
    [self.allSelectBtn setTitle:@"  全选" forState:UIControlStateHighlighted];
    [self.allSelectBtn setTitle:@"  全选" forState:UIControlStateSelected];
    
    [self.selectSub setTitle:@"  包含下级部门" forState:UIControlStateNormal];
    [self.selectSub setTitle:@"  包含下级部门" forState:UIControlStateHighlighted];
    [self.selectSub setTitle:@"  包含下级部门" forState:UIControlStateSelected];
    
    
    [self.allSelectBtn setImage:IMG(@"没选中") forState:UIControlStateNormal];
    [self.allSelectBtn setImage:IMG(@"选中了") forState:UIControlStateSelected];
    
    [self.selectSub setImage:IMG(@"没选中") forState:UIControlStateNormal];
    [self.selectSub setImage:IMG(@"选中了") forState:UIControlStateSelected];
    
    [self.allSelectBtn setTitleColor:BlackTextColor forState:UIControlStateNormal];
    [self.allSelectBtn setTitleColor:BlackTextColor forState:UIControlStateSelected];
    [self.allSelectBtn setTitleColor:BlackTextColor forState:UIControlStateHighlighted];
    
    [self.selectSub setTitleColor:BlackTextColor forState:UIControlStateNormal];
    [self.selectSub setTitleColor:BlackTextColor forState:UIControlStateSelected];
    [self.selectSub setTitleColor:BlackTextColor forState:UIControlStateHighlighted];
    
    self.numLabel.textColor = GreenColor;
    self.numLabel.font = FONT(14);
    
    self.allSelectBtn.titleLabel.font = FONT(15);
    self.selectSub.titleLabel.font = FONT(15);
    self.selectSub.hidden = YES;
    
}
- (IBAction)selectSubClick:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    
    if ([self.delegate respondsToSelector:@selector(allSelectViewDidClickedSelectSubBtn:)]) {
        [self.delegate allSelectViewDidClickedSelectSubBtn:sender];
    }
    
}

- (IBAction)allSelectBtnClicked:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    
    if ([self.delegate respondsToSelector:@selector(allSelectViewDidClickedAllSelectBtn:)]) {
        [self.delegate allSelectViewDidClickedAllSelectBtn:sender];
    }
}


+ (instancetype)allSelectView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"TFAllSelectView" owner:self options:nil] lastObject];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
