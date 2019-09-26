//
//  TFFieldView.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/6/19.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFFieldView.h"


@interface TFFieldView ()

@property (weak, nonatomic) IBOutlet UIImageView *selectImg;

@end

@implementation TFFieldView

-(void)awakeFromNib{
    [super awakeFromNib];
    self.layer.borderColor = GrayTextColor.CGColor;
    self.layer.borderWidth = 1;
    self.layer.cornerRadius = 3;
    self.layer.masksToBounds = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clicked)];
    [self addGestureRecognizer:tap];
    
    self.nameLabel.textColor = GrayTextColor;
    self.nameLabel.font = FONT(14);
    self.selectImg.hidden = YES;
    
}

- (void)clicked{
    if ([self.delegate respondsToSelector:@selector(fieldViewClicked:)]) {
        [self.delegate fieldViewClicked:self];
    }
}

-(void)setSelected:(BOOL)selected{
    
    _selected = selected;
    
    if (selected) {
        self.layer.borderWidth = 1;
        self.layer.borderColor = GreenColor.CGColor;
        self.selectImg.hidden = NO;
    }else{
        self.layer.borderWidth = 1;
        self.layer.borderColor = GrayTextColor.CGColor;
        self.selectImg.hidden = YES;
    }
    
}

+ (instancetype)fieldView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"TFFieldView" owner:self options:nil] lastObject];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
