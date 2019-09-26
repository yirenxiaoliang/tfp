//
//  TFTitleView.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/3/2.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFTitleView.h"


@interface TFTitleView ()

/** titleLabel */
@property (nonatomic, weak) UILabel *titleLabel;
/** titleLabel */
@property (nonatomic, weak) UIImageView *arrowImage;

@end


@implementation TFTitleView

-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        UILabel *label = [[UILabel alloc] init];
        label.font = FONT(18);
        label.textColor = BlackTextColor;
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        self.titleLabel = label;
        
        UIImageView *image = [[UIImageView alloc] init];
        image.contentMode = UIViewContentModeCenter;
        image.image = [UIImage imageNamed:@"展开"];
        [self addSubview:image];
        self.arrowImage = image;
        self.arrowImage.transform = CGAffineTransformRotate(self.arrowImage.transform, M_PI);
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewClicked)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

-(void)setSelected:(BOOL)selected{
    _selected = selected;
    
    [self animation];
    
    if ([self.delegate respondsToSelector:@selector(titleViewClickedWithSelect:)]) {
        [self.delegate titleViewClickedWithSelect:self.selected];
    }
}

- (void)animation{
    if (!self.selected) {
        
        [UIView animateWithDuration:0.25 animations:^{
            
            self.arrowImage.transform = CGAffineTransformRotate(self.arrowImage.transform, M_PI);
        }];
        
    }else{
        
        [UIView animateWithDuration:0.25 animations:^{
            self.arrowImage.transform = CGAffineTransformRotate(self.arrowImage.transform, M_PI);
        }completion:^(BOOL finished) {
            
            CGAffineTransformIsIdentity(self.arrowImage.transform);
            
        }];
    }
}


- (void)viewClicked{
    
    self.selected = !self.selected;
    
}

- (void)refreshTitleViewWithTitle:(NSString *)title{
    
    self.titleLabel.text = title;
    
    CGSize size = [HQHelper sizeWithFont:FONT(18) maxSize:(CGSize){MAXFLOAT,MAXFLOAT} titleStr:title];
    self.titleLabel.height = self.height;
    self.titleLabel.width = size.width > SCREEN_WIDTH-3*44 ? SCREEN_WIDTH-3*44:size.width;
    self.titleLabel.center = CGPointMake(self.width/2, self.height/2);
    
    self.arrowImage.frame = CGRectMake(CGRectGetMaxX(self.titleLabel.frame), 0, 44, 44);
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
