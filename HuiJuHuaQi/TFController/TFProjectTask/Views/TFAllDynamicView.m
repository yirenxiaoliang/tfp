//
//  TFAllDynamicView.m
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/4/22.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFAllDynamicView.h"

@interface TFAllDynamicView ()
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UIButton *arrowImage;

@end

@implementation TFAllDynamicView

-(void)awakeFromNib{
    [super awakeFromNib];
    
    self.headImage.image = IMG(@"dynamicPro");
    self.nameLabel.text = @"所有动态";
    self.nameLabel.textColor = LightBlackTextColor;
    self.nameLabel.font = FONT(14);
    [self.arrowImage setImage:IMG(@"下一级浅灰") forState:UIControlStateNormal];
    self.arrowImage.transform = CGAffineTransformRotate(self.arrowImage.transform, M_PI_2);
    self.headImage.contentMode = UIViewContentModeCenter;
    self.backgroundColor = BackGroudColor;
    [self.arrowImage addTarget:self action:@selector(arrowClicked:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)arrowClicked:(UIButton *)button{
    
    if ([self.delegate respondsToSelector:@selector(allDynamicView:didClickedArrow:)]) {
        [self.delegate allDynamicView:self didClickedArrow:button];
    }
}

+(instancetype)allDynamicView{
    TFAllDynamicView *view = [[[NSBundle mainBundle] loadNibNamed:@"TFAllDynamicView" owner:self options:nil] lastObject];
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 44);
    return view;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
