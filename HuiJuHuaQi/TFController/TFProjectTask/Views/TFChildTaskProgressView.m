//
//  TFChildTaskProgressView.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/6/8.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFChildTaskProgressView.h"

@interface TFChildTaskProgressView ()

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIView *progressView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *progressW;

@end

@implementation TFChildTaskProgressView

- (void)awakeFromNib{
    [super awakeFromNib];
    self.bgView.backgroundColor = HexColor(0xf2f2f2);
    self.bgView.layer.cornerRadius = 5;
    self.bgView.layer.masksToBounds = YES;
    
    self.progressView.backgroundColor = GreenColor;
    self.progressView.layer.cornerRadius = 5;
    self.progressView.layer.masksToBounds = YES;
    
    self.progressLabel.textColor = GrayTextColor;
    self.progressLabel.font = FONT(12);
    
    self.progressLabel.text = @"";
}

-(void)setRate:(CGFloat)rate{
    _rate = rate;
    
    if (rate <= 0) {
        self.progressW.constant = 0;
    }else if (rate <= 1){
        self.progressW.constant = self.bgView.width * rate;
    }else{
        self.progressW.constant = self.bgView.width;
    }
    
}


+ (instancetype)childTaskProgressView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"TFChildTaskProgressView" owner:self options:nil] lastObject];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
