
//
//  TFCRMSearchView.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/8/11.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFCRMSearchView.h"

@interface TFCRMSearchView ()

@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *numberHeadW;

@end

@implementation TFCRMSearchView

-(void)awakeFromNib{
    [super awakeFromNib];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(arrowClick)];
    
    [self.bgView addGestureRecognizer:tap];
    
    [self.filterBtn addTarget:self action:@selector(filterBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    self.bgView.backgroundColor = WhiteColor;
    self.titleLabel.font = FONT(14);
    self.titleLabel.textColor = ExtraLightBlackTextColor;
    self.numLabel.font = FONT(10);
    self.numLabel.backgroundColor = GreenColor;
    self.numLabel.layer.cornerRadius = 8;
    self.numLabel.layer.masksToBounds = YES;
    self.numLabel.textColor = WhiteColor;
    
//    self.layer.borderColor = CellSeparatorColor.CGColor;
//    self.layer.borderWidth = 0.5;
    
    [self.arrowImage setImage:[UIImage imageNamed:@"下拉"]];
    [self.filterBtn setImage:[UIImage imageNamed:@"状态"] forState:UIControlStateNormal];
    [self.filterBtn setImage:[UIImage imageNamed:@"状态"] forState:UIControlStateHighlighted];
    self.arrowImage.contentMode = UIViewContentModeCenter;
}


-(void)refreshSearchViewWithTitle:(NSString *)title number:(NSInteger)number{
    
    self.titleLabel.text = title;
    
    if (number == 0) {
        self.numLabel.hidden = YES;
        self.numLabel.text = @"";
        self.numberHeadW.constant = 0;
    }else{
        self.numberHeadW.constant = 8;
        self.numLabel.hidden = NO;
        self.numLabel.text = [NSString stringWithFormat:@"  %ld条  ",number];
    }
    
}


+(instancetype)CRMSearchView{
    
    return [[[NSBundle mainBundle] loadNibNamed:@"TFCRMSearchView" owner:nil options:nil] lastObject];
}

- (void)filterBtnClicked{
    
    self.open = NO;
    self.show = !self.show;
    
}

- (void)arrowClick{
    
    self.open = !self.open;
    self.show = NO;
}

-(void)setOpen:(BOOL)open{
    _open = open;
    
    if (open) {
        
        [self.arrowImage setImage:[UIImage imageNamed:@"展开"]];
    }else{
        
        [self.arrowImage setImage:[UIImage imageNamed:@"下拉"]];
    }
    if ([self.delegate respondsToSelector:@selector(crmSearchViewDidClicked:)]) {
        [self.delegate crmSearchViewDidClicked:self.open];
    }
}

-(void)setShow:(BOOL)show{
    _show = show;
    
    if ([self.delegate respondsToSelector:@selector(crmSearchViewDidFilterBtn:)]) {
        [self.delegate crmSearchViewDidFilterBtn:self.show];
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
